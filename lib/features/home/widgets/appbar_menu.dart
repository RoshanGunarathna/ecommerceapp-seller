import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controller/auth_controller.dart';

class AppBarMenu extends StatelessWidget {
  final WidgetRef ref;
  const AppBarMenu({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        position: PopupMenuPosition.under,

        // icon by default "3 dot" icon
        itemBuilder: (context) {
          return [
            const PopupMenuItem<int>(
              value: 0,
              child: Text('Sign Out'),
            ),
          ];
        },
        onSelected: (value) {
          if (value == 0) {
            ref.read(authControllerProvider.notifier).signOut(context);
          }
        });
  }
}
