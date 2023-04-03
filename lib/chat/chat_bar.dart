import 'dart:io';

import 'package:chat_app/constant.dart';
import 'package:chat_app/helper/firestore_helper.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/provider/chat_provider.dart';
import 'package:chat_app/provider/profile_provider.dart';
import 'package:chat_app/provider/settings_provider.dart';
import 'package:chat_app/widgets/custom_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class ChatBar extends StatefulWidget {
  const ChatBar({super.key, required this.groupId, required this.sentTo});

  final String groupId;
  final String sentTo;
  @override
  State<ChatBar> createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar> {
  late final _controller;
  late ChatProvider chatProvider;
  late AuthProvider authProvider;
  late ProfileProvider profileProvider;
  late final FirebaseStorage storage;
  @override
  void initState() {
    _controller = TextEditingController();
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    storage = FirebaseStorage.instance;
    super.initState();
  }

  var message = '';
  Future<void> _sendMessage() async {
    try {
      FocusScope.of(context).unfocus();
      _controller.clear();
      final userId = authProvider.getCurrentUserID;
      final userInfo = await authProvider.getUserInfo(userId);
      final newMessage = Message(
          idFrom: userId,
          idTo: widget.sentTo,
          createdAt: DateTime.now(),
          content: message,
          imageURL: userInfo?.imageURL ?? placeholderImage);
      await chatProvider.sendMessage(FireStoreHelper.collectionChatsPath,
          FireStoreHelper.subCollectionChatsPath, widget.groupId, newMessage);
      setState(() {
        message = '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _sendMessageAsImage(ImageSource source) async {
    final takenImage =
        await ImagePicker().pickImage(source: source, maxHeight: 500);
    if (takenImage == null) return;
    try {
      final timestamp = Timestamp.now().seconds;
      final newImage = File(takenImage.path);
      final userId = authProvider.getCurrentUserID;
      final ref = storage
          .ref()
          .child(FireStoreHelper.user_image_messages)
          .child(userId)
          .child('$userId-$timestamp.jpg');

      await profileProvider.uploadImageToStorage(ref, newImage).then((_) async {
        final getImage = await ref.getDownloadURL();
        final userInfo = await authProvider.getUserInfo(userId);
        final newMessage = Message(
            idFrom: userId,
            idTo: widget.sentTo,
            createdAt: DateTime.now(),
            content: getImage,
            type: 'image',
            imageURL: userInfo?.imageURL ?? placeholderImage);
        await chatProvider.sendMessage(FireStoreHelper.collectionChatsPath,
            FireStoreHelper.subCollectionChatsPath, widget.groupId, newMessage);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<SettingsProvider>(context, listen: false).isDark;
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
      child: Row(
        children: [
          IconButton(
              onPressed: () => _sendMessageAsImage(ImageSource.camera),
              icon: Icon(
                Icons.camera_alt,
                color: Theme.of(context).colorScheme.primary,
              )),
          IconButton(
              onPressed: () => _sendMessageAsImage(ImageSource.gallery),
              icon: Icon(
                Icons.image,
                color: Theme.of(context).colorScheme.primary,
              )),
          Expanded(
            child: TextField(
              style: TextStyle(color: isDarkMode ? lightTheme : null),
              onChanged: (value) {
                setState(() {
                  message = value.trim();
                });
              },
              controller: _controller,
              decoration: InputDecoration(
                  hintText: 'Send a message...',
                  hintStyle:
                      TextStyle(color: isDarkMode ? lightTheme : darkTheme),
                  enabledBorder: CustomOutlineInputBorder(
                      color: isDarkMode ? lightTheme : darkTheme),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              minLines: 1,
            ),
          ),
          IconButton(
              onPressed: message.isEmpty ? null : _sendMessage,
              icon: Icon(
                Icons.send,
                color: Theme.of(context).colorScheme.primary,
              ))
        ],
      ),
    );
  }
}
