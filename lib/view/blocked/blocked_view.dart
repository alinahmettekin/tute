import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tute/core/service/database/database_provider.dart';

class BlockedView extends StatefulWidget {
  const BlockedView({super.key});

  @override
  State<BlockedView> createState() => _BlockedViewState();
}

class _BlockedViewState extends State<BlockedView> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    loadBlockedUsers();
  }

  Future<void> loadBlockedUsers() async {
    await databaseProvider.loadBlockedUsers();
  }

  Future<void> unblockUser(String userId) async {
    await databaseProvider.unblockUser(userId);
  }

  void _unBlockUserConfirmationBox(String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Unblock'),
        content: const Text('Are you sure to unblock this user'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              String statusMessage = 'User unblocked';
              try {
                unblockUser(userId);
              } catch (e) {
                print(e);
                statusMessage = "Error occured for unblocking user";
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(statusMessage),
                ),
              );
            },
            child: const Text('Unblock'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final blockedUsers = listeningProvider.blockedUsers;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Blocked Users',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          centerTitle: true,
        ),
        body: blockedUsers.isEmpty
            ? const Center(
                child: Text('There is no blocked user'),
              )
            : ListView.builder(
                itemCount: blockedUsers.length,
                itemBuilder: (context, index) {
                  final user = blockedUsers[index];

                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text('@${user.username}'),
                    trailing: IconButton(
                      onPressed: () => _unBlockUserConfirmationBox(user.uid),
                      icon: const Icon(Icons.block),
                    ),
                  );
                },
              ));
  }
}
