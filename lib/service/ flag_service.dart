// lib/flag_service.dart
import 'dart:convert';
import 'package:flagsmith/flagsmith.dart';

class FlagService {
  static const String _apiKey =
      '4mEE5uDk3sS8MK6v6FLZpB'; // Замените на ваш реальный ключ

  late final FlagsmithClient _flagsmithClient;
  bool showWebView = false;
  Map<String, String> webViewConfig = {};

  /// Инициализация клиента Flagsmith и загрузка флагов
  Future<void> init() async {
    try {
      print('Инициализация Flagsmith клиента...');
      _flagsmithClient = await FlagsmithClient.init(
        apiKey: _apiKey,
        config: const FlagsmithConfig(
          caches: true, // Включаем кэширование флагов
        ),
      );
      print('Flagsmith клиент успешно инициализирован.');

      print('Загрузка фич-флагов из Flagsmith...');
      await _flagsmithClient.getFeatureFlags(reload: true);
      print('Фич-флаги успешно загружены.');

      // Получаем значение флага appConfig
      String? appConfigString =
          await _flagsmithClient.getFeatureFlagValue('appconfig');
      print('Получено значение флага appConfig: $appConfigString');

      if (appConfigString != null && appConfigString.isNotEmpty) {
        try {
          final configJson =
              jsonDecode(appConfigString) as Map<String, dynamic>;

          // Извлекаем showWebView
          showWebView = configJson['showWebView'] as bool? ?? false;
          print('showWebView: $showWebView');

          // Извлекаем webViewConfig
          final wvc =
              configJson['webViewConfig'] as Map<String, dynamic>? ?? {};
          // Преобразуем динамическую Map в Map<String, String>
          webViewConfig =
              wvc.map((key, value) => MapEntry(key, value.toString()));
          print('webViewConfig: $webViewConfig');
        } catch (e) {
          print('Ошибка при парсинге appConfig: $e');
          showWebView = false;
          webViewConfig = {};
        }
      } else {
        // Если флаг пуст или не найден
        print('Флаг appConfig пуст или не найден.');
        showWebView = false;
        webViewConfig = {};
      }
    } catch (e) {
      print('Ошибка при инициализации Flagsmith: $e');
      showWebView = false;
      webViewConfig = {};
    }
  }

  /// Закрытие клиента Flagsmith
  void close() {
    _flagsmithClient.close();
    print('Flagsmith клиент закрыт.');
  }
}
