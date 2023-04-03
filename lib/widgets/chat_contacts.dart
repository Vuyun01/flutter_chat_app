import 'package:chat_app/constant.dart';
import 'package:chat_app/helper/firestore_helper.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/provider/chat_provider.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as u;
import '../provider/settings_provider.dart';

class ChatContacts extends StatefulWidget {
  const ChatContacts({
    Key? key,
    required this.users,
  }) : super(key: key);
  final List<u.User> users;

  @override
  State<ChatContacts> createState() => _ChatContactsState();
}

class _ChatContactsState extends State<ChatContacts> {
  late AuthProvider authProvider;
  late ChatProvider chatProvider;
  @override
  void initState() {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    super.initState();
  }

  String getGroupID(String userId, String id) {
    String groupID = '';
    if (userId.compareTo(id) > 0) {
      groupID = '$userId-$id';
    } else {
      groupID = '$id-$userId';
    }
    return groupID;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<SettingsProvider>(context, listen: false).isDark;

    return Expanded(
        child: ListView.builder(
            itemCount: widget.users.length,
            itemBuilder: ((context, index) {
              final groupId = getGroupID(
                  authProvider.getCurrentUserID, widget.users[index].userId);
              return StreamBuilder(
                  stream: chatProvider.getChatStreamData(
                      FireStoreHelper.collectionChatsPath,
                      FireStoreHelper.subCollectionChatsPath,
                      groupId,
                      1),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        ),
                      );
                    }
                    String message = 'Send a message to the user';
                    bool isHasData = snapshot.data!.docs.isNotEmpty;
                    if (isHasData) {
                      final data = //get the newest message
                          Message.fromDocToMessage(snapshot.data!.docs.first);
                      if (data.type == 'image') {
                        message = chatProvider.isUser(
                                authProvider.getCurrentUserID, data.idFrom)
                            ? 'You sent a photo'
                            : '${widget.users[index].lastName} sent a photo';
                      } else {
                        message = chatProvider.isUser(
                                authProvider.getCurrentUserID, data.idFrom)
                            ? 'You: ${data.content}'
                            : '${widget.users[index].lastName}: ${data.content}';
                      }
                    }
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(ChatScreen.routeName,
                            arguments: {
                              'user': widget.users[index],
                              'groupId': groupId
                            });
                      },
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            widget.users[index].imageURL ?? placeholderImage),
                      ),
                      subtitle: Text(message,
                          style:
                              TextStyle(color: isDarkMode ? lightTheme : null)),
                      title: Text(
                        '${widget.users[index].firstName} ${widget.users[index].lastName}',
                        style: TextStyle(color: isDarkMode ? lightTheme : null),
                      ),
                    );
                  });
            })));
  }
}
