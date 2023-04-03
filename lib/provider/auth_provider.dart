// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/helper/firestore_helper.dart';
import 'package:chat_app/models/user.dart' as u;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  AuthProvider({
    required this.firebaseAuth,
    required this.firestore,
  });

  String get getCurrentUserID {
    return firebaseAuth.currentUser!.uid;
  }

  Future<u.User?> getUserInfo(String id) async {
    try {
      final userInfo = await firestore
          .collection(FireStoreHelper.collectionUsersPath)
          .doc(id)
          .get();
      if (userInfo.exists) {
        final extractedUserInfo = {
          FireStoreHelper.userId: userInfo[FireStoreHelper.userId],
          FireStoreHelper.firstName: userInfo[FireStoreHelper.firstName],
          FireStoreHelper.lastName: userInfo[FireStoreHelper.lastName],
          FireStoreHelper.email: userInfo[FireStoreHelper.email],
          FireStoreHelper.password: userInfo[FireStoreHelper.password],
          FireStoreHelper.imageURL: userInfo[FireStoreHelper.imageURL],
        };
        return u.User.fromMap(extractedUserInfo);
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> signIn(String email, String password) async {
    await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      final prefs = await SharedPreferences.getInstance();
      final userInfo = await getUserInfo(value.user!.uid);
      //store data to the app
      await prefs.setString(FireStoreHelper.userInfo, userInfo!.toJson());
    });
  }

  Future<void> signUp(u.User user) async {
    await firebaseAuth
        .createUserWithEmailAndPassword(
            email: user.email, password: user.password)
        .then((value) async {
      final prefs = await SharedPreferences.getInstance();
      final newUser = u.User(
          userId: value.user!.uid,
          firstName: user.firstName,
          lastName: user.lastName,
          password: user.password,
          email: user.email);

      //add to firestore
      await firestore
          .collection(FireStoreHelper.collectionUsersPath)
          .doc(value.user!.uid)
          .set(newUser.toMap());
      //store data to the app
      await prefs.setString(FireStoreHelper.userInfo, newUser.toJson());
    });
  }

  Future<void> signOut()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await firebaseAuth.signOut();
  }
}
