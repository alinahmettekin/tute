import 'package:flutter/material.dart';
import 'package:tute/core/components/custom_drawer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('H O M E'),
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: const SafeArea(
          child: Column(
        children: [],
      )),
    );
  }
}
