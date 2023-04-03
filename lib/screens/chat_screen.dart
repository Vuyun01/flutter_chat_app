import 'package:chat_app/chat/chat_bar.dart';
import 'package:chat_app/chat/messages.dart';
import 'package:chat_app/constant.dart';
import 'package:chat_app/models/user.dart' as u;
import 'package:chat_app/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = '/chat';
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<SettingsProvider>(context).isDark;
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final userInfo = data['user'] as u.User;
    final groupId = data['groupId'] as String;
    return Scaffold(
      backgroundColor: isDark ? darkTheme : null,
      appBar: AppBar(
        backgroundColor: isDark ? Theme.of(context).colorScheme.tertiary : null,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 10,
          leading: CircleAvatar(
            backgroundImage:
                NetworkImage(userInfo.imageURL ?? placeholderImage),
          ),
          title: Text(
            '${userInfo.firstName} ${userInfo.lastName}',
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      // drawer: const CustomDrawer(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          // FocusManager().primaryFocus?.unfocus();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TextButton(
            //     onPressed: () {
            //       print(groupId);
            //     },
            //     child: Text('Click'))
            Expanded(
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Messages(
                      groupId: groupId,
                      sentTo: userInfo.userId,
                    ))),
            ChatBar(
              groupId: groupId,
              sentTo: userInfo.userId,
            )
          ],
        ),
      ),
    );
  }
}
