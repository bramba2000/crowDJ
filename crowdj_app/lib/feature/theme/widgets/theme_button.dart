import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../providers/theme.dart';

class ThemeButton extends ConsumerWidget {
  final Color? color;
  final Color? iconColor;

  const ThemeButton({
    super.key,
    this.color,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final icon = switch (ref.watch(themeNotifierProvider)) {
      ThemeMode.light => Icons.light_mode,
      ThemeMode.dark => Icons.dark_mode,
      ThemeMode.system => Icons.brightness_auto,
    };

    return IconButton(
      color: color,
      onPressed: ref.read(themeNotifierProvider.notifier).toggleTheme,
      icon: Icon(icon, color: iconColor),
    );
  }
}
