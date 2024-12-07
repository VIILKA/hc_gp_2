import 'package:flutter/material.dart';

class AppTheme {
  // Текстовые стили
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    height: 1.25, // 40px line height
    fontWeight: FontWeight.bold,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 24,
    height: 1.33, // 32px line height
    fontWeight: FontWeight.w600,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 18,
    height: 1.33, // 32px line height
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    height: 1.375, // 22px line height
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    height: 1.375, // 22px line height
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    height: 1.43, // 20px line height
    fontWeight: FontWeight.normal,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    height: 1.43, // 20px line height
    fontWeight: FontWeight.w500,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    height: 1.5, // 18px line height
    fontWeight: FontWeight.normal,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    height: 1.4, // 14px line height
    fontWeight: FontWeight.normal,
  );

  // Цветовые стили
  static const Color background = Color.fromRGBO(36, 35, 33, 1);
  static const Color primary = Color(0xff798FD0);
  static const Color onPrimary = Color.fromRGBO(231, 230, 228, 0.4);
  static const Color secondary = Color(0xFFE7E6E4);
  static const Color onSurface = Color.fromRGBO(121, 143, 208, 0.5);
  static const Color surface = Color.fromRGBO(121, 143, 208, 0.08);
  static const Color menu = Color(0xFF4A4A4C);
  static const Color gradient = Color(0xFF1A237E);
  static const Color outline = Color(0xFFBDBDBD);

  // Пример градиента (опционально)

  // Метод для применения темы к виджету
}
