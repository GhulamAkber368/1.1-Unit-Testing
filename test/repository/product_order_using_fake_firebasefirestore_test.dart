import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unit_testing_counter/model/product_order.dart';
import 'package:unit_testing_counter/repository/product_order_repository.dart';

void main() {
  late FakeFirebaseFirestore fakeFirebaseFirestore;
  late ProductOrderRepository productOrderRepository;

  setUp(() {
    fakeFirebaseFirestore = FakeFirebaseFirestore();
    productOrderRepository = ProductOrderRepository(fakeFirebaseFirestore);
  });

  group("Product Order Repository", () {
    group("Product Order CRUD", () {
      ProductOrder productOrder =
          ProductOrder(name: "Mobile", price: 200, user: "Ghulam Akber");

      test(
          "given Product Order Repository class when setProductORder Func is called then Product Order should be created",
          () async {
        await productOrderRepository.setProductOrder("1", productOrder);
        ProductOrder fetchedProductOrder =
            await productOrderRepository.getProductOrder("1");
        // Creating two separate ProductOrder objects with the same data, they’re not identical, so expect(fetchedProductOrder, productOrder) fails.
        // Therefore we have to convert them in .toJson again to compare them in Map
        // expect(fetchedProductOrder, productOrder);
        expect(fetchedProductOrder.toJson(), productOrder.toJson());
      });

      test(
          "given Product Order Repository class when getProductORder Func is called then Product Order should be returned",
          () async {
        await productOrderRepository.setProductOrder("1", productOrder);
        ProductOrder fetchedProductOrder =
            await productOrderRepository.getProductOrder("1");
        expect(fetchedProductOrder.toJson(), productOrder.toJson());
      });

      test(
          "given Product Order Repository class when getProductORder Func is called and Product Order is not exist then Exception should be thrown",
          () async {
        await productOrderRepository.setProductOrder("1", productOrder);
        expect(productOrderRepository.getProductOrder("2"), throwsException);
      });

      test(
          "given Product Order Repository Class when getProductOrder Func updated some value then it should be updated",
          () async {
        await productOrderRepository.setProductOrder("1", productOrder);
        await productOrderRepository.updateProductOrder(
            ProductOrder(name: "Samsung", price: 200, user: "Ghulam Akber"));
        ProductOrder fetchedProductOrder =
            await productOrderRepository.getProductOrder("1");
        expect(fetchedProductOrder.name, "Samsung");
      });

      test(
          "given Product Order Repository Class when deleteProductOrder Func is called then product order should be deleted",
          () async {
        await productOrderRepository.setProductOrder("1", productOrder);
        await productOrderRepository.deleteProductOrder("1");
        expect(productOrderRepository.getProductOrder("1"), throwsException);
      });
    });
  });
}
