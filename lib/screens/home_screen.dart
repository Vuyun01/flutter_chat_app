import 'package:chat_app/provider/settings_provider.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/homechat_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/screens/setting_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _listScreen = [
    {'name': 'Chats', 'screen': const HomeChatScreen()},
    {'name': 'My Profile', 'screen': const ProfileScreen()}
  ];
  int _currentIndex = 0;
  void _setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Future<void> _showDeviceToken() async{
  //   final fcmToken = await FirebaseMessaging.instance.getToken();
  //   print(fcmToken);
  // }
  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Provider.of<SettingsProvider>(context).isDark;
    return Scaffold(
      backgroundColor: isDarkTheme ? darkTheme : null,
      appBar: AppBar(
        backgroundColor:
            isDarkTheme ? Theme.of(context).colorScheme.tertiary : null,
        centerTitle: true,
        title: Text(_listScreen[_currentIndex]['name'] as String),
      ),
      body: _listScreen[_currentIndex]['screen'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor:
            isDarkTheme ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.secondary,
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        iconSize: 30,
        onTap: _setCurrentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
