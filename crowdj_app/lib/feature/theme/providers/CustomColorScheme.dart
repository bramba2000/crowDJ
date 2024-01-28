import 'package:flutter/material.dart';

class CustomColorScheme {
  final Color background;
  final Brightness brightness;
  final Color error;
  final Color errorContainer;
  final Color inversePrimary;
  final Color inverseSurface;
  final Color onBackground;
  final Color onError;
  final Color onErrorContainer;
  final Color onInverseSurface;
  final Color onPrimary;
  final Color onPrimaryContainer;
  final Color onSecondary;
  final Color onSecondaryContainer;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color onTertiary;
  final Color onTertiaryContainer;
  final Color outline;
  final Color outlineVariant;
  final Color primary;
  final Color primaryContainer;
  final Color scrim;
  final Color secondary;
  final Color secondaryContainer;
  final Color shadow;
  final Color surface;
  final Color surfaceTint;
  final Color surfaceVariant;
  final Color tertiary;
  final Color tertiaryContainer;

  CustomColorScheme({
    required this.background,
    required this.brightness,
    required this.error,
    required this.errorContainer,
    required this.inversePrimary,
    required this.inverseSurface,
    required this.onBackground,
    required this.onError,
    required this.onErrorContainer,
    required this.onInverseSurface,
    required this.onPrimary,
    required this.onPrimaryContainer,
    required this.onSecondary,
    required this.onSecondaryContainer,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.onTertiary,
    required this.onTertiaryContainer,
    required this.outline,
    required this.outlineVariant,
    required this.primary,
    required this.primaryContainer,
    required this.scrim,
    required this.secondary,
    required this.secondaryContainer,
    required this.shadow,
    required this.surface,
    required this.surfaceTint,
    required this.surfaceVariant,
    required this.tertiary,
    required this.tertiaryContainer,
  });

  factory CustomColorScheme.fromJson(Map<String, dynamic> jsonFile) {

    final json = jsonFile['colorScheme'];

    return CustomColorScheme(
      background: Color(int.parse(json['background'].substring(1, 7), radix: 16) + 0xFF000000),
      brightness: json['brightness'] == 'dark' ? Brightness.dark : Brightness.light, 
      error: Color(int.parse(json['error'].substring(1, 7), radix: 16) + 0xFF000000),
      errorContainer: Color(int.parse(json['errorContainer'].substring(1, 7), radix: 16) + 0xFF000000),
      inversePrimary: Color(int.parse(json['inversePrimary'].substring(1, 7), radix: 16) + 0xFF000000),
      inverseSurface: Color(int.parse(json['inverseSurface'].substring(1, 7), radix: 16) + 0xFF000000),
      onBackground: Color(int.parse(json['onBackground'].substring(1, 7), radix: 16) + 0xFF000000),
      onError: Color(int.parse(json['onError'].substring(1, 7), radix: 16) + 0xFF000000),
      onErrorContainer: Color(int.parse(json['onErrorContainer'].substring(1, 7), radix: 16) + 0xFF000000),
      onInverseSurface: Color(int.parse(json['onInverseSurface'].substring(1, 7), radix: 16) + 0xFF000000),
      onPrimary: Color(int.parse(json['onPrimary'].substring(1, 7), radix: 16) + 0xFF000000),
      onPrimaryContainer: Color(int.parse(json['onPrimaryContainer'].substring(1, 7), radix: 16) + 0xFF000000),
      onSecondary: Color(int.parse(json['onSecondary'].substring(1, 7), radix: 16) + 0xFF000000),
      onSecondaryContainer: Color(int.parse(json['onSecondaryContainer'].substring(1, 7), radix: 16) + 0xFF000000),
      onSurface: Color(int.parse(json['onSurface'].substring(1, 7), radix: 16) + 0xFF000000),
      onSurfaceVariant: Color(int.parse(json['onSurfaceVariant'].substring(1, 7), radix: 16) + 0xFF000000),
      onTertiary: Color(int.parse(json['onTertiary'].substring(1, 7), radix: 16) + 0xFF000000),
      onTertiaryContainer: Color(int.parse(json['onTertiaryContainer'].substring(1, 7), radix: 16) + 0xFF000000),
      outline: Color(int.parse(json['outline'].substring(1, 7), radix: 16) + 0xFF000000),
      outlineVariant: Color(int.parse(json['outlineVariant'].substring(1, 7), radix: 16) + 0xFF000000),
      primary: Color(int.parse(json['primary'].substring(1, 7), radix: 16) + 0xFF000000),
      primaryContainer: Color(int.parse(json['primaryContainer'].substring(1, 7), radix: 16) + 0xFF000000),
      scrim: Color(int.parse(json['scrim'].substring(1, 7), radix: 16) + 0xFF000000),
      secondary: Color(int.parse(json['secondary'].substring(1, 7), radix: 16) + 0xFF000000),
      secondaryContainer: Color(int.parse(json['secondaryContainer'].substring(1, 7), radix: 16) + 0xFF000000),
      shadow: Color(int.parse(json['shadow'].substring(1, 7), radix: 16) + 0xFF000000),
      surface: Color(int.parse(json['surface'].substring(1, 7), radix: 16) + 0xFF000000),
      surfaceTint: Color(int.parse(json['surfaceTint'].substring(1, 7), radix: 16) + 0xFF000000),
      surfaceVariant: Color(int.parse(json['surfaceVariant'].substring(1, 7), radix: 16) + 0xFF000000),
      tertiary: Color(int.parse(json['tertiary'].substring(1, 7), radix: 16) + 0xFF000000),
      tertiaryContainer: Color(int.parse(json['tertiaryContainer'].substring(1, 7), radix: 16) + 0xFF000000),
      // Repeat the same process for other color properties...
    );
  }

  static colorSchemeFromJson(Map<String, dynamic> jsonFile){

    final json = jsonFile['colorScheme'];

    return ColorScheme(
      
      background: Color(int.parse(json['background'].substring(1), radix: 16)+ 0xFF000000),
      brightness: json['brightness'] == 'dark' ? Brightness.dark : Brightness.light, 
      error: Color(int.parse(json['error'].substring(1, 7), radix: 16) + 0xFF000000),
      errorContainer: Color(int.parse(json['errorContainer'].substring(1), radix: 16) + 0xFF000000),
      inversePrimary: Color(int.parse(json['inversePrimary'].substring(1), radix: 16) + 0xFF000000),
      inverseSurface: Color(int.parse(json['inverseSurface'].substring(1), radix: 16) + 0xFF000000),
      onBackground: Color(int.parse(json['onBackground'].substring(1), radix: 16) + 0xFF000000),
      onError: Color(int.parse(json['onError'].substring(1, 7), radix: 16) + 0xFF000000),
      onErrorContainer: Color(int.parse(json['onErrorContainer'].substring(1), radix: 16) + 0xFF000000),
      onInverseSurface: Color(int.parse(json['onInverseSurface'].substring(1), radix: 16) + 0xFF000000),
      onPrimary: Color(int.parse(json['onPrimary'].substring(1, 7), radix: 16) + 0xFF000000),
      onPrimaryContainer: Color(int.parse(json['onPrimaryContainer'].substring(1), radix: 16) + 0xFF000000),
      onSecondary: Color(int.parse(json['onSecondary'].substring(1, 7), radix: 16) + 0xFF000000),
      onSecondaryContainer: Color(int.parse(json['onSecondaryContainer'].substring(1), radix: 16) + 0xFF000000),
      onSurface: Color(int.parse(json['onSurface'].substring(1), radix: 16) + 0xFF000000),
      onSurfaceVariant: Color(int.parse(json['onSurfaceVariant'].substring(1), radix: 16) + 0xFF000000),
      onTertiary: Color(int.parse(json['onTertiary'].substring(1), radix: 16) + 0xFF000000),
      onTertiaryContainer: Color(int.parse(json['onTertiaryContainer'].substring(1), radix: 16) + 0xFF000000),
      outline: Color(int.parse(json['outline'].substring(1), radix: 16) + 0xFF000000),
      outlineVariant: Color(int.parse(json['outlineVariant'].substring(1), radix: 16) + 0xFF000000),
      primary: Color(int.parse(json['primary'].substring(1), radix: 16) + 0xFF000000),
      primaryContainer: Color(int.parse(json['primaryContainer'].substring(1), radix: 16) + 0xFF000000),
      scrim: Color(int.parse(json['scrim'].substring(1), radix: 16) + 0xFF000000),
      secondary: Color(int.parse(json['secondary'].substring(1), radix: 16) + 0xFF000000),
      secondaryContainer: Color(int.parse(json['secondaryContainer'].substring(1), radix: 16) + 0xFF000000),
      shadow: Color(int.parse(json['shadow'].substring(1), radix: 16) + 0xFF000000),
      surface: Color(int.parse(json['surface'].substring(1), radix: 16) + 0xFF000000),
      surfaceTint: Color(int.parse(json['surfaceTint'].substring(1), radix: 16) + 0xFF000000),
      surfaceVariant: Color(int.parse(json['surfaceVariant'].substring(1), radix: 16) + 0xFF000000),
      tertiary: Color(int.parse(json['tertiary'].substring(1), radix: 16) + 0xFF000000),
      tertiaryContainer: Color(int.parse(json['tertiaryContainer'].substring(1), radix: 16) + 0xFF000000),

    );

  }
}