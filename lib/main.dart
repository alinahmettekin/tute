import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tute/core/theme/theme_provider.dart';
import 'package:tute/view/login_or_register/login_or_register_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: LoginOrRegisterView(),
    );
  }
}
