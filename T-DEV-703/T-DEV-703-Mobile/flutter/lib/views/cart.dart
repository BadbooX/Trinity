import 'package:bite/components/buttons/main_actionn_button.dart';
import 'package:bite/components/titles/page_title.dart';
import 'package:bite/layouts/auth_pages_layout.dart';
import 'package:bite/models/cart.dart';
import 'package:bite/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  bool _isLoading = false;
  final cartService = getIt.get<CartService>();
  Cart? cart;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  void _loadCart() {
    _isLoading = true;
    cartService.getCart().then((data) {
      setState(() {
        cart = data;
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
                color: const Color(
                  0xFFDE2816,
                ),
              ),
            )
          : Column(children: [
              PageTitle(text: 'Your cart'),
              cart == null
                  ? Text('Cart is empty')
                  : SingleChildScrollView(
                      child: SizedBox(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: cart!.products.length,
                              itemBuilder: (context, index) => ListTile(
                                title: Text(
                                  cart!.products[index].name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        shadows: [
                                          Shadow(
                                              color: Colors.black,
                                              offset: Offset(0, -3))
                                        ],
                                        color: Colors.transparent,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Color(0xffde1826),
                                        decorationThickness: 4,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                      ),
                                ),
                                subtitle: Text(
                                    '${(cart!.products[index].price * cart!.products[index].quantity / 100).toStringAsFixed(2)}€'),
                                trailing: SizedBox(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        iconSize: 16,
                                        onPressed: () {
                                          cartService.removeProduct(
                                              cart!.products[index]);
                                          _loadCart();
                                        },
                                      ),
                                      Text(cart!.products[index].quantity
                                          .toString()),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        iconSize: 16,
                                        onPressed: () {
                                          cartService.addProduct(
                                              cart!.products[index]);
                                          _loadCart();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                leading: Image.network(
                                    cart!.products[index].imgUri,
                                    width: 50),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Total: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black,
                                            offset: Offset(0, -3))
                                      ],
                                      color: Colors.transparent,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color(0xffde1826),
                                      decorationThickness: 4,
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                    ),
                                children: [
                                  TextSpan(
                                    text:
                                        '${(cart!.total / 100).toStringAsFixed(2)}€',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                          shadows: [
                                            Shadow(
                                                color: Colors.black,
                                                offset: Offset(0, -3))
                                          ],
                                          color: Colors.transparent,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            MainActionnButton(
                                text: 'Pay',
                                icon: Icons.payment_outlined,
                                onPressed: () => {})
                          ],
                        ),
                      ),
                    ),
            ]),
    );
  }
}
