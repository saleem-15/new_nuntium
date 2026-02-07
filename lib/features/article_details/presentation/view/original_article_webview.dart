import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:new_nuntium/core/resources/app_assets.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/widgets/app_back_button.dart';
import 'package:new_nuntium/core/widgets/primary_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controller/original_article_controller.dart';

class OriginalArticleWebView extends GetView<OriginalArticleController> {
  const OriginalArticleWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(
          AppStrings.originalArticle,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. The WebView Widget
          WebViewWidget(controller: controller.webViewController),

          // 2. Loading & Error Handling (Reactive)
          Obx(() {
            if (controller.isLoading.value) {
              return Center(child: Lottie.asset(AppAssets.loading, width: 150));
            }

            if (controller.isError.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      AppAssets.errorNoInternet,
                      width: 200,
                      repeat: false,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: PrimaryButton(
                        text: AppStrings.retry,
                        onPressed: controller.onRefresh,
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
