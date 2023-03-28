import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/homechat_screen.dart';
import 'package:chat_app/screens/personal_info_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/widgets/custom_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/color_screen_theme_provider.dart';
import 'screens/setting_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //init firebase to use all firebase's products
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ColorScreenTheme(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: CustomTheme(context),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapShot) {
              if (streamSnapShot.hasData) {
                return const ChatScreen();
              }
              if (streamSnapShot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              return const AuthScreen();
            }),
        routes: {
          ChatScreen.routeName: (context) => const ChatScreen(),
          AuthScreen.routeName: (context) => const AuthScreen(),
          SettingScreen.routeName: (context) => const SettingScreen(),
          ProfileScreen.routeName: (context) => const ProfileScreen(),
          // HomeScreen.routeName : (context) => const HomeScreen(),
          // HomeChatScreen.routeName : (context) => const HomeChatScreen(),
          PersonalInfomationScreen.routeName: (context) =>
              const PersonalInfomationScreen()
        },
      ),
    );
  }
}
