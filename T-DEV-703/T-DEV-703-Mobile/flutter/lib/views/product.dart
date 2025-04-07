import 'package:bite/components/buttons/secondary_button.dart';
import 'package:bite/components/titles/page_title.dart';
import 'package:bite/layouts/auth_pages_layout.dart';
import 'package:bite/models/cart_product.dart';
import 'package:bite/models/product.dart';
import 'package:bite/services/cart_service.dart';
import 'package:bite/services/product_service.dart';
import 'package:bite/services/router.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

class ProductView extends StatefulWidget {
  final String idProduct;
  const ProductView({super.key, required this.idProduct});

  @override
  State<ProductView> createState() => _ProductState();
}

class _ProductState extends State<ProductView> {
  bool _isLoading = false;
  final ProductService productService = getIt.get<ProductService>();
  final CartService cartService = getIt.get<CartService>();
  Product? product;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  void _loadProduct() {
    setState(() {
      _isLoading = true;
    });
    productService.getProductById(widget.idProduct).then((value) {
      setState(() {
        product = value;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthPagesLayout(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: Color(0xffde1826),
              ))
            : Column(
                spacing: 12,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        iconSize: 24,
                        onPressed: () {
                          router.go('/');
                        },
                      ),
                      PageTitle(text: product!.name),
                    ],
                  ),
                  Image.network(
                    product!.image!,
                    width: 200,
                    height: 200,
                  ),
                  Row(
                    spacing: 32,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.sell_outlined, color: Color(0xffde1826)),
                          Text('${product!.price} €',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      SecondaryButton(
                          text: 'Add to cart',
                          icon: Icons.add_shopping_cart,
                          onPressed: () => {
                                cartService.addProduct(CartProduct(
                                    id: product!.id,
                                    name: product!.name,
                                    quantity: 1,
                                    price: product!.price,
                                    imgUri: product!.image!)),
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(Icons.check_circle_outline,
                                            color: Color.fromARGB(
                                                255, 0, 161, 113)),
                                        const SizedBox(width: 10),
                                        Text('Product added to cart',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: Color.fromARGB(
                                                        255, 0, 161, 113))),
                                      ],
                                    ),
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: const Color.fromARGB(
                                        255, 209, 255, 243),
                                  ),
                                )
                              }),
                    ],
                  ),
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text: 'Ingredients: ',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(
                                color: Color(0xff000000),
                                offset: Offset(0, -1),
                              ),
                            ],
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xffde1826),
                            decorationThickness: 4,
                          ),
                      children: <TextSpan>[
                        TextSpan(
                          text: product!.ingredients ?? 'No ingredients',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Color(0xff000000),
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Nutritional values:',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(
                                  color: Color(0xff000000),
                                  offset: Offset(0, -1),
                                ),
                              ],
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xffde1826),
                              decorationThickness: 4,
                            ),
                      ),
                    ],
                  ),
                  product!.ingredients == '{}' ||
                          product!.ingredients == '[]' ||
                          product!.ingredients == null ||
                          product!.ingredients == ''
                      ? Text('No nutritional values')
                      : Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: product!.nutrientLevels!['fat'] == 'high'
                                    ? Color.fromARGB(255, 247, 193, 197)
                                    : product!.nutrientLevels!['fat'] ==
                                            'moderate'
                                        ? Color.fromARGB(255, 255, 244, 235)
                                        : Color.fromARGB(255, 213, 255, 237),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 32,
                                children: [
                                  Text('Fat:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                  Text(product!.nutrientLevels!['fat'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: product!
                                            .nutrientLevels!['saturated-fat'] ==
                                        'high'
                                    ? Color.fromARGB(255, 247, 193, 197)
                                    : product!.nutrientLevels![
                                                'saturated-fat'] ==
                                            'moderate'
                                        ? Color.fromARGB(255, 255, 244, 235)
                                        : Color.fromARGB(255, 213, 255, 237),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 32,
                                children: [
                                  Text('Saturated fat:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                  Text(
                                      product!.nutrientLevels!['saturated-fat'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: product!.nutrientLevels!['sugars'] ==
                                        'high'
                                    ? Color.fromARGB(255, 247, 193, 197)
                                    : product!.nutrientLevels!['sugars'] ==
                                            'moderate'
                                        ? Color.fromARGB(255, 255, 244, 235)
                                        : Color.fromARGB(255, 213, 255, 237),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 32,
                                children: [
                                  Text('Sugars:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                  Text(product!.nutrientLevels!['sugars'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: product!.nutrientLevels!['salt'] ==
                                        'high'
                                    ? Color.fromARGB(255, 247, 193, 197)
                                    : product!.nutrientLevels!['salt'] ==
                                            'moderate'
                                        ? Color.fromARGB(255, 255, 244, 235)
                                        : Color.fromARGB(255, 213, 255, 237),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 32,
                                children: [
                                  Text('Salt:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                  Text(product!.nutrientLevels!['salt'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Nutritional scores:',
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        shadows: [
                                          Shadow(
                                            color: Color(0xff000000),
                                            offset: Offset(0, -1),
                                          ),
                                        ],
                                        decoration: TextDecoration.underline,
                                        decorationColor: Color(0xffde1826),
                                        decorationThickness: 4,
                                      ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/nutri-${product!.nutriscore}.png',
                                  width: 100,
                                  height: 100,
                                ),
                                Image.asset(
                                  'assets/images/nova${product!.novaGroup}.png',
                                  width: 80,
                                  height: 80,
                                )
                              ],
                            )
                          ],
                        )
                ],
              ));
  }
}
