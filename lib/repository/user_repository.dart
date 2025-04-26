import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unit_testing_counter/global/utils/app_urls.dart';
import 'package:unit_testing_counter/model/user.dart';

class UserRepository {
  final http.Client client;
  UserRepository(this.client);
  Future<User> getUser() async {
    final response = await client.get(Uri.parse(AppUrls.getUser));
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Something went Wrong");
    }
  }
}
