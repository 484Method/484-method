// Dispara o download de um CSV. Abstração de plataforma (como device_info):
// na web usa a API do navegador (Blob + <a download>), no mobile é no-op
// (o painel do dev roda na web). Ver csv_download_web.dart / csv_download_io.dart.
export 'csv_download_io.dart'
    if (dart.library.js_interop) 'csv_download_web.dart';
