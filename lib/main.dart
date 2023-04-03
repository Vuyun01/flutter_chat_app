import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/provider/chat_provider.dart';
import 'package:chat_app/provider/profile_provider.dart';
import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/homechat_screen.dart';
import 'package:chat_app/screens/personal_info_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/widgets/custom_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/settings_provider.dart';
import 'screens/setting_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //init firebase to use all firebase's products
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FirebaseAuth firebaseAuth;
  late FirebaseFirestore firestore;

  @override
  void initState() {
    firebaseAuth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        Provider(
            create: (context) =>
                AuthProvider(firebaseAuth: firebaseAuth, firestore: firestore)),
        Provider(
            create: (context) => ProfileProvider(
                firebaseAuth: firebaseAuth, firestore: firestore)),
        Provider(
            create: (context) =>
                ChatProvider(firebaseAuth: firebaseAuth, firestore: firestore))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: CustomTheme(context),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapShot) {
              if (streamSnapShot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (streamSnapShot.hasError) {
                return Center(
                  child: Text(streamSnapShot.error.toString()),
                );
              }
              if (streamSnapShot.hasData) {
                return const HomeScreen();
              }
              return const AuthScreen();
            }),
        routes: {
          ChatScreen.routeName: (context) => const ChatScreen(),
          AuthScreen.routeName: (context) => const AuthScreen(),
          SettingScreen.routeName: (context) => const SettingScreen(),
          ProfileScreen.routeName: (context) => const ProfileScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          HomeChatScreen.routeName: (context) => const HomeChatScreen(),
          PersonalInfomationScreen.routeName: (context) =>
              const PersonalInfomationScreen()
        },
      ),
    );
  }
}
