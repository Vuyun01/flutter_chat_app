import 'package:flutter/material.dart';

import '../widgets/chat_contacts.dart';
import '../widgets/scrollable_chat_contacts.dart';

class HomeChatScreen extends StatelessWidget {
  static const String routeName = '/homechat';
  const HomeChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: const [
        ScrollableChatContacts(),
        ChatContacts()
      ],
    ));
  }
}
