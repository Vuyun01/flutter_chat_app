
import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'custom_drawer_item.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      width: size.width*0.6,
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            height: 150,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
            child: Text(
              'Hi There!',
              style: Theme.of(context).textTheme.headline3?.copyWith(
                  color: const Color.fromARGB(255, 124, 241, 23),
                  fontFamily: 'Raleway',
                  fontSize: 30),
            ),
          ),
          CustomDrawerItem(
            textSize: 20,
            icon: Icons.home,
            // onTap: () => Navigator.of(context).pushReplacementNamed(ChatScreen.routeName),
            onTap: (){
              FocusScope.of(context).unfocus();
              Navigator.of(context).pop();
            } ,
            text: 'Home',
          ),
          CustomDrawerItem(
            textSize: 20,
            icon: Icons.logout,
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },
            text: 'Log Out',
          ),
        ],
      ),
    );
  }
}
