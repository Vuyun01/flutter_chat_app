import 'package:chat_app/helper/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user.dart' as u;
import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;

  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    super.initState();
  }

  bool _isLoading = false;
  Future<void> submitData(u.User user, [bool isLoggedIn = false]) async {
    UserCredential _userCredential;
    setState(() {
      _isLoading = true;
    });
    try {
      if (isLoggedIn) {
        _userCredential = await _auth.signInWithEmailAndPassword(
            email: user.email, password: user.password);
        final userId = _userCredential.user?.uid;
        await Utils.storeUserDataToDevice(key: 'user', userId: userId!);
      } else {
        _userCredential = await _auth.createUserWithEmailAndPassword(
            email: user.email, password: user.password);
        final userId = _userCredential.user?.uid;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Register account successfully!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ));
        _isLoading = false;
        await _firestore
            .collection('users')
            .doc(userId)
            .set(user.toMap())
            .then((_) => Utils.storeUserDataToDevice(key: 'user', userId: userId!));
      }
      // } on PlatformException catch (e) {
      //   var message = 'An error occurred. Please recheck your credentials!';
      //   if (e.message!.isNotEmpty) {
      //     message = e.message!;
      //   }
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AuthForm(
          onSubmitData: submitData,
          isLoading: _isLoading,
        ),
      ),
    );
  }
}
