import 'package:chat_app/constant.dart';
import 'package:chat_app/helper/firestore_helper.dart';
import 'package:chat_app/provider/settings_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as u;
import '../widgets/chat_contacts.dart';
import '../widgets/scrollable_chat_contacts.dart';

class HomeChatScreen extends StatefulWidget {
  static const String routeName = '/homechat';
  const HomeChatScreen({super.key});

  @override
  State<HomeChatScreen> createState() => _HomeChatScreenState();
}

class _HomeChatScreenState extends State<HomeChatScreen> {
  late FirebaseFirestore _fireStore;
  late FirebaseAuth _firebaseAuth;

  @override
  void initState() {
    _fireStore = FirebaseFirestore.instance;
    _firebaseAuth = FirebaseAuth.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<SettingsProvider>(context).isDark;
    return Scaffold(
        backgroundColor: isDarkMode ? darkTheme : null,
        body: StreamBuilder(
            stream: _fireStore
                .collection(FireStoreHelper.collectionUsersPath)
                .where(FireStoreHelper.userId,
                    isNotEqualTo: _firebaseAuth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              final usersData = snapshot.data?.docs
                      .map((e) => u.User.fromDocToUser(e))
                      .toList() ??
                  [];
              return Column(
                children: [
                  ScrollableChatContacts(
                    users: usersData,
                  ),
                  ChatContacts(
                    users: usersData,
                  )
                ],
              );
            }));
  }
}
