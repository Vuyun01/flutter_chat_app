import 'package:chat_app/constant.dart';
import 'package:chat_app/models/user.dart' as u;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/color_screen_theme_provider.dart';
import '../widgets/custom_theme.dart';

class PersonalInfomationScreen extends StatefulWidget {
  static const String routeName = '/personal_info';
  const PersonalInfomationScreen({super.key});

  @override
  State<PersonalInfomationScreen> createState() =>
      _PersonalInfomationScreenState();
}

class _PersonalInfomationScreenState extends State<PersonalInfomationScreen> {
  User? user;
  late FirebaseFirestore _firestore;
  final _formKey = GlobalKey<FormState>();
  late Future<DocumentSnapshot<Map<String, dynamic>>> _userData;
  late ColorScreenTheme Darkmode;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    _firestore = FirebaseFirestore.instance;
    _userData = _getUserData();
    Darkmode = Provider.of<ColorScreenTheme>(context, listen: false);
    super.initState();
  }

  u.User _newuser =
      u.User(firstName: '', lastName: '', email: '', password: '');

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserData() async {
    return await _firestore.collection('users').doc(user?.uid).get();
  }

  Future<void> _updateUserData() async {
    final isValidated = _formKey.currentState?.validate();
    _formKey.currentState?.save();
    if (!isValidated!) return;
    try {
      await _firestore.collection('users').doc(user?.uid).update(
          {'firstName': _newuser.firstName, 'lastName': _newuser.lastName});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Update profile successfully!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isDarkMode = Darkmode.isDark;
    return Scaffold(
        backgroundColor: isDarkMode ? darkTheme : null,
        appBar: AppBar(
          backgroundColor:
              isDarkMode ? Theme.of(context).colorScheme.tertiary : null,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back)),
          title: const Text('Personal Information'),
        ),
        body: FutureBuilder(
            future: _userData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 40),
                        width: size.height * 0.2,
                        height: size.height * 0.2,
                        child: CircleAvatar(
                          backgroundColor: Colors.black26,
                          backgroundImage: snapshot.data != null
                              ? NetworkImage(snapshot.data!['imageURL'])
                              : null,
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildEditUserInfoField(
                                initValue: snapshot.data!['firstName'] ?? 'N/A',
                                hintext: 'Enter your first name...',
                                label: 'First Name',
                                onSaved: (value) {
                                  _newuser.firstName = value!;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'First name is required';
                                  }
                                  return null;
                                }),
                            const SizedBox(
                              height: 20,
                            ),
                            _buildEditUserInfoField(
                                initValue: snapshot.data!['lastName'] ?? 'N/A',
                                hintext: 'Enter your last name...',
                                label: 'Last Name',
                                onSaved: (value) {
                                  _newuser.lastName = value!;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'First name is required';
                                  }
                                  return null;
                                }),
                            const SizedBox(
                              height: 20,
                            ),
                            _buildEditUserInfoField(
                                initValue: snapshot.data!['email'] ?? 'N/A',
                                enabled: false,
                                hintext: '',
                                label: 'Email',
                                onSaved: null,
                                validator: (value) {
                                  return null;
                                }),
                            const SizedBox(
                              height: 30,
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: const Size(double.maxFinite, 0),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                              ),
                              onPressed: _updateUserData,
                              child: Text('Update Profile',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              );
            }));
  }

  Widget _buildEditUserInfoField(
      {required String label,
      required String hintext,
      required void Function(String? value)? onSaved,
      required String? Function(String? value) validator,
      bool enabled = true,
      bool obscureText = false,
      String? initValue}) {
    return Row(
      children: [
        SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  color: Darkmode.isDark ? lightTheme : null,
                  fontWeight: FontWeight.bold),
            )),
        Expanded(
          child: TextFormField(
            initialValue: initValue,
            validator: validator,
            obscureText: obscureText,
            enabled: enabled,
            onSaved: onSaved,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Darkmode.isDark ? lightTheme : null),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                hintText: hintext,
                hintStyle:
                    TextStyle(color: Darkmode.isDark ? lightTheme : null),
                enabledBorder: CustomOutlineInputBorder(
                    width: 1, color: Darkmode.isDark ? lightTheme : darkTheme),
                focusedBorder: CustomOutlineInputBorder()),
          ),
        ),
      ],
    );
  }
}
