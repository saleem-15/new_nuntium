import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/config/dependency_injection.dart';
import 'package:new_nuntium/core/network/network_info.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OriginalArticleWebViewController extends GetxController {
  final String url;

  OriginalArticleWebViewController(this.url);

  final _networkInfo = getIt<NetworkInfo>();
  late final WebViewController webViewController;

  var isLoading = true.obs;
  var isError = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initWebView();
  }

  void _initWebView() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF))
      // Add channel to recieve (page is loaded) message
      ..addJavaScriptChannel(
        'PageLoadChannel',
        onMessageReceived: (JavaScriptMessage message) {
          // When the page is 'Ready'(page Content is visible to the user) remove loading animation
          if (message.message == 'DomReady') {
            isLoading.value = false;
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (_) => NavigationDecision.navigate,
          onPageStarted: _onPageStarted,
          onProgress: _onProgress,
          onPageFinished: _onPageFinished,
          onWebResourceError: _onWebResourceError,
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  void _onPageStarted(String url) {
    isLoading.value = true;
    isError.value = false;
  }

  /// Early JavaScript injection
  void _onProgress(int progress) {
    if (progress > 10) {
      _injectDomListener();
    }
  }

  /// Late JavaScript injection, Acts as a fallback if the early injection has failed
  /// Checks if the event was already missed and manually triggers the "stop loading" logic if the page is already done.
  void _onPageFinished(String url) {
    isLoading.value = false;

    _injectDomListener();
  }

  Future<void> _onWebResourceError(WebResourceError error) async {
    // if an error happened to main frame (Not minor error)
    if (error.isForMainFrame ?? false) {
      isLoading.value = false;
      isError.value = true;

      if (!await _networkInfo.isConnected) {
        isLoading.value = false;
        isError.value = true;

        // Load empty page to hide No internet error page
        await webViewController.loadHtmlString(
          "<html><body style='background-color: white;'></body></html>",
        );
      }
    }
  }

  /// Injects JavaScript code that monitors if the page is ready (pagee content is viewed for the user)
  void _injectDomListener() {
    webViewController.runJavaScript('''
      // نتحقق مما إذا كانت الصفحة جاهزة بالفعل
      if (document.readyState === "complete" || document.readyState === "interactive") {
        PageLoadChannel.postMessage('DomReady');
      } else {
        // إذا لم تكن جاهزة، نستمع لحدث DOMContentLoaded
        window.addEventListener('DOMContentLoaded', (event) => {
          PageLoadChannel.postMessage('DomReady');
        });
      }
    ''');
  }

  void onRefresh() async {
    // عند المحاولة مرة أخرى، نخفي واجهة الخطأ ونعيد التحميل
    if (await _networkInfo.isConnected) {
      isError.value = false;
      isLoading.value = true;
      webViewController.loadRequest(Uri.parse(url));
    } else {
      // إذا لا يزال لا يوجد إنترنت، نبقي حالة الخطأ
      isError.value = true;
    }
  }
}
