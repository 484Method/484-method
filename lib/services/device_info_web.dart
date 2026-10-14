import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

/// Browser/SO/idioma agregados — nunca a string de user-agent crua, só as
/// categorias derivadas dela. Idioma do navegador é o proxy de região/local
/// usado aqui (sem geolocalização por GPS, que exigiria permissão própria).
/// `source` é a fonte de aquisição (de onde a pessoa veio): UTM/ref na URL,
/// ou o host de quem linkou, ou "direct".
Map<String, String> collectDeviceInfo() {
  final ua = web.window.navigator.userAgent;
  return {
    'browser': _detectBrowser(ua),
    'os': _detectOs(ua),
    // Aberto pelo ícone da tela de início (app instalado) ou no navegador:
    // é o que mede se o "Instale o 484" pegou.
    'display': isInstalledApp() ? 'standalone' : 'browser',
    'locale': web.window.navigator.language,
    'source': _detectSource(),
  };
}

/// Fonte de aquisição, em ordem de prioridade:
/// 1. UTM/ref na URL (link de campanha: ?utm_source=instagram, ?ref=...);
/// 2. referrer — só o host de quem linkou (ex.: t.co, l.instagram.com),
///    ignorando navegação interna do próprio site;
/// 3. "direct" quando não há nem um nem outro (digitou, salvou, app).
String _detectSource() {
  final params = Uri.base.queryParameters;
  final utm = params['utm_source'] ?? params['ref'] ?? params['source'];
  if (utm != null && utm.trim().isNotEmpty) return utm.trim().toLowerCase();

  final ref = web.document.referrer;
  if (ref.isNotEmpty) {
    final host = Uri.tryParse(ref)?.host ?? '';
    if (host.isNotEmpty && host != web.window.location.hostname) {
      return host.toLowerCase();
    }
  }
  return 'direct';
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

/// Rodando como app instalado (ícone na tela de início), não numa aba.
/// iOS antigo só expõe `navigator.standalone`; os demais respondem à media
/// query `display-mode: standalone` (manifest.json pede "standalone").
bool isInstalledApp() {
  try {
    if (web.window.matchMedia('(display-mode: standalone)').matches) {
      return true;
    }
    final v = (web.window.navigator as JSObject)
        .getProperty<JSAny?>('standalone'.toJS);
    return v.isA<JSBoolean>() && (v as JSBoolean).toDart;
  } catch (_) {
    return false;
  }
}

/// Onde dá pra "instalar" o app web na tela de início, pra a home mostrar o
/// passo a passo certo: 'ios' (Safari: Compartilhar → Adicionar à Tela de
/// Início), 'android' (Chrome: menu → Instalar app) ou null (desktop, ou já
/// instalado — aí não há o que sugerir).
String? installTarget() {
  if (isInstalledApp()) return null;
  final ua = web.window.navigator.userAgent;
  if (RegExp('iPhone|iPad|iPod').hasMatch(ua)) return 'ios';
  if (ua.contains('Android')) return 'android';
  return null;
}
