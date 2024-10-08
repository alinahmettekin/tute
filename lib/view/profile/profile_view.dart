import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tute/core/components/custom_bio_box.dart';
import 'package:tute/core/components/custom_follow_button.dart';
import 'package:tute/core/components/custom_input_box.dart';
import 'package:tute/core/components/custom_post_tile.dart';
import 'package:tute/core/components/custom_profile_stats.dart';
import 'package:tute/core/helper/navigate_helper.dart';
import 'package:tute/core/models/post.dart';
import 'package:tute/core/models/user_profile.dart';
import 'package:tute/core/service/auth/firebase_auth_service.dart';
import 'package:tute/core/service/database/database_provider.dart';
import 'package:tute/view/follow/follow_list_view.dart';

class ProfileView extends StatefulWidget {
  final String uid;
  const ProfileView({super.key, required this.uid});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
  late final listeningProvider = Provider.of<DatabaseProvider>(context);

  UserProfile? user;
  String currentUserUid = FirebaseAuthService.instance.getCurrentUserUid();

  List<Post>? userPosts;

  bool isLoading = true;

  bool _isFollowing = false;

  TextEditingController bioTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    loadUser();
  }

  Future<void> loadUser() async {
    user = await databaseProvider.userProfile(widget.uid);

    await databaseProvider.loadUserFollowers(widget.uid);
    await databaseProvider.loadUserFollowings(widget.uid);

    _isFollowing = databaseProvider.isFollowing(widget.uid);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _toggleFollow() async {
    if (_isFollowing) {
      await databaseProvider.unFollowUser(widget.uid);
    } else {
      await databaseProvider.followUser(widget.uid);
    }

    setState(() {
      _isFollowing = !_isFollowing;
    });
  }

  void _showEditBioBox() {
    showDialog(
      context: context,
      builder: (context) => CustomInputBox(
        onPressed: saveBio,
        controller: bioTextController,
        hintText: 'Edit Bio',
        onPressedText: 'Save',
      ),
    );
  }

  Future<void> saveBio() async {
    setState(() {
      isLoading = true;
    });

    await databaseProvider.updateUserBio(bioTextController.text);

    await loadUser();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allUserPosts = listeningProvider.filterUserPosts(widget.uid);

    _isFollowing = listeningProvider.isFollowing(widget.uid);

    final followersCount = databaseProvider.getfollowersCount(widget.uid);
    final followingsCount = databaseProvider.getfollowingCount(widget.uid);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(isLoading ? ' ' : user!.name),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => goHomePage(context),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Center(
                child: Text(
                  isLoading ? '' : '@${user!.username}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 100,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              CustomProfileStats(
                postCounts: allUserPosts.length,
                followersCount: followersCount,
                followingsCount: followingsCount,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FollowListView(
                    uid: widget.uid,
                  ),
                )),
              ),
              const SizedBox(height: 25),
              if (user != null && user!.uid != currentUserUid)
                CustomFollowButton(
                  onPressed: () async {
                    _toggleFollow();
                  },
                  isFollowing: _isFollowing,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bio',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                    if (user != null && user!.uid == currentUserUid)
                      GestureDetector(
                        onTap: _showEditBioBox,
                        child: Icon(
                          Icons.settings,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomBioBox(text: isLoading ? '...' : user!.bio),
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 20),
                child: Text(
                  'Posts',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              allUserPosts.isEmpty
                  ? const Center(
                      child: Text('No posts yet'),
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: allUserPosts.length,
                      itemBuilder: (context, index) {
                        final userPosts = allUserPosts[index];
                        return CustomPostTile(
                          post: userPosts,
                          onUserTap: () {},
                          onPostTap: () {},
                        );
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }
}
