import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tute/core/components/custom_settings_tile.dart';
import 'package:tute/core/helper/navigate_helper.dart';
import 'package:tute/core/theme/theme_provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S E T T I N G S'),
      ),
      body: Column(
        children: [
          CustomSettingsTile(
              action: Switch(
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                },
                value: Provider.of<ThemeProvider>(context, listen: true).isDarkMode,
              ),
              title: 'Theme Mode'),
          GestureDetector(
            onTap: () => goBlockedPage(context),
            child: CustomSettingsTile(
                action: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () => goBlockedPage(context),
                ),
                title: 'Blocked Users'),
          ),
          CustomSettingsTile(
              action: IconButton(
                onPressed: () => goDeleteAccountPage(context),
                icon: const Icon(Icons.delete),
                color: Theme.of(context).colorScheme.primary,
              ),
              title: 'Delete Account')
        ],
      ),
    );
  }
}
