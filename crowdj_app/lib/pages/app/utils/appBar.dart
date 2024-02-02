import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../feature/auth/data/auth_data_source.dart';
import '../../../feature/auth/data/user_data_source.dart';
import '../../../feature/auth/providers/authentication_provider.dart';
import '../../../feature/theme/widgets/theme_button.dart';

class CustomAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final String text;
  final provider = authNotifierProvider(AuthDataSource(), UserDataSource());

  CustomAppBar({super.key, required this.text});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.text),
      actions: [
        IconButton(
          onPressed: () {
            ref.read(widget.provider.notifier).signOut();
          },
          icon: const Icon(Icons.exit_to_app),
        ),
        const ThemeButton(),
      ],
    );
  }
}
