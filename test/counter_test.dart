import 'package:flutter_test/flutter_test.dart';
import 'package:unit_testing_counter/controller/counter_controller.dart';

void main() {
  // Testing have 4 Stages
  // Prestesting
  // setUp(() => null); // is called before every test is called
  // setUp -> test -> setUp -> test -> setUp -> test
  // setUpAll(() => null); // is called before all of the test are called
  // setUpAll -> test -> test -> test
  // Testing
  // All testing comes in this type of Testing
  // // Post Testing
  // tearDown(() => null); is called after every test is called
  // test -> tearDown -> test -> tearDown -> test -> tearDown
  // tearDownAll(() => null); is called after all of the test are called
  // test -> test -> test -> tearDownAll

  // Testing
  // Arrange is a "given"
  late Counter counter;

  // Testing should be done indepentently. If we call Counter class when time then for each test counter value will change. Like for first test value is 0. for second test value is 1. for third test we are saying that value should be -1 but as we are using same counter so in last test it is incremented to 1 so in thirst it will not -1 it will 0. If counter class initiated every time before each testing then value would be 0 for each test at the starting then all tests will work independently.
  // Therefore we initiated counter class in setUp so its initiated before each test to reset counter value and each test executes indepentently.
  setUp(() => {
        // Arrange
        counter = Counter()
      });

  group("Counter Class - ", () {
    // "given when then" convention used for test case naming
    test(
        "given counter class when it is instantiated then value of count should be 0",
        () {
      // Act  is "when"
      final val = counter.count;

      // Assert is "then"
      expect(val, 0);
    });

    test(
        "given counter class when it is incremented the value of count should be 1",
        () {
      // Act
      counter.incrementCounter();
      final val = counter.count;

      // Assert
      expect(val, 1);
    });

    test(
        "given counter class when it is decremented the value of count should be -1",
        () {
      // Act
      counter.decrementCounter();
      final val = counter.count;
      // Assert
      expect(val, -1);
    });

    test(
        "given counter class when it is reset the value of count should be zero",
        () {
      // Act
      counter.reset();
      final val = counter.count;

      // Assert
      expect(val, 0);
    });
  });

  // Post Testing
  // tearDown(() => null);
  // tearDownAll(() => null);
}
