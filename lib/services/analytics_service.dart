import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backend.dart';

/// Registro local de eventos de produto — as métricas de sucesso do MVP
/// (conclusão da 1ª lição, tentativas por item, taxa de regravação,
/// segundos enviados ao Azure).
///
/// Sem backend ainda: os eventos ficam em prefs (últimos [_maxEvents]).
/// Quando Firebase/Supabase entrar, esta classe ganha um sink remoto e a
/// instrumentação das telas não muda.
class AnalyticsService {
  AnalyticsService(this._prefs, {this.backend});

  static const _key = 'analytics_events';
  static const _maxEvents = 500;

  final SharedPreferences _prefs;
  final Backend? backend;

  static Future<AnalyticsService> load({Backend? backend}) async =>
      AnalyticsService(await SharedPreferences.getInstance(), backend: backend);

  Future<void> log(String event, [Map<String, Object?> props = const {}]) async {
    final entry = jsonEncode({
      't': DateTime.now().toIso8601String(),
      'e': event,
      if (props.isNotEmpty) 'p': props,
    });
    debugPrint('[analytics] $entry');
    final events = _prefs.getStringList(_key) ?? [];
    events.add(entry);
    if (events.length > _maxEvents) {
      events.removeRange(0, events.length - _maxEvents);
    }
    await _prefs.setStringList(_key, events);
    backend?.pushEvent(event, props); // espelho durável p/ métricas do MVP
  }

  /// Eventos brutos (JSON por linha) — para inspeção/export durante o beta.
  List<String> dump() => _prefs.getStringList(_key) ?? const [];
}
