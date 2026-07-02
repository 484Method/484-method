import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Web: cria um Blob e clica num <a download> pra baixar o CSV no navegador.
void downloadCsv(String filename, String content) {
  final blob = web.Blob(
    [content.toJS].toJS,
    web.BlobPropertyBag(type: 'text/csv;charset=utf-8'),
  );
  final url = web.URL.createObjectURL(blob);
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = filename;
  anchor.click();
  web.URL.revokeObjectURL(url);
}
