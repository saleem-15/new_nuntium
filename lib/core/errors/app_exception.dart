class AppException implements Exception {
  final String messageKey;

  AppException(this.messageKey);

  @override
  String toString() => messageKey;
}