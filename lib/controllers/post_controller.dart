import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/post_model.dart';
import '../services/database_helper.dart';
import '../constants/constants.dart';

class PostController extends GetxController {
  var posts = <Post>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchPostsFromLocalDb();
    fetchPostsFromApi();
  }

  Future<void> fetchPostsFromApi() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('${Constants.baseUrl}/posts'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        posts.value = data.map((json) => Post.fromJson(json)).toList();
        print('Fetched from API: ${posts.length} posts');
        savePostsToLocalDb(posts);
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print('Error fetching posts from API: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> savePostsToLocalDb(List<Post> postsList) async {
    await DatabaseHelper.instance.clearPosts();
    for (var post in postsList) {
      await DatabaseHelper.instance.insertPost(post);
    }
    print('Saved ${postsList.length} posts to local DB');
  }

  Future<void> fetchPostsFromLocalDb() async {
    isLoading.value = true;
    try {
      final localPosts = await DatabaseHelper.instance.getPosts();
      posts.value = localPosts;
      print('Fetched ${localPosts.length} posts from local DB');
    } catch (e) {
      print('Error fetching posts from local DB: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
