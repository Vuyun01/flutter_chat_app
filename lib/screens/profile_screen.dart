import 'package:chat_app/constant.dart';
import 'package:chat_app/screens/personal_info_screen.dart';
import 'package:chat_app/screens/setting_screen.dart';
import 'package:chat_app/widgets/custom_icon_button.dart';
import 'package:chat_app/widgets/profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/color_screen_theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isDarkMode = Provider.of<ColorScreenTheme>(context).isDark;
    return Scaffold(
        backgroundColor: isDarkMode ? darkTheme : null,
        appBar: AppBar(
          backgroundColor:
              isDarkMode ? Theme.of(context).colorScheme.tertiary : null,
          title: const Text('My Profile'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              height: size.height * 0.05,
            ),
            const ProfilePicture(),
            SizedBox(
              height: size.height * 0.05,
            ),
            CustomIconButton(
                color: isDarkMode
                    ? borderLine
                    : Theme.of(context).colorScheme.primary,
                text: 'Personal Information',
                icon: Icons.person,
                onPress: () {
                  Navigator.of(context)
                      .pushNamed(PersonalInfomationScreen.routeName);
                }),
            const SizedBox(height: 20),
            CustomIconButton(
                color: isDarkMode
                    ? borderLine
                    : Theme.of(context).colorScheme.primary,
                text: 'Setttings',
                icon: Icons.settings_rounded,
                onPress: () =>
                    Navigator.of(context).pushNamed(SettingScreen.routeName)),
            const SizedBox(height: 20),
            CustomIconButton(
                color: isDarkMode
                    ? borderLine
                    : Theme.of(context).colorScheme.primary,
                text: 'Log Out',
                icon: Icons.logout,
                onPress: () async {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Sign out the account successfully!'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ));
                  final prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop();
                }),
            const Spacer(),
            Text(
              'Designed by vuyun',
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  color: isDarkMode ? lightTheme : null,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ));
  }
}
