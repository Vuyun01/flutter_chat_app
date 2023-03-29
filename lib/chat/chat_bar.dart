import 'dart:io';
import 'dart:ui';

import 'package:chat_app/constant.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/provider/color_screen_theme_provider.dart';
import 'package:chat_app/widgets/custom_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatBar extends StatefulWidget {
  const ChatBar({super.key});

  @override
  State<ChatBar> createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar> {
  late final _controller;
  late final FirebaseAuth _firebaseAuth;
  late final FirebaseFirestore _firestore;
  late final FirebaseStorage _storage;
  late ColorScreenTheme _darkMode;
  @override
  void initState() {
    _controller = TextEditingController();
    _firebaseAuth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _storage = FirebaseStorage.instance;
    _darkMode = Provider.of<ColorScreenTheme>(context, listen: false);
    super.initState();
  }

  var message = '';
  Future<void> _sendMessage() async {
    try {
      FocusScope.of(context).unfocus();
      _controller.clear();
      final user = _firebaseAuth.currentUser;
      final userInfo =
          await _firestore.collection('users').doc(user?.uid).get();
      final storedMessage = Message(
          userId: user!.uid,
          createdAt: DateTime.now(),
          text: message,
          userImageURL: userInfo['imageURL'] ?? placeholderImage);
      await _firestore.collection('chat').add(storedMessage.toMap());
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
      final user = _firebaseAuth.currentUser;
      final ref = _storage
          .ref()
          .child('user_image_messages')
          .child(user!.uid)
          .child('${user.uid}-$timestamp.jpg');

      await ref.putFile(newImage).then((_) async {
        final getImageURL = await ref.getDownloadURL();
        final userInfo =
            await _firestore.collection('users').doc(user.uid).get();
        final newMessage = Message(
            userId: user.uid,
            createdAt: DateTime.now(),
            text: getImageURL,
            userImageURL: userInfo['imageURL'] ?? placeholderImage,
            type: 'image');

        await _firestore.collection('chat').add(newMessage.toMap());
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = _darkMode.isDark;
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
