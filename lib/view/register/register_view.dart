import 'package:flutter/material.dart';
import 'package:tute/core/components/custom_button.dart';
import 'package:tute/core/components/custom_text_field.dart';

class RegisterView extends StatefulWidget {
  final void Function() onTap;

  const RegisterView({super.key, required this.onTap});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController pwController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController pwMatchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Icon(
                  Icons.lock,
                  size: 75,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                'Lets create an account for you',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                controller: nameController,
                hintText: 'Type Username',
              ),
              const SizedBox(
                height: 10,
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
              CustomTextField(
                controller: pwMatchController,
                hintText: 'Type Password',
                obscureText: true,
              ),
              const SizedBox(
                height: 30,
              ),
              CustomButton(
                title: 'R E G I S T E R',
                onTap: () {},
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already a member?',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      'Login here',
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
    );
  }
}
