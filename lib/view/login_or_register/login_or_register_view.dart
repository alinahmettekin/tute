import 'package:flutter/material.dart';
import 'package:tute/view/login/login_view.dart';
import 'package:tute/view/register/register_view.dart';

class LoginOrRegisterView extends StatefulWidget {
  const LoginOrRegisterView({super.key});

  @override
  State<LoginOrRegisterView> createState() => _LoginOrRegisterViewState();
}

class _LoginOrRegisterViewState extends State<LoginOrRegisterView> {
  bool _showLoginView = true;

  void toggleViews() {
    setState(() {
      _showLoginView = !_showLoginView;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showLoginView) {
      return LoginView(
        onTap: toggleViews,
      );
    } else {
      return RegisterView(
        onTap: toggleViews,
      );
    }
  }
}
