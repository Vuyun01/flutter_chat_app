import 'package:chat_app/chat/message_bubble.dart';
import 'package:chat_app/constant.dart';
import 'package:chat_app/helper/firestore_helper.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/provider/chat_provider.dart';
import 'package:chat_app/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  const Messages({super.key, required this.groupId, required this.sentTo});
  final String groupId;
  final String sentTo;
  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  late AuthProvider authProvider;
  late ChatProvider chatProvider;
  @override
  void initState() {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    super.initState();
  }

  Future<void> _syncUserImagetoMessages() async {
    try {
      final userId = authProvider.getCurrentUserID;
      final userInfo = await authProvider.getUserInfo(userId);
      await chatProvider
          .getChatDataBasedOnUserId(FireStoreHelper.collectionChatsPath,
              FireStoreHelper.subCollectionChatsPath, widget.groupId, userId)
          .then((value) {
        value.docs.forEach((item) async {
          try {
            if (userInfo?.imageURL != null) {
              await item.reference
                  .update({FireStoreHelper.imageURL: userInfo!.imageURL});
            }
            print('Update user messages');
          } catch (e) {
            print(e.toString());
            return;
          }
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<SettingsProvider>(context, listen: false).isDark;
    return FutureBuilder(
      future: _syncUserImagetoMessages(),
      builder: (context, snapshot) => StreamBuilder(
        stream: chatProvider.getChatStreamData(
            FireStoreHelper.collectionChatsPath,
            FireStoreHelper.subCollectionChatsPath,
            widget.groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          final docs = snapshot.data!.docs;
          return docs.isNotEmpty
              ? ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: ((context, index) {
                    return MessageBubble(
                      key: ValueKey(docs[index][FireStoreHelper
                          .idFrom]), //add key to make sure that the message is unique
                      message: Message.fromDocToMessage(docs[index]),
                      isCurrentUser: authProvider.getCurrentUserID ==
                          docs[index][FireStoreHelper.idFrom],
                    );
                  }))
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Send a message to start a conversation',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: isDarkMode ? lightTheme : null),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
