import 'package:flutter/material.dart';
import 'package:unit_testing_counter/model/product.dart';

class ShoppingCartController {
  final List<Product> _products = [];
  List<Product> get products => _products;

  addProductToCart(Product product) {
    bool isProductAlreadyExists = _products.any((p) => p.name == product.name);
    if (isProductAlreadyExists) {
      int index = products.indexWhere((val) => val.name == product.name);
      products[index].quantity = products[index].quantity! + 1;
    } else {
      _products.add(product);
    }
  }

  removeProductFromCartByName(String name) {
    int index = _products.indexWhere((val) => val.name == name);
    if (index != -1) {
      _products.removeAt(index);
    } else {
      debugPrint("Product not found in cart Test Passed");
    }
  }

  updateProductQuantityInCart(String name, int quantity) {
    int index = _products.indexWhere((val) => val.name == name);
    if (index != -1) {
      products[index].quantity = quantity;
    } else {
      debugPrint("Product not found in cart during updating Test Passed");
    }
  }

  double _pricesSum = 0;
  double get pricesSum => _pricesSum;

  calculatePricesSum() {
    _pricesSum = 0;
    for (int i = 0; i < _products.length; i++) {
      _pricesSum = _pricesSum +
          (_products[i].price!.toDouble() * _products[i].quantity!.toDouble());
    }
  }

  applyDiscount(double threshold, double discountPercentage) {
    if (_pricesSum >= threshold) {
      discountPercentage = discountPercentage / 100;
      _pricesSum = _pricesSum - (_pricesSum * discountPercentage);
    }
  }
}
