import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import './firebase_options.dart';
import 'core/router/router.dart';
import 'feature/theme/constants/color_schemes.g.dart';
import 'feature/theme/providers/CustomColorScheme.dart';
import 'feature/theme/providers/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await loadJsonData();
  usePathUrlStrategy();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      theme: ThemeData.from(colorScheme: lightColorScheme),
      darkTheme:
          //ThemeData.from(colorScheme: darkColorScheme2), //darkColorScheme
          ThemeData.from(colorScheme: darkColorScheme3),
      themeMode: ref.watch(themeNotifierProvider),
      title: "CrowDJ",
      supportedLocales: const [Locale('en', 'US'), Locale('it', 'IT')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

Future<void> loadJsonData() async {
  // Load the JSON file
  String jsonString =
      await rootBundle.loadString('lib/feature/theme/constants/theme3.json');
  // Parse the JSON string
  Map<String, dynamic> jsonFile = json.decode(jsonString);

  darkColorScheme3 = CustomColorScheme.colorSchemeFromJson(jsonFile);
}
