import 'package:flutter/material.dart';
import 'package:tute/core/components/custom_drawer_tile.dart';
import 'package:tute/view/settings/settings_view.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Icon(
                Icons.person,
                size: 75,
              ),
            ),
            const SizedBox(height: 25),
            CustomDrawerTile(
              title: 'H O M E',
              icon: Icons.home,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            CustomDrawerTile(
              title: 'P R O F I L E',
              icon: Icons.person,
              onTap: () {},
            ),
            CustomDrawerTile(
              icon: Icons.settings,
              title: 'S E T T I N G S',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsView(),
                  ),
                );
              },
            ),
            const Spacer(),
            CustomDrawerTile(
              title: 'L O G O U T',
              icon: Icons.logout,
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
