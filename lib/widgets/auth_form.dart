import 'package:chat_app/constant.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';

import 'custom_theme.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    Key? key,
    required this.onSubmitData,
    this.isLoading = false,
  }) : super(key: key);
  final Function onSubmitData;
  final bool isLoading;
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _isSignup = false;
  final _formkey = GlobalKey<FormState>();

  // var _firstname = '';
  // var _lastname = '';
  // var _email = '';
  // var _password = '';
  User _user = User(email: '', firstName: '', lastName: '', password: '');

  void _setSignupField() {
    setState(() {
      _isSignup = !_isSignup;
    });
  }

  void _submit() {
    final isValid = _formkey.currentState?.validate();
    FocusScope.of(context).unfocus(); //close the keyboard
    if (isValid!) {
      _formkey.currentState?.save();
      if (_isSignup) {
        widget.onSubmitData(_user, false);
      } else {
        widget.onSubmitData(_user, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // const Spacer(),
            const SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text(
                _isSignup ? 'SIGN UP' : 'LOGIN',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.copyWith(color: Colors.teal),
              ),
            ),
            if (_isSignup)
              Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) return 'First name is required';
                      return null;
                    },
                    onSaved: (newValue) {
                      _user.firstName = newValue!.trim();
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "First Name",
                        prefixIcon: const Icon(Icons.person),
                        focusedBorder: CustomOutlineInputBorder(width: 2)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) return 'Last name is required';
                      return null;
                    },
                    onSaved: (newValue) {
                      _user.lastName = newValue!.trim();
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Last Name",
                        prefixIcon: const Icon(Icons.person),
                        focusedBorder: CustomOutlineInputBorder(width: 2)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Email is required';
                }
                if (!emailRegExp.hasMatch(value)) {
                  return 'Email is not valid';
                }
                return null;
              },
              onSaved: (newValue) {
                _user.email = newValue!.trim();
              },
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  // floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.mail_outline),
                  focusedBorder: CustomOutlineInputBorder(width: 2)),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password is required';
                }
                if (!passwordRegExp.hasMatch(value)) {
                  return 'Password is invalid';
                }
                return null;
              },
              onSaved: (newValue) {
                _user.password = newValue!.trim();
              },
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  focusedBorder: CustomOutlineInputBorder(width: 2)),
            ),
            const SizedBox(
              height: 30,
            ),
            TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  minimumSize: const Size(double.maxFinite, 0),
                ),
                onPressed: _submit,
                child: widget.isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : Text(
                        _isSignup ? 'REGISTER' : 'SIGN IN',
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(color: Colors.white),
                      )),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isSignup
                    ? const Text('Already have an account?')
                    : const Text('Don\'t have any account?'),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: _setSignupField,
                  child: Text(
                    _isSignup ? 'Sign In' : 'Sign Up',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            )
            // const Spacer(
            //   flex: 3,
            // )
          ],
        ),
      ),
    );
  }
}
