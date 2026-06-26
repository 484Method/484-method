import 'package:web/web.dart' as web;

/// Browser/SO/idioma agregados — nunca a string de user-agent crua, só as
/// categorias derivadas dela. Idioma do navegador é o proxy de região/local
/// usado aqui (sem geolocalização por GPS, que exigiria permissão própria).
Map<String, String> collectDeviceInfo() {
  final ua = web.window.navigator.userAgent;
  return {
    'browser': _detectBrowser(ua),
    'os': _detectOs(ua),
    'locale': web.window.navigator.language,
  };
}

String _detectBrowser(String ua) {
  if (ua.contains('Edg/')) return 'Edge';
  if (ua.contains('OPR/') || ua.contains('Opera')) return 'Opera';
  if (ua.contains('Firefox')) return 'Firefox';
  if (ua.contains('CriOS')) return 'Chrome (iOS)';
  if (ua.contains('Chrome')) return 'Chrome';
  if (ua.contains('Safari')) return 'Safari';
  return 'Outro';
}

String _detectOs(String ua) {
  if (ua.contains('Android')) return 'Android';
  if (ua.contains('iPhone') || ua.contains('iPad') || ua.contains('iOS')) {
    return 'iOS';
  }
  if (ua.contains('Mac OS X') || ua.contains('Macintosh')) return 'macOS';
  if (ua.contains('Windows')) return 'Windows';
  if (ua.contains('Linux')) return 'Linux';
  return 'Outro';
}
