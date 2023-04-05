import 'dart:io';

import 'package:chat_app/constant.dart';
import 'package:chat_app/helper/firestore_helper.dart';
import 'package:chat_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbu;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../provider/profile_provider.dart';
import '../provider/settings_provider.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  late FirebaseStorage firebaseStorage;
  late ProfileProvider profileProvider;
  late AuthProvider authProvider;
  @override
  void initState() {
    firebaseStorage = FirebaseStorage.instance;
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: source, maxHeight: 150, imageQuality: 60);
      if (image == null) {
        return;
      }
      final timeStamp = Timestamp.now().seconds; //get timestamp as seconds
      final userId = authProvider.getCurrentUserID;
      final ref = firebaseStorage
          .ref()
          .child(FireStoreHelper.user_images)
          .child(userId)
          .child(
              '$userId-$timeStamp.jpg'); //create a reference to Firebase Storage
      //upload image to storage -> firestore
      profileProvider
          .uploadImageToStorage(ref, File(image.path))
          .then((_) async {
        final userData = await profileProvider.getUserInfo();
        final newImage = await ref.getDownloadURL();
        userData.imageURL = newImage;
        profileProvider.updateUserInfo(
            userData, FireStoreHelper.collectionUsersPath, userId);
      }).then((_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Upload image profile successfully!'),
                backgroundColor: Theme.of(context).colorScheme.primary,
              )));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: const Color.fromARGB(255, 237, 78, 66),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isDarkMode =
        Provider.of<SettingsProvider>(context, listen: false).isDark;
    return StreamBuilder(
        stream: profileProvider.getUserStreamData(
            FireStoreHelper.collectionUsersPath, authProvider.getCurrentUserID),
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
                        : const NetworkImage(placeholderImage) as ImageProvider,
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
                                  border: Border.all(
                                      color:
                                          isDarkMode ? darkTheme : Colors.white,
                                      width: 3),
                                  color: isDarkMode
                                      ? lightTheme
                                      : Theme.of(context).colorScheme.primary),
                              child: Icon(Icons.camera_alt_rounded,
                                  color: isDarkMode ? darkTheme : Colors.white),
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
