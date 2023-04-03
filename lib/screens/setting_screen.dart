import 'package:chat_app/constant.dart';
import 'package:chat_app/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  static const String routeName = '/settings';
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late SettingsProvider Darkmode;
  @override
  void initState() {
    Darkmode = Provider.of<SettingsProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Darkmode.isDark;
    return Scaffold(
      backgroundColor: isDarkMode ? darkTheme : lightTheme,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:
            isDarkMode ? Theme.of(context).colorScheme.tertiary : null,
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          SwitchListTile.adaptive(
              activeColor: Theme.of(context).colorScheme.primary,
              title: Text(
                'Dark mode',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: isDarkMode ? lightTheme : darkTheme),
              ),
              value: isDarkMode,
              onChanged: ((value) {
                setState(() {
                  Darkmode.changeBackgroundColor(value);
                });
                print(isDarkMode);
              }))
        ],
      ),
    );
  }
}
