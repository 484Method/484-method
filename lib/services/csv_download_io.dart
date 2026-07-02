import 'package:flutter/foundation.dart';

/// Mobile/desktop: o painel do dev é usado na web, então aqui é no-op (só
/// registra). Se um dia precisar exportar no mobile, plugar share_plus/arquivo.
void downloadCsv(String filename, String content) {
  debugPrint(
      '[csv] download indisponível nesta plataforma ($filename, ${content.length} bytes)');
}
