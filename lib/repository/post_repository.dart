import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:unit_testing_counter/global/utils/app_urls.dart';
import 'package:unit_testing_counter/model/posts.dart';

class PostRepository {
  final http.Client client;
  PostRepository({required this.client});

  Future<List<Posts>> getPosts() async {
    try {
      final response = await client
          .get(Uri.parse(AppUrls.getPosts))
          .timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Posts.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized");
      } else {
        throw Exception("Posts couldnt be fetched");
      }
    } on SocketException {
      throw const SocketException("No Internet Connection");
    } on TimeoutException {
      throw TimeoutException("Request Timeout");
    } catch (e) {
      throw Exception("Maformed Json");
    }
  }

  Future<bool> createPost(Posts post) async {
    final response = await client.post(Uri.parse(AppUrls.createPost),
        body: jsonEncode(post.toJson()));

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception("Post couldnt be created");
    }
  }

  Future<bool> updatePost(Posts post) async {
    final response = await client.put(Uri.parse(AppUrls.updatePost),
        body: jsonEncode(post.toJson()));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Post couldnt be updated");
    }
  }

  Future<bool> updatePostProperty() async {
    final response = await client.patch((Uri.parse(AppUrls.updatePostPropery)),
        body: jsonEncode({"title": "foor"}));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Post property couldn't be updated");
    }
  }

  Future<bool> deletePost() async {
    final response = await client.delete(Uri.parse(AppUrls.deletePost));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Post couldn't be deleted");
    }
  }
}
