import 'dart:io';

void enableInsecureHttp() {
  HttpOverrides.global = _MyHttpOverrides();
}

class _MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
