import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing_counter/global/utils/app_urls.dart';
import 'package:unit_testing_counter/model/posts.dart';
import 'package:unit_testing_counter/repository/post_repository.dart';

class MockHttpClient extends Mock implements Client {}

void main() {
  late PostRepository postRepository;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    postRepository = PostRepository(client: mockHttpClient);
  });

  group("Post Class", () {
    group("getPosts Func", () {
      test(
          "given Post Repository class when getPosts Func called and status code is 200 then list of Posts should be returned",
          () async {
        when(() => mockHttpClient.get(Uri.parse(AppUrls.getPosts)))
            .thenAnswer((ans) async {
          return Response("""
[
    {
        "userId": 1,
        "id": 1,
        "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
        "body": "quia et suscipitsuscipit recusandae consequuntur expedita et cumreprehenderit molestiae ut ut quas totamnostrum rerum est autem sunt rem eveniet architecto"
    },
    {
        "userId": 1,
        "ida": "2",
        "title": "qui est esse",
        "body": "est rerum tempore vitaesequi sint nihil reprehenderit dolor beatae ea dolores nequefugiat blanditiis voluptate porro vel nihil molestiae ut reiciendisqui aperiam non debitis possimus qui neque nisi nulla"
    }
    ]
    """, 200);
        });
        // Here above stubbed response is used. Actual api with real response never used. Main aim of unit testing is to test internal logic of code not external apis. If external API response changed you have to change fake response and your internal code.
        // With real API getPosts returns a List of Posts. Here with fake stubbed response, getPosts also returning a List of Posts
        // For testing Real Api Responses you have to use Integration Testing
        // Posts.fromJson(json) from getPosts is using fake response to convert response into List of Posts
        // Post.fromJson will only pick id from fake response as ida not available in Post.fromJson so it will not be picked.
        final List<Posts> posts = await postRepository.getPosts();
        expect(posts, isA<List<Posts>>());
        // stubbed response only check if objects are created or not. If you want to go in more depth of testing you have to add more assertions like below.
        expect(posts[0].id, isA<int>());
      });

      test(
          "given Post Repository class when getPosts Func is called and status code is not 200 then exception should be thrown",
          () {
        when(() => mockHttpClient.get(Uri.parse(AppUrls.getPosts)))
            .thenAnswer((answer) async {
          return Response("{}", 500);
        });
        // Here we are giving fake empty fake response with 500. In getPosts with real API when response is 500 then it throws exception. Here with fake response getPost function also works in the same way
        // final posts = postRepository.getPosts(); Incorrect way
        // Below is the correct way to wait expect to run the func. Using above line code expect will not wait correctly.
        expect(postRepository.getPosts(), throwsException);
      });

      group("getPost Func Edge Cases", () {
        test(
            "given Post Repository Class when getPosts Func is called and status code is 401 then Exception  message Unauthorized access should be thown.",
            () {
          when(() => mockHttpClient.get(Uri.parse(AppUrls.getPosts)))
              .thenAnswer((ans) async {
            return Response("{}", 401);
          });
          expect(postRepository.getPosts(), throwsException);
        });

        test(
            "given Post Reposity Class when getPosts Func is called and Internet Connect is not available then Socket Exception with message No Internet Connection should be thrown",
            () {
          when(() => mockHttpClient.get(Uri.parse(AppUrls.getPosts)))
              .thenThrow(const SocketException("No Internet Connection"));
          expect(
              postRepository.getPosts(),
              throwsA(
                isA<SocketException>().having(
                    (e) => e.message, 'message', 'No Internet Connection'),
              ));
          // If you want to run a code multipe times then use below code. For example if we try to check Internet Connection 3 Times
          // verify(() => mockHttpClient.get(Uri.parse('https://api.example.com/posts'))).called(3);
        });
        test(
            "given Post Repository Class when getPost Func is called and Request Time Out then Time Out Exception should be thown.",
            () async {
          when(() => mockHttpClient.get(Uri.parse(AppUrls.getPosts)))
              .thenAnswer((ans) => Future.delayed(
                  const Duration(seconds: 3), () => Response("{}", 200)));
          expect(
              postRepository.getPosts(),
              throwsA(
                isA<TimeoutException>()
                    .having((e) => e.message, 'message', 'Request Timeout'),
              ));
        });
      });
    });

    group('createPost Func', () {
      test(
          "given Post Repository class when createPost Func is called and response is 201 then true should be return",
          () async {
        Posts post = Posts(title: "foo", body: "baar", userId: 1);
        when(() => mockHttpClient.post(Uri.parse(AppUrls.createPost),
            body: jsonEncode(post.toJson()))).thenAnswer((ans) async {
          return Response("""
{
    "title": "foo",
    "body": "baar",
    "userId": 1,
    "id": 101
}
""", 201);
        });

        final bool = await postRepository.createPost(post);
        expect(bool, true);
      });

      test(
          "given Repository Class when createPost Function is called and response is not 201 then exception should be thrown",
          () async {
        Posts post = Posts(title: "foo", body: "baar", userId: 1);
        when(() => mockHttpClient.post(Uri.parse(AppUrls.createPost),
            body: jsonEncode(post.toJson()))).thenAnswer((ans) async {
          return Response("{}", 500);
        });
        expect(postRepository.createPost(post), throwsException);
      });
    });

    group("updatePost Func", () {
      test(
          "given Post Repository Class when updatePost Func is called and status code is 200 then post should be updated",
          () async {
        Posts post = Posts(title: "foo", body: "boar", userId: 1);

        when(() => mockHttpClient.put(Uri.parse(AppUrls.updatePost),
            body: jsonEncode(post.toJson()))).thenAnswer((ans) async {
          return Response("""
{
    "title": "foo",
    "body": "boar",
    "userId": 1,
    "id": 101
}
""", 200);
        });
        final bool = await postRepository.updatePost(post);
        expect(bool, true);
      });

      test(
          "given Post Repository Class when updatePost Func is called then status code is not 200 then exception should be thrown",
          () {
        Posts post = Posts(title: "foo", body: "boar", userId: 1);

        when(() => mockHttpClient.put(Uri.parse(AppUrls.updatePost),
            body: jsonEncode(post.toJson()))).thenAnswer((ans) async {
          return Response("{}", 500);
        });
        expect(postRepository.updatePost(post), throwsException);
      });
    });

    group("updatePostPropery Func", () {
      test(
          "given Post Repository Class when updatePostPropery Func is called and status is 200 then post propery should be update",
          () async {
        when(() => mockHttpClient.patch(Uri.parse(AppUrls.updatePostPropery),
            body: jsonEncode({"title": "foor"}))).thenAnswer((ans) async {
          return Response("""
{
    "userId": 1,
    "id": 1,
    "title": "foor",
    "body": "boar"
}
""", 200);
        });

        final bool = await postRepository.updatePostProperty();
        expect(bool, true);
      });

      test(
          "given Post Repository Class when updatePostProperty func is called and status code is not 200 then exception should be thrown",
          () {
        when(() => mockHttpClient.patch(Uri.parse(AppUrls.updatePostPropery),
            body: jsonEncode({"title": "foor"}))).thenAnswer((ans) async {
          return Response("{}", 500);
        });

        expect(postRepository.updatePostProperty(), throwsException);
      });
    });

    group("deletePost Func", () {
      test(
          "given Repository Class when deletePost Func is called and status is 200 then true should be return",
          () async {
        when(() => mockHttpClient.delete(Uri.parse(AppUrls.deletePost)))
            .thenAnswer((ans) async {
          return Response("{}", 200);
        });
        final bool = await postRepository.deletePost();
        expect(bool, true);
      });

      test(
          "given Post Respost Class when deletePost Func is called and status is not 200 then exception should be thrown",
          () {
        when(() => mockHttpClient.delete(Uri.parse(AppUrls.deletePost)))
            .thenAnswer((ans) async {
          return Response("{}", 500);
        });
        expect(postRepository.deletePost(), throwsException);
      });
    });
  });
}
