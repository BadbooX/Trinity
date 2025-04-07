import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My orders")),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          const Text("List of orders available soon"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.push('/paypal/12'); // Remplacer le 12 par un order.id
            },
            child: const Text("Pay with PayPal"),
          ),
        ],
      ),
    );
  }
}