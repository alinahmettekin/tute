import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tute/core/components/custom_user_list_tile.dart';
import 'package:tute/core/models/user_profile.dart';
import 'package:tute/core/service/database/database_provider.dart';

class FollowListView extends StatefulWidget {
  final String uid;
  const FollowListView({super.key, required this.uid});

  @override
  State<FollowListView> createState() => _FollowListViewState();
}

class _FollowListViewState extends State<FollowListView> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    loadFollowersList();
    loadFollowingsList();
  }

  Future<void> loadFollowersList() async {
    await databaseProvider.loadUserFollowersProfiles(widget.uid);
  }

  Future<void> loadFollowingsList() async {
    await databaseProvider.loadUserFollowingsProfiles(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final followers = listeningProvider.getListOfFollowersProfiles(widget.uid);
    final followings = listeningProvider.getListOfFollowingsProfiles(widget.uid);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.primary,
          bottom: TabBar(
            dividerColor: Colors.transparent,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            tabs: const [
              Tab(
                text: 'Followers',
              ),
              Tab(
                text: 'Followings',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUserList(followers, 'This user have not any follower'),
            _buildUserList(followings, 'This user is not follow any user'),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(List<UserProfile> userList, String emptyMessage) {
    return userList.isEmpty
        ? Center(
            child: Text(emptyMessage),
          )
        : ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];

              return CustomUserListTile(user: user);
            },
          );
  }
}
