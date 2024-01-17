import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF006874),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFF96F1FF),
  onPrimaryContainer: Color(0xFF001F24),
  secondary: Color(0xFF715C00),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFFFE17B),
  onSecondaryContainer: Color(0xFF231B00),
  tertiary: Color(0xFF904D00),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFDCC3),
  onTertiaryContainer: Color(0xFF2F1500),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFF8FDFF),
  onBackground: Color(0xFF001F25),
  surface: Color(0xFFF8FDFF),
  onSurface: Color(0xFF001F25),
  surfaceVariant: Color(0xFFDBE4E6),
  onSurfaceVariant: Color(0xFF3F484A),
  outline: Color(0xFF6F797A),
  onInverseSurface: Color(0xFFD6F6FF),
  inverseSurface: Color(0xFF00363F),
  inversePrimary: Color(0xFF4CD8EB),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF006874),
  outlineVariant: Color(0xFFBFC8CA),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF4CD8EB),
  onPrimary: Color(0xFF00363D),
  primaryContainer: Color(0xFF004F57),
  onPrimaryContainer: Color(0xFF96F1FF),
  secondary: Color(0xFFE6C449),
  onSecondary: Color(0xFF3B2F00),
  secondaryContainer: Color(0xFF564500),
  onSecondaryContainer: Color(0xFFFFE17B),
  tertiary: Color(0xFFFFB77C),
  onTertiary: Color(0xFF4D2600),
  tertiaryContainer: Color(0xFF6E3900),
  onTertiaryContainer: Color(0xFFFFDCC3),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF001F25),
  onBackground: Color(0xFFA6EEFF),
  surface: Color(0xFF001F25),
  onSurface: Color(0xFFA6EEFF),
  surfaceVariant: Color(0xFF3F484A),
  onSurfaceVariant: Color(0xFFBFC8CA),
  outline: Color(0xFF899294),
  onInverseSurface: Color(0xFF001F25),
  inverseSurface: Color(0xFFA6EEFF),
  inversePrimary: Color(0xFF006874),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF4CD8EB),
  outlineVariant: Color(0xFF3F484A),
  scrim: Color(0xFF000000),
);

const ColorScheme darkLavaColorScheme = ColorScheme(
  primary: Color(0xFFE57373), // Primary color
  primaryContainer: Color(0xFFB71C1C), // Darker shade of primary color
  secondary: Color(0xFFFFB74D), // Secondary color
  secondaryContainer: Color(0xFFFF9800), // Darker shade of secondary color
  surface: Color(0xFF263238), // Surface color (background)
  background: Color(0xFF212121), // Background color
  error: Color(0xFFB00020), // Error color
  onPrimary: Colors.white, // Text/icon color on primary color
  onSecondary: Colors.black, // Text/icon color on secondary color
  onSurface: Colors.white, // Text/icon color on surface color
  onBackground: Colors.white, // Text/icon color on background color
  onError: Colors.white, // Text/icon color on error color
  brightness: Brightness.dark, // Dark theme
);

ColorScheme darkColorScheme2 = ColorScheme(
    background: Color(int.parse("#ff0e0e0e".replaceAll('#', '0xFF'))),
    brightness: Brightness.dark,
    error: Color(int.parse("#ffcf6679".replaceAll('#', '0xFF'))),
    errorContainer: Color(int.parse("#ffcf6679".replaceAll('#', '0xFF'))),
    inversePrimary: Color(int.parse("#ff000000".replaceAll('#', '0xFF'))),
    inverseSurface: Color(int.parse("#ffffffff".replaceAll('#', '0xFF'))),
    onBackground: Color(int.parse("#ffffffff".replaceAll('#', '0xFF'))),
    onError: Color(int.parse("#ff000000".replaceAll('#', '0xFF'))),
    onPrimary: Color(int.parse("#ff000000".replaceAll('#', '0xFF'))),
    onSecondary: Color(int.parse("#ff000000".replaceAll('#', '0xFF'))),
    onSurface: Color(int.parse("#ffffffff".replaceAll('#', '0xFF'))),
    onTertiary: Color(int.parse("#ff000000".replaceAll('#', '0xFF'))),
    primary: Color(0XFFf5b6b4),
    primaryContainer: Color(int.parse("#ff000000".replaceAll('#', '0xFF'))),
    scrim: Color(int.parse("#ff000000".replaceAll('#', '0xFF'))),
    secondary: Color(int.parse("#ff5adcb4".replaceAll('#', '0xFF'))),
    secondaryContainer: Color(int.parse("#ff4dbd9b".replaceAll('#', '0xFF'))),
    surface: Color(int.parse("#ff451654".replaceAll('#', '0xFF'))),
    
  );

