import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../feature/auth/data/auth_data_source.dart';
import '../../../feature/auth/data/user_data_source.dart';
import '../../../feature/auth/providers/authentication_provider.dart';
import '../../../feature/auth/widgets/utils/theme_action_button.dart';

class CustomAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget{

  String text;
  final provider = authNotifierProvider(AuthDataSource(), UserDataSource());

  CustomAppBar({required this.text});
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  
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
          themeActionButton,
        ],
      );
  }
  

}