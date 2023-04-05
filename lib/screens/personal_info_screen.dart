import 'package:chat_app/constant.dart';
import 'package:chat_app/helper/firestore_helper.dart';
import 'package:chat_app/models/user.dart' as u;
import 'package:chat_app/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/settings_provider.dart';
import '../widgets/custom_theme.dart';

class PersonalInfomationScreen extends StatefulWidget {
  static const String routeName = '/personal_info';
  const PersonalInfomationScreen({super.key});

  @override
  State<PersonalInfomationScreen> createState() =>
      _PersonalInfomationScreenState();
}

class _PersonalInfomationScreenState extends State<PersonalInfomationScreen> {
  late ProfileProvider profileProvider;
  late Future<u.User> _userInfo;
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';

  @override
  void initState() {
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    _userInfo = profileProvider.getUserInfo();
    super.initState();
  }

  Future<void> _updateUserData(u.User user) async {
    final isValidated = _formKey.currentState?.validate();
    if (!isValidated!) return;
    _formKey.currentState?.save();
    try {
      user.firstName = _firstName;
      user.lastName = _lastName;
      profileProvider
          .updateUserInfo(
              user, FireStoreHelper.collectionUsersPath, user.userId)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Update profile successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary));
        FocusScope.of(context).unfocus();
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
    final size = MediaQuery.of(context).size;
    bool isDarkMode = Provider.of<SettingsProvider>(context).isDark;
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
        future: _userInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          final imageUrl = snapshot.data!.imageURL ?? placeholderImage;
          final user = snapshot.data;
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
                        backgroundImage: NetworkImage(imageUrl)),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildEditUserInfoField(
                            initValue: snapshot.data!.firstName,
                            hintext: 'Enter your first name...',
                            label: 'First Name',
                            isDarkMode: isDarkMode,
                            onSaved: (value) {
                              _firstName = value!;
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
                            initValue: snapshot.data!.lastName,
                            hintext: 'Enter your last name...',
                            label: 'Last Name',
                            isDarkMode: isDarkMode,
                            onSaved: (value) {
                              _lastName = value!;
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
                            initValue: snapshot.data!.email,
                            enabled: false,
                            hintext: '',
                            label: 'Email',
                            onSaved: null,
                            isDarkMode: isDarkMode,
                            validator: (value) {
                              return null;
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size(double.maxFinite, 0),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                          onPressed: () => _updateUserData(user!),
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
        },
      ),
    );
  }

  Widget _buildEditUserInfoField(
      {required String label,
      required String hintext,
      required void Function(String? value)? onSaved,
      required String? Function(String? value) validator,
      bool enabled = true,
      bool obscureText = false,
      bool isDarkMode = false,
      String? initValue}) {
    return Row(
      children: [
        SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  color: isDarkMode ? lightTheme : null,
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
            style: TextStyle(color: isDarkMode ? lightTheme : null),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                hintText: hintext,
                hintStyle: TextStyle(color: isDarkMode ? lightTheme : null),
                enabledBorder: CustomOutlineInputBorder(
                    width: 1, color: isDarkMode ? lightTheme : darkTheme),
                focusedBorder: CustomOutlineInputBorder()),
          ),
        ),
      ],
    );
  }
}
