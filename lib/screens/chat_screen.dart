import 'package:chat_app/chat/chat_bar.dart';
import 'package:chat_app/chat/messages.dart';
import 'package:chat_app/constant.dart';
import 'package:chat_app/provider/color_screen_theme_provider.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/custom_drawer.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString('user'));
    prefs.clear();
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ColorScreenTheme>(context).isDark;
    return Scaffold(
      backgroundColor: isDark ? darkTheme : null,
      appBar: AppBar(
        backgroundColor: isDark ? Theme.of(context).colorScheme.tertiary : null,
        title: const Text('Chats'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
              shape: RoundedRectangleBorder(
                  //shape for its children
                  side: BorderSide(color: isDark ? darkTheme : lightTheme)),
              icon: const Icon(Icons.more_vert_outlined),
              onSelected: ((value) async{
                if (value == PopupMenuOption.logout) {
                  await _logout();
                } else {
                  await Navigator.of(context)
                      .pushNamed(ProfileScreen.routeName)
                      .then((_) {
                    setState(() {});
                  });
                }
              }),
              itemBuilder: ((context) => [
                    PopupMenuItem(
                        value: PopupMenuOption.profile,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Profile'),
                            Icon(
                              Icons.person,
                              color: Colors.black,
                            )
                          ],
                        )),
                    PopupMenuItem(
                        value: PopupMenuOption.logout,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Log Out'),
                            Icon(
                              Icons.logout,
                              color: Colors.black,
                            )
                          ],
                        )),
                  ]))
        ],
      ),
      // drawer: const CustomDrawer(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          // FocusManager().primaryFocus?.unfocus();
        },
        child: Column(
          children: [
            Expanded(
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Messages())),
            ChatBar()
          ],
        ),
      ),
    );
  }
}
