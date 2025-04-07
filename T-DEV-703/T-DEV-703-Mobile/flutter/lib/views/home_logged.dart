import 'package:bite/components/product_list.dart';
import 'package:bite/components/titles/page_title.dart';
import 'package:bite/layouts/auth_pages_layout.dart';
import 'package:bite/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class HomeLogged extends StatefulWidget {
  const HomeLogged({super.key});

  @override
  _HomeLoggedState createState() => _HomeLoggedState();
}

class _HomeLoggedState extends State<HomeLogged> {
  bool isLoading = false;
  final ProductService productService = getIt.get<ProductService>();
  dynamic productList = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      isLoading = true;
    });
    productService.getProducts().then((value) {
      print('value: $value');
      setState(() {
        productList = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthPagesLayout(
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              PageTitle(text: 'All products'),
              SizedBox(height: 32),
              isLoading
                  ? CircularProgressIndicator()
                  : ProductList(products: productList),
              // Add your widgets here
            ],
          ),
        ),
      ),
    );
  }
}
