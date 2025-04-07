import 'package:bite/models/cart_product.dart';

class Cart {
  final List<CartProduct> products;
  double total = 0;

  Cart({required this.products, required this.total});
}
