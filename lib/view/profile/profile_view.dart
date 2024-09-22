import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tute/core/components/custom_bio_box.dart';
import 'package:tute/core/components/custom_input_box.dart';
import 'package:tute/core/components/custom_post_tile.dart';
import 'package:tute/core/models/post.dart';
import 'package:tute/core/models/user_profile.dart';
import 'package:tute/core/service/auth/firebase_auth_service.dart';
import 'package:tute/core/service/database/database_provider.dart';

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

  TextEditingController bioTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    user = await databaseProvider.userProfile(widget.uid);
    setState(() {
      isLoading = false;
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(isLoading ? ' ' : user!.name),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: ListView(
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
                  size: 75,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bio',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
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
    );
  }
}
