import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hc_gp_2/service/%20flag_service.dart';
import 'package:hc_gp_2/service/location_service.dart';
import 'package:hc_gp_2/webview_page.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});
  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final FlagService _flagService = FlagService();
  final LocationService _locationService = LocationService();

  bool _isLoading = true;
  bool _shouldShowWebView = false;
  String _webViewUrl = '';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Проверяем наличие интернет-соединения
    var connectivityResult = await Connectivity().checkConnectivity();
    bool hasInternet = connectivityResult != ConnectivityResult.none;

    if (!hasInternet) {
      // Нет интернета - открываем приложение сразу
      _navigateToApp();
      return;
    }

    try {
      // Инициализируем Flagsmith и грузим appConfig
      await _flagService.init();

      if (_flagService.showWebView) {
        // Определяем страну пользователя
        String? countryCode = await _locationService.getCountryCode();

        if (countryCode != null &&
            _flagService.webViewConfig.containsKey(countryCode)) {
          // Страна есть в списке для WebView
          _navigateToWebView(_flagService.webViewConfig[countryCode]!);
        } else {
          // Либо страна не определена, либо её нет в списке
          _navigateToApp();
        }
      } else {
        // showWebView = false
        _navigateToApp();
      }
    } catch (e) {
      print('Ошибка при инициализации или определении местоположения: $e');
      // При ошибке открываем приложение
      _navigateToApp();
    }
  }

  void _navigateToApp() {
    setState(() {
      _shouldShowWebView = false;
      _isLoading = false;
    });
  }

  void _navigateToWebView(String url) {
    setState(() {
      _shouldShowWebView = true;
      _webViewUrl = url;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Показать индикатор загрузки
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_shouldShowWebView && _webViewUrl.isNotEmpty) {
      // Показать WebView
      return WebviewPage(url: _webViewUrl);
    }

    // Показать основное приложение
    return Scaffold(
      appBar: AppBar(
        title: const Text('Основное приложение'),
      ),
      body: const Center(
        child: Text(
          'Добро пожаловать!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _flagService.close();
    super.dispose();
  }
}
