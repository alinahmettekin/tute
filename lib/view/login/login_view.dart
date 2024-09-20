import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tute/core/components/custom_button.dart';
import 'package:tute/core/components/custom_loading_circle.dart';
import 'package:tute/core/components/custom_text_field.dart';
import 'package:tute/core/service/auth/firebase_auth_service.dart';

class LoginView extends StatefulWidget {
  final void Function() onTap;

  const LoginView({super.key, required this.onTap});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  void login(String email, password) async {
    showLoadingCircle(context);
    try {
      await FirebaseAuthService.instance.loginWithEmailAndPassword(email, password);
      if (mounted) hideLoadingCircle(context);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      if (mounted) hideLoadingCircle(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Icon(
                    Icons.lock_open,
                    size: 75,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  'Welcome back',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: emailController,
                  hintText: 'Type Email',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: pwController,
                  hintText: 'Type Password',
                  obscureText: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                  title: 'L O G I N',
                  onTap: () => login(emailController.text, pwController.text),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Register here',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
