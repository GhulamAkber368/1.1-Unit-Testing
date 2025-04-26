import 'package:flutter_test/flutter_test.dart';
import 'package:unit_testing_counter/model/product.dart';
import 'package:unit_testing_counter/controller/shopping_cart_controller.dart';

void main() {
  late ShoppingCartController cartController;
  setUp(() {
    cartController = ShoppingCartController();
  });

  group("Shopping Cart Class", () {
    test("given cart class when product is added cart size should increase",
        () {
      cartController
          .addProductToCart(Product(name: "Apple", price: 10.5, quantity: 1));
      expect(cartController.products.length, 1);
    });

    test(
        "given cart class when existing item added again its quantity should be incremented",
        () {
      cartController
          .addProductToCart(Product(name: "Apple", price: 10.5, quantity: 1));
      cartController
          .addProductToCart(Product(name: "Banana", price: 10.5, quantity: 1));
      expect(cartController.products.length, 2);
      expect(cartController.products[0].quantity, 1);
      cartController
          .addProductToCart(Product(name: "Apple", price: 10.5, quantity: 1));
      expect(cartController.products.length, 2);
      expect(cartController.products[0].quantity, 2);
    });

    test(
        "given cart class when product removed quantity should be decrease and if product not found app shouldn't crash",
        () {
      cartController
          .addProductToCart(Product(name: "Apple", price: 12, quantity: 2));
      expect(cartController.products.length, 1);
      cartController.removeProductFromCartByName("Banana");
      expect(cartController.products.length, 1);
      cartController.removeProductFromCartByName("Apple");
      expect(cartController.products.length, 0);
    });

    test(
        "given cart class when quantity updated and cart is empty app shouldn't crash",
        () {
      cartController.updateProductQuantityInCart("Apple", 2);
      expect(cartController.products.length, 0);
    });

    test(
        "given cart class when quantity updated but product doesn't exist app shouldn't crash",
        () {
      cartController
          .addProductToCart(Product(name: "Apple", price: 20, quantity: 1));
      expect(cartController.products.length, 1);
      cartController.updateProductQuantityInCart("Banana", 2);
      expect(cartController.products.length, 1);
      expect(cartController.products[0].name, "Apple");
      expect(cartController.products[0].quantity, 1);
    });

    test(
        "given cart class when quantity updated then quantity should reflected correctly",
        () {
      cartController
          .addProductToCart(Product(name: "Apple", price: 20, quantity: 1));
      cartController.updateProductQuantityInCart("Apple", 3);
      expect(cartController.products.length, 1);
      expect(cartController.products[0].quantity, 3);
    });

    test(
        "given cart class when sum of products based on their quantities calculated then it should be calculated correctly",
        () {
      cartController
          .addProductToCart(Product(name: "Apple", price: 10, quantity: 1));
      cartController
          .addProductToCart(Product(name: "Banana", price: 20, quantity: 2));
      cartController.calculatePricesSum();
      expect(cartController.pricesSum, 50);
    });

    test(
        "given cart class when cart is empty and sum of products based on their quantities calculated then sum should be 0",
        () {
      cartController.calculatePricesSum();
      expect(cartController.pricesSum, 0);
    });

    test(
        "given cart class when a product has quantity 0, it should not affect sum",
        () {
      cartController
          .addProductToCart(Product(name: "Apple", price: 20, quantity: 0));
      cartController.calculatePricesSum();
      expect(cartController.pricesSum, 0);
    });

    test(
        "given cart class when discount applied and total sum is less than threshold then total sum shouldnet be changed",
        () {
      cartController
          .addProductToCart(Product(name: "Apple", price: 20, quantity: 1));
      cartController
          .addProductToCart(Product(name: "Banana", price: 30, quantity: 1));
      cartController.calculatePricesSum();
      cartController.applyDiscount(60, 10);
      expect(cartController.pricesSum, 50);
    });

    test(
        "given cart class when discount applied then it should be calculated correctly",
        () {
      cartController
          .addProductToCart(Product(name: "Apple", price: 20, quantity: 1));
      cartController
          .addProductToCart(Product(name: "Banana", price: 30, quantity: 1));
      cartController.calculatePricesSum();
      cartController.applyDiscount(50, 10);
      expect(cartController.pricesSum, 45);
    });
  });
}
