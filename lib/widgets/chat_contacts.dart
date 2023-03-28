
import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatContacts extends StatelessWidget {
  const ChatContacts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: 5,
            itemBuilder: ((context, index) => ListTile(
              onTap: (){
                Navigator.of(context).pushNamed(ChatScreen.routeName);
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              leading: const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzfsTdRjF6giyFsO-d-Jw9beVB4cruN84U8n04eS3vZBHlgh2EFWe5KiTox-qt89I5-Io&usqp=CAU'),
              ),
              title: const Text('User name'),
            ))));
  }
}