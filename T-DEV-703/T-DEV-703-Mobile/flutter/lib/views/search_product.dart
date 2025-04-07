import 'package:bite/layouts/auth_pages_layout.dart';
import 'package:bite/models/cart_product.dart';
import 'package:bite/models/product.dart';
import 'package:bite/services/cart_service.dart';
import 'package:bite/services/product_service.dart';
import 'package:bite/services/router.dart';
import 'package:flutter/material.dart';
import 'package:bite/components/titles/page_title.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class SearchProductView extends StatefulWidget {
  final String barCode;
  const SearchProductView({super.key, required this.barCode});

  @override
  State<SearchProductView> createState() => _SearchProductViewState();
}

class _SearchProductViewState extends State<SearchProductView> {
  final ProductService productService = getIt.get<ProductService>();
  final CartService cartService = getIt.get<CartService>();
  bool _isLoading = false;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _searchProduct();
  }

  void _searchProduct() {
    setState(() {
      _isLoading = true;
    });

    productService.getProductByBarcode(widget.barCode).then((data) {
      setState(() {
        products = data;
        _isLoading = false; // Only set loading to false after data arrives
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false; // Also handle errors
      });
      print("Error fetching product: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthPagesLayout(
      child: Column(
        children: [
          PageTitle(text: 'Search Product'),
          if (_isLoading)
            const CircularProgressIndicator(color: Color(0xFFDE2816))
          else if (products.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No products found'),
            )
          else
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (context, position) {
                  return ListTile(
                    title: Text(products[position].name),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 16,
                      children: [
                        IconButton(
                            color: Color(0xffde2816),
                            tooltip: 'Add to cart',
                            onPressed: () => cartService.addProduct(
                                  CartProduct(
                                      id: products[position].id,
                                      name: products[position].name,
                                      quantity: 1,
                                      price: products[position].price,
                                      imgUri: products[position].image!),
                                ),
                            icon: Icon(Icons.add_shopping_cart_outlined)),
                        IconButton(
                            onPressed: () =>
                                router.go('/product/${products[position].id}'),
                            icon: Icon(Icons.visibility_outlined))
                      ],
                    ),
                    leading: products[position].image != null &&
                            products[position].image!.isNotEmpty
                        ? Image.network(products[position].image!)
                        : const Icon(Icons.image_not_supported),
                    trailing: Text('${products[position].price} €'),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
