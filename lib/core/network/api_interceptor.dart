import 'package:dio/dio.dart';
import 'api_constants.dart';


///هذا "المعترض" وظيفته إضافة مفتاح الـ API تلقائياً لكل طلب يخرج من التطبيق، مما يجعل الكود أنظف ويمنع تكرار كتابة المفتاح.
/// Interceptor to inject the API Key into every request query parameters.
class ApiKeyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Clone the query parameters map to avoid modifying a locked map
    final queryParams = Map<String, dynamic>.from(options.queryParameters);
    
    // Inject the API Key if not already present
    if (!queryParams.containsKey(ApiConstants.paramApiKey)) {
      queryParams[ApiConstants.paramApiKey] = ApiConstants.apiKey;
    }

    // Update the request options with the new query parameters
    options.queryParameters = queryParams;

    // Continue with the request
    super.onRequest(options, handler);
  }
}