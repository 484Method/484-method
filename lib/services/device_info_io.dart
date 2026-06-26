import 'dart:io';

/// Mobile/desktop (Android, iOS, etc.): sem conceito de "navegador", só SO.
Map<String, String> collectDeviceInfo() => {
      'browser': 'n/a',
      'os': Platform.operatingSystem,
      'locale': Platform.localeName,
    };
