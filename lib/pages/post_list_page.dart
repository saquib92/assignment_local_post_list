import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/post_controller.dart';

class PostListPage extends StatelessWidget {
  final PostController postController = Get.put(PostController());

  PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: Obx(
        () {
          if (postController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (postController.posts.isEmpty) {
            return const Center(child: Text('No posts available'));
          }

          return ListView.builder(
            itemCount: postController.posts.length,
            itemBuilder: (context, index) {
              final post = postController.posts[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.body),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          postController.fetchPostsFromLocalDb();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
