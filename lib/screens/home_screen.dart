// import 'package:chat_app/screens/chat_screen.dart';
// import 'package:chat_app/screens/homechat_screen.dart';
// import 'package:chat_app/screens/setting_screen.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   static const String routeName = '/home';
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final List<Map<String, dynamic>> _listScreen = [
//     {'name': 'Chat', 'screen': const ChatScreen()},
//     {'name': 'Profile', 'screen': const SettingScreen()}
//   ];
//   int _currentIndex = 0;
//   void _setCurrentIndex(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//   // Future<void> _showDeviceToken() async{
//   //   final fcmToken = await FirebaseMessaging.instance.getToken();
//   //   print(fcmToken);
//   // }
//   @override
//   void initState() {
//     // _showDeviceToken();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(_listScreen[_currentIndex]['name'] as String),
//       ),
//       body: _listScreen[_currentIndex]['screen'] as Widget,
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         selectedItemColor: Theme.of(context).colorScheme.primary,
//         unselectedItemColor: Colors.grey,
//         backgroundColor: Colors.white,
//         // showSelectedLabels: false,
//         // showUnselectedLabels: false,
//         iconSize: 30,
//         onTap: _setCurrentIndex,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat_bubble_rounded), label: 'Chats'
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person), label: 'Profile'
//           ),
//         ],
//       ),
//     );
//   }
// }
