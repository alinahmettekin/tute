import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tute/core/components/custom_user_list_tile.dart';
import 'package:tute/core/service/database/database_provider.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _searchController = TextEditingController();

  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
  late final listeningProvider = Provider.of<DatabaseProvider>(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search users',
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              databaseProvider.searchUser(value);
            }
          },
        ),
      ),
      body: listeningProvider.searchResults.isEmpty
          ? const Center(
              child: Text('No users found'),
            )
          : ListView.builder(
              itemCount: listeningProvider.searchResults.length,
              itemBuilder: (context, index) {
                final user = listeningProvider.searchResults[index];
                return CustomUserListTile(user: user);
              },
            ),
    );
  }
}
