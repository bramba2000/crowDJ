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

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  List<MenuItemButton> _buildMenuItems(WidgetRef ref) {
    return ThemeMode.values.map((mode) {
      final icon = switch (mode) {
        ThemeMode.light => Icons.light_mode,
        ThemeMode.dark => Icons.dark_mode,
        ThemeMode.system => Icons.brightness_auto,
      };

      return MenuItemButton(
        onPressed: () =>
            ref.read(themeNotifierProvider.notifier).setThemeMode(mode),
        leadingIcon: Icon(icon, color: iconColor),
        child: Center(child: Text(_capitalize(mode.name))),
      );
    }).toList();
  }

  void _toggleMenu(MenuController controller) {
    controller.isOpen ? controller.close() : controller.open();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final icon = switch (ref.watch(themeNotifierProvider)) {
      ThemeMode.light => Icons.light_mode,
      ThemeMode.dark => Icons.dark_mode,
      ThemeMode.system => Icons.brightness_auto,
    };

    return MenuAnchor(
      menuChildren: _buildMenuItems(ref),
      builder: (context, controller, child) => IconButton(
        icon: Icon(icon, color: iconColor),
        onPressed: () => _toggleMenu(controller),
      ),
      style: const MenuStyle(
        alignment: Alignment(-3, 1),
      ),
      alignmentOffset: const Offset(-15, 0),
    );
  }
}
