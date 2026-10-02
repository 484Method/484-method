import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show FunctionException;

import 'backend.dart';
import 'pronunciation_assessor.dart';

/// Avalia a pronúncia via Edge Function `assess` (proxy do Azure no backend).
/// A chave do Azure fica como secret do Supabase — nunca no cliente, então a
/// build web pública não vaza nada. O áudio vai em base64 num JSON; a resposta
/// é o mesmo corpo do Azure, parseado por [parseAzureResponse].
class BackendPronunciationAssessor implements PronunciationAssessor {
  BackendPronunciationAssessor(this._backend);

  final Backend _backend;

  @override
  Future<PronunciationResult> assess({
    required Uint8List wavAudio,
    required String referenceText,
    int attempt = 1,
  }) async {
    try {
      // Token da sessão passado EXPLÍCITO: não confiamos no cabeçalho padrão
      // da biblioteca, que pode carregar a chave pública (não é JWT de
      // usuário) e levar 401 do gateway/da function. Se a sessão expirou,
      // renova antes (o refresh é barato e idempotente).
      final auth = _backend.client.auth;
      var session = auth.currentSession;
      if (session == null || session.isExpired) {
        try {
          session = (await auth.refreshSession()).session ?? session;
        } catch (_) {}
      }
      final token = session?.accessToken;
      final res = await _backend.client.functions.invoke(
        'assess',
        headers: token == null ? null : {'Authorization': 'Bearer $token'},
        body: {
          'referenceText': referenceText,
          'audioBase64': base64.encode(wavAudio),
          'attempt': attempt,
        },
      );
      if (res.status == 429) {
        throw PronunciationAssessmentException(
          'Você já usou toda a sua prática de hoje. Volta amanhã pra continuar.',
        );
      }
      if (res.status != 200) {
        throw PronunciationAssessmentException(
          'Não consegui avaliar agora (código ${res.status}).',
        );
      }
      final data = res.data;
      final json = data is Map<String, dynamic>
          ? data
          : jsonDecode(data as String) as Map<String, dynamic>;
      return parseAzureResponse(json);
    } on PronunciationAssessmentException {
      rethrow;
    } on FunctionException catch (e) {
      // `functions.invoke` LANÇA em qualquer resposta não-2xx, então o
      // `res.status` acima nunca vê erro: o código real chega aqui.
      debugPrint('[assessor] assess respondeu ${e.status}: ${e.details}');
      if (e.status == 429) {
        throw PronunciationAssessmentException(
          'Você já usou toda a sua prática de hoje. Volta amanhã pra continuar.',
        );
      }
      throw PronunciationAssessmentException(
        'Não consegui avaliar agora (código ${e.status}). '
        'Tente de novo em instantes. [${_short(e.details)}]',
      );
    } catch (e) {
      debugPrint('[assessor] falha na Edge Function assess: $e');
      // Sufixo com o TIPO do erro (não o texto, que pode ser longo): separa
      // rede/CORS (ClientException) de resposta mal formada (TypeError) sem
      // exigir o console do navegador de quem está testando.
      throw PronunciationAssessmentException(
        'Não consegui avaliar sua gravação agora. '
        'Confira sua conexão e tente de novo. [${e.runtimeType}]',
      );
    }
  }

  /// Corpo do erro do servidor, curto, pra aparecer na tela (diagnóstico).
  static String _short(dynamic details) {
    final t = details is String ? details : jsonEncode(details);
    return t.length > 120 ? '${t.substring(0, 120)}…' : t;
  }
}
