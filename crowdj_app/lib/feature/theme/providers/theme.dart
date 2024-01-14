import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void toggleTheme() {
    if (state == ThemeMode.system) {
      state = SchedulerBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.light
          ? ThemeMode.light
          : ThemeMode.dark;
    } else {
      state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    }
  }
}
