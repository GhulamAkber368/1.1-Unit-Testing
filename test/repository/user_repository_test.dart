import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing_counter/global/utils/app_urls.dart';
import 'package:unit_testing_counter/model/user.dart';
import 'package:unit_testing_counter/repository/user_repository.dart';

// Client is a Abstract Class, we are implementing it in MockHTTPClient class and we have to override functions of Client in MockHTTPClient
// Mock helps in this matter. By using Mock we are giving all properties of Client to MockHTTPClient using Mock
class MockHTTPClient extends Mock implements Client {}

void main() {
  late UserRepository userRepository;
  late MockHTTPClient mockHTTPClient;

  setUp(() {
    mockHTTPClient = MockHTTPClient();
    userRepository = UserRepository(mockHTTPClient);
  });

  group("Repository Class- ", () {
    group("getUser Func", () {
      test(
          "given Repository Classs when getUser Func is called and status code is 200 then User should be returned",
          () async {
        // when something happens then something should be happen and it's called stubbin

        // Arrange
        // when something happens then something should be happen and it's called stubbin below code is stubbin

        // Using a stub, the code replaces the behavior of mockHTTPClient.get(...):
        // It specifies that whenever get() is called with the expected URI, the mock should return a Response with a JSON string (containing details for a user) and a status code of 200.

        when(() => mockHTTPClient.get(Uri.parse(AppUrls.getUser)))
            .thenAnswer((val) async {
          return Response("""
{
  "id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz",
  "address": {
    "street": "Kulas Light",
    "suite": "Apt. 556",
    "city": "Gwenborough",
    "zipcode": "92998-3874",
    "geo": {
      "lat": "-37.3159",
      "lng": "81.1496"
    }
  },
  "phone": "1-770-736-8031 x56442",
  "website": "hildegard.org",
  "company": {
    "name": "Romaguera-Crona",
    "catchPhrase": "Multi-layered client-server neural-net",
    "bs": "harness real-time e-markets"
  }
}
""", 200);
        });
        // Act
        final user = await userRepository.getUser();
        // Assert
        expect(user, isA<User>());
      });

      test(
          "given Repository Class when getUser Func is called and status case is not 200 then exception should be thrown",
          () async {
        when(() => mockHTTPClient.get(Uri.parse(AppUrls.getUser)))
            .thenAnswer((answer) async {
          return Response("{}", 500);
        });
        final user = userRepository.getUser();
        expect(user, throwsException);
      });
    });
  });
}
