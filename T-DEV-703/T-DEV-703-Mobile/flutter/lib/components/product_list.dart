import 'package:bite/components/product_card.dart';
import 'package:flutter/material.dart';
import 'package:bite/models/product.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;

  const ProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: products
          .map((product) => ProductCard(
                image: product.image ?? '',
                name: product.name,
                shopName: product.shopName,
                price: product.price,
                id: product.id,
              ))
          .toList(),
    );
  }
}
