import 'dart:io';

import 'package:chat_app/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbu;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../provider/color_screen_theme_provider.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture>
    with SingleTickerProviderStateMixin {
  fbu.User? _user;
  late fbu.FirebaseAuth _fireAuth;
  late FirebaseFirestore _firestore;
  late FirebaseStorage _firebaseStorage;
  bool isDark = false;

  @override
  void initState() {
    _fireAuth = fbu.FirebaseAuth.instance;
    _firebaseStorage = FirebaseStorage.instance;
    _firestore = FirebaseFirestore.instance;
    _user = _fireAuth.currentUser;
    isDark = Provider.of<ColorScreenTheme>(context, listen: false).isDark;
    super.initState();
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      var _image = await ImagePicker()
          .pickImage(source: source, maxHeight: 150, imageQuality: 60);
      if (_image == null) {
        return;
      }
      var timeStamp = Timestamp.now().seconds; //get timestamp as seconds
      var _ref = _firebaseStorage
          .ref()
          .child('user_images')
          .child(_user!.uid)
          .child(
              '${_user!.uid}-$timeStamp.jpg'); //create a reference to Firebase Storage
      _ref
          .putFile(File(_image.path))
          .then((_) => _uploadImage(_ref)); //upload the file
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: const Color.fromARGB(255, 237, 78, 66),
      ));
    }
  }

  Future<void> _uploadImage(Reference ref) async {
    final getImageURL = await ref.getDownloadURL();
    await _firestore //update user's image on Cloud Firestore
        .collection('users')
        .doc(_user?.uid)
        .set({'imageURL': getImageURL}, SetOptions(merge: true));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Upload image profile successfully!'),
      backgroundColor: Theme.of(context).colorScheme.primary,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: _firestore.collection('users').doc(_user!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: const EdgeInsets.all(40),
              decoration: const BoxDecoration(
                  color: Colors.black12, shape: BoxShape.circle),
              child: const CircularProgressIndicator.adaptive(),
            );
          }
          final imageSnapshot = snapshot.data?.get('imageURL');
          return SizedBox(
              width: size.width * 0.35,
              height: size.width * 0.35,
              child: Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.none, //allow to overlay on the parent
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: imageSnapshot != null
                        ? NetworkImage(imageSnapshot)
                        : const NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzfsTdRjF6giyFsO-d-Jw9beVB4cruN84U8n04eS3vZBHlgh2EFWe5KiTox-qt89I5-Io&usqp=CAU')
                            as ImageProvider,
                  ),
                  Positioned(
                      right: -10,
                      bottom: 0,
                      child: SizedBox(
                        width: size.width * 0.12,
                        height: size.width * 0.12,
                        child: PopupMenuButton(
                            splashRadius: 20,
                            padding: EdgeInsets.zero,
                            icon: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  color: isDark ? lightTheme : Theme.of(context)
                                      .colorScheme
                                      .primary),
                              child: Icon(Icons.camera_alt_rounded,
                                  color: isDark ? darkTheme : Colors.white),
                            ),
                            onSelected: (value) {
                              if (value == ImageSource.camera) {
                                _getImage(ImageSource.camera);
                              } else {
                                _getImage(ImageSource.gallery);
                              }
                            },
                            itemBuilder: ((context) => [
                                  const PopupMenuItem(
                                    value: ImageSource.camera,
                                    child: Text('Take a photo'),
                                  ),
                                  const PopupMenuItem(
                                    value: ImageSource.gallery,
                                    child: Text('Select from gallery'),
                                  ),
                                ])),
                      )),
                ],
              ));
        });
  }
}
