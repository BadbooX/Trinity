import 'package:bite/components/link.dart';
import 'package:bite/models/cart_product.dart';
import 'package:bite/services/cart_service.dart';
import 'package:bite/services/router.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String shopName;
  final double price;
  final int id;

  const ProductCard(
      {super.key,
      required this.image,
      required this.name,
      required this.shopName,
      required this.price,
      required this.id});

  @override
  Widget build(BuildContext context) {
    final cartService = getIt.get<CartService>();

    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0xffde1826),
            spreadRadius: 0,
            blurRadius: 0,
            offset: const Offset(-4, 0),
          ),
          BoxShadow(
            color: Color.fromARGB(78, 0, 0, 0),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 0),
          )
        ],
      ),
      padding: const EdgeInsets.fromLTRB(8, 0, 6, 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sell_outlined,
                    size: 16,
                    weight: 600,
                    color: Color(0xffde1628),
                  ),
                  Text(
                    '$price €',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  )
                ],
              ),
              IconButton(
                  onPressed: () => {
                        cartService.addProduct(
                          CartProduct(
                              id: id,
                              name: name,
                              quantity: 1,
                              price: price * 100,
                              imgUri: image),
                        ),
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor:
                                const Color.fromARGB(255, 209, 255, 243),
                            content: Row(
                              children: [
                                Icon(Icons.check_circle_outline,
                                    color: Color.fromARGB(255, 0, 161, 113)),
                                const SizedBox(width: 10),
                                Text('Product added to cart',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Color.fromARGB(
                                                255, 0, 161, 113))),
                              ],
                            )))
                      },
                  splashColor: Color(0x10de1628),
                  focusColor: Color(0x10de1628),
                  hoverColor: Color(0x10de1628),
                  icon: Icon(
                    Icons.add_shopping_cart,
                    color: Color(0xffde1826),
                  ))
            ],
          ),
          Image(
            image: Image.network(image).image,
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.store_outlined,
                color: Color(0xffde1628),
              ),
              Link(
                text: shopName,
                route: '',
                isExternal: false,
                fontSize: 6,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                  onPressed: () => router.go('/product/$id'),
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
                  ),
                  child: Text(name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textWidthBasis: TextWidthBasis.parent,
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                            shadows: [
                              Shadow(color: Colors.black, offset: Offset(0, -3))
                            ],
                            color: Colors.transparent,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xffde1826),
                            decorationThickness: 4,
                            decorationStyle: TextDecorationStyle.solid,
                          )))
            ],
          ),
        ],
      ),
    );
  }
}
