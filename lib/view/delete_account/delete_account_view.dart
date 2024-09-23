import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tute/core/components/custom_button.dart';
import 'package:tute/core/service/auth/firebase_auth_service.dart';
import 'package:tute/core/service/database/database_provider.dart';
import 'package:tute/view/auth_gate/auth_gate_view.dart';

class DeleteAccountView extends StatefulWidget {
  const DeleteAccountView({super.key});

  @override
  State<DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);

  void _deleteAccountConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure to delete your account'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              try {
                deleteAccount();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AuthGateView(),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("We can't delete your account please try again later")),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> deleteAccount() async {
    await FirebaseAuthService.instance.deleteAccountInFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delete Account',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Text(
                "This  process is not reversible.Your account, posts and comments will be delete permanently.",
                textAlign: TextAlign.center,
              ),
            ),
            CustomButton(
              title: 'Delete Account',
              onTap: () {
                _deleteAccountConfirmationDialog();
              },
            )
          ],
        ),
      ),
    );
  }
}
