// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing_counter/model/product_order.dart';
import 'package:unit_testing_counter/repository/product_order_repository.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

// Below Lines are for Query like where. First revise about above concepts.

class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late ProductOrderRepository productOrderRepository;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockCollectionReference mockCollRef;
  late MockDocumentReference mockDocRef;
  late MockDocumentSnapshot mockDocSnap;

  // Below Lines are for Query like where. First revise about above concepts.
  late MockQuery mockQuery;
  late MockQuerySnapshot mockDocQuerySnap;
  late MockQueryDocumentSnapshot mockDoc1, mockDoc2;
  // late MockQueryDocumentSnapshot mockDoc2;

  setUp(() {
    // using mocktail. Real Unit Testing where we are testing behavior not like actual firestore features.
    mockFirebaseFirestore = MockFirebaseFirestore();
    productOrderRepository = ProductOrderRepository(mockFirebaseFirestore);
    mockCollRef = MockCollectionReference();
    mockDocRef = MockDocumentReference();
    mockDocSnap = MockDocumentSnapshot();

    // Below Lines are for Query like where. First revise about above concepts.
    mockQuery = MockQuery();
    mockDocQuerySnap = MockQuerySnapshot();
    mockDoc1 = MockQueryDocumentSnapshot();
    mockDoc2 = MockQueryDocumentSnapshot();

    when(() => mockFirebaseFirestore.collection(any())).thenReturn(mockCollRef);
    when(() => mockCollRef.doc(any())).thenReturn(mockDocRef);
    when(() => mockDocSnap.get(any())).thenReturn(mockDocQuerySnap);

    // Below Lines are for Query like where. First revise about above concepts.
    when(() => mockFirebaseFirestore.collection("orders"))
        .thenAnswer((ans) => mockCollRef);
    when(() => mockCollRef.where("user", isEqualTo: "Ali"))
        .thenAnswer((ans) => mockQuery);
    when(() => mockQuery.get(any()))
        .thenAnswer((ans) async => mockDocQuerySnap);
  });

  group("Product Order Repository", () {
    group("Product Order CRUD", () {
      ProductOrder productOrder =
          ProductOrder(name: "Mobile", price: 200, user: "Ghulam Akber");

      test(
          "given Product Order Repository class when setProductORder Func is called then Product Order should be created",
          () async {
        // Whenever the set() method is called on mockDocRef with the productOrder.toJson() map,
        // Then just return a completed Future (i.e., do nothing, simulate success).
        //  🧠 Why this matters:
        // You're mocking Firestore's set() method so that it doesn't actually hit Firebase.
        // You're controlling its behavior to say “assume it worked.”
        when(() => mockDocRef.set(productOrder.toJson()))
            .thenAnswer((ans) => Future.value());
// You are calling your real implementation of setProductOrder() from your ProductOrderRepository.
// Under the hood, this should:
// Call FirebaseFirestore.collection("users").doc("1").set(...)
// In this case, it hits your mocked Firestore, not the real one.
        await productOrderRepository.setProductOrder("1", productOrder);
        // In below line, it will not work because here data is different
        // await productOrderRepository.setProductOrder(
        //     "1", ProductOrder(name: "asdf", price: 443, user: "sdf"));
// This verifies that the set() method was called exactly once with the expected JSON payload.
// If it was never called, or called with different data, the test will fail.
        verify(() => mockDocRef.set(productOrder.toJson())).called(1);
      });

      test(
          "given Product Order Repository Class when setProductOrder is called and product order not set successfully then exception should be thrown.",
          () {
        when(() => mockDocRef.set(any())).thenThrow(FirebaseException(
            plugin: "firestore", message: "PERMISSION_DENIED"));
        expect(
            productOrderRepository.setProductOrder("1", productOrder),
            throwsA(isA<Exception>().having(
                (e) => e.toString(), "msg", contains("PERMISSION_DENIED"))));
      });

      test(
          "given Product Order Repository Class when setProductOrder is called and product order not set successfully then generic firebase exception should be thrown.",
          () {
        when(() => mockDocRef.set(any())).thenThrow(FirebaseException(
            plugin: "firestore", message: "Some firestore error occured"));

        expect(
            productOrderRepository.setProductOrder("1", productOrder),
            throwsA(isA<FirebaseException>().having(
                (e) => e.toString(),
                "Firestore Generic Error",
                contains("Some firestore error occured"))));
      });

      test(
          "given Product Order Repository class when getProductOrder Func is called then productOrder should be return",
          () async {
        // below lines work like real getProductOrder Func. getProductOrder Func firstly will get then check if exists then return data()
        when(() => mockDocRef.get()).thenAnswer((ans) async => mockDocSnap);
        when(() => mockDocSnap.exists).thenAnswer((ans) => true);
        when(() => mockDocSnap.data())
            .thenAnswer((ans) => productOrder.toJson());

        ProductOrder fetchProductOrder =
            await productOrderRepository.getProductOrder("1");
        expect(fetchProductOrder.toJson(), productOrder.toJson());
      });

      test(
          "given Product Order Repository class when getProductOrder Func is called and document doesn't exist then it should throw an exception",
          () {
        when(() => mockDocRef.get()).thenAnswer((ans) async => mockDocSnap);
        when(() => mockDocSnap.exists).thenAnswer((ans) => false);

        expect(productOrderRepository.getProductOrder("1"), throwsException);
      });

      test(
          "given Product Order Repository Class when Product Order is updated then it should be updated successfully",
          () async {
        ProductOrder updatedProductOrder =
            ProductOrder(name: "Samsung", price: 200, user: "Ghulam Akber");

        when(() => mockDocRef.update(updatedProductOrder.toJson()))
            .thenAnswer((ans) => Future.value());

        await productOrderRepository.updateProductOrder(updatedProductOrder);

        verify(() => mockDocRef.update(updatedProductOrder.toJson()));
      });

      test(
          "given Product Order Repository Class when deleteProductOrder Func is called then Product Order should be deleted successfully",
          () async {
        when(() => mockDocRef.delete()).thenAnswer((ans) => Future.value());

        await productOrderRepository.deleteProductOrder("1");

        verify(() => mockDocRef.delete()).called(1);
      });

      test(
          "given Product Order Repository class when getAliOrders Func is called then Ali Orders should be returned",
          () async {
        final productOrder1 = {"name": "Samsung", "price": 200, "user": "Ali"};
        final productOrder2 = {"name": "Samsung", "price": 200, "user": "Ali"};

        when(() => mockDocQuerySnap.docs)
            .thenAnswer((ans) => <QueryDocumentSnapshot<Map<String, dynamic>>>[
                  mockDoc1,
                  mockDoc2,
                ]);

        when(() => mockDoc1.data()).thenAnswer((ans) => productOrder1);
        when(() => mockDoc2.data()).thenAnswer((ans) => productOrder2);

        final result = await productOrderRepository.getAliOrders();

        expect(result, [productOrder1, productOrder2]);

        verify(() => mockFirebaseFirestore.collection("orders")).called(1);
        verify(() => mockCollRef.where("user", isEqualTo: "Ali")).called(1);
        verify(() => mockQuery.get()).called(1);
      });
    });
  });
}
