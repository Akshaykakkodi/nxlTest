import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test/application/core/theme/text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(bodyMedium: baseTestStyle),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    ),
  );
}
