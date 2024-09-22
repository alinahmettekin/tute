import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tute/core/components/custom_drawer.dart';
import 'package:tute/core/components/custom_input_box.dart';
import 'package:tute/core/components/custom_post_tile.dart';
import 'package:tute/core/helper/navigate_helper.dart';
import 'package:tute/core/models/post.dart';
import 'package:tute/core/service/database/database_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController messageTextController = TextEditingController();

  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
  late final listeningProvider = Provider.of<DatabaseProvider>(context);

  void _postMessageBox() {
    showDialog(
      context: context,
      builder: (context) => CustomInputBox(
        controller: messageTextController,
        hintText: 'Type message...',
        onPressed: () async {
          await postMessage(messageTextController.text);
        },
        onPressedText: 'Post Message',
      ),
    );
  }

  Future<void> postMessage(String message) async {
    try {
      await databaseProvider.sendMessage(message);
      await databaseProvider.loadAllPosts();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    loadAllPosts();
  }

  Future<void> loadAllPosts() async {
    await databaseProvider.loadAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    print('the whole page is refreshed');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _postMessageBox,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('H O M E'),
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: _buildPostList(listeningProvider.allPosts),
    );
  }

  Widget _buildPostList(List<Post> posts) {
    return posts.isEmpty
        ? const Center(child: Text('No post found in tute'))
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return CustomPostTile(
                post: post,
                onUserTap: () => goUserPage(context, post.uid),
                onPostTap: () => goPostPage(context, post),
              );
            },
          );
  }
}
