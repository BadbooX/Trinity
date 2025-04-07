import 'dart:convert';

import 'package:bite/models/cart.dart';
import 'package:bite/models/cart_product.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CartService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  List<CartProduct> cartProducts = [];
  double total = 0;

  CartService();

  void _getCartTotal() {
    total = 0;
    for (var product in cartProducts) {
      total += product.price * product.quantity;
    }
  }

  void addProduct(CartProduct product) {
    int existingIndex =
        cartProducts.indexWhere((item) => item.id == product.id);

    if (existingIndex != -1) {
      // Product with same ID already exists
      cartProducts[existingIndex].quantity++;
      _storage.write(
          key: 'cart',
          value: json.encode(
              cartProducts.map((product) => product.toJson()).toList()));
      return;
    }

    // Product doesn't exist in cart yet
    cartProducts.add(product);
    _storage.write(
        key: 'cart',
        value: json
            .encode(cartProducts.map((product) => product.toJson()).toList()));
  }

  void removeProduct(CartProduct product) {
    int existingIndex =
        cartProducts.indexWhere((item) => item.id == product.id);

    if (existingIndex != -1) {
      if (cartProducts[existingIndex].quantity > 1) {
        cartProducts[existingIndex].quantity--;
        _storage.write(
            key: 'cart',
            value: json.encode(
                cartProducts.map((product) => product.toJson()).toList()));
        return;
      }
      cartProducts.removeAt(existingIndex);
      _storage.write(
          key: 'cart',
          value: json.encode(
              cartProducts.map((product) => product.toJson()).toList()));
    }
  }

  void clearCart() {
    cartProducts = [];
    _storage.delete(key: 'cart');
  }

  Future<Cart> getCart() async {
    final String? cart = await _storage.read(key: 'cart');
    if (cart != null) {
      cartProducts = (json.decode(cart) as List)
          .map((product) => CartProduct.fromJson(product))
          .toList();
    }
    _getCartTotal();
    return Cart(products: cartProducts, total: total);
  }
}
