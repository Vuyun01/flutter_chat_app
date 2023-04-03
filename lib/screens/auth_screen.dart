import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as u;
import '../provider/auth_provider.dart';
import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late AuthProvider authProvider;
  @override
  void initState() {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
  }

  bool _isLoading = false;
  Future<void> submitData(u.User user, [bool isLoggedIn = false]) async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (isLoggedIn) {
        await authProvider.signIn(user.email, user.password);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     content: Text('Sign in account successfully!'),
        //     backgroundColor: Theme.of(context).colorScheme.primary));
        // final prefs = await SharedPreferences.getInstance();
        // print(prefs.getString(FireStoreHelper.userInfo));
      } else {
        await authProvider.signUp(user);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     content: Text('Register account successfully!'),
        //     backgroundColor: Theme.of(context).colorScheme.primary));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
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
