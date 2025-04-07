import 'package:flutter/material.dart';
import '../../main.dart';
import 'package:go_router/go_router.dart';

class PaymentStatusPage extends StatelessWidget {
  final String status; // "success", "error" ou "cancel"
  final String? total;
  final String? currency;
  final List<dynamic>? items;

  const PaymentStatusPage({
    super.key,
    required this.status,
    this.total,
    this.currency,
    this.items
    });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;
    String message;


    if(status == "success") {
      message = "The payment succeed 🎉";
      icon = Icons.check_circle;
      iconColor = Colors.green;
    }else if(status == "error"){
      message = "Error during the payment ❌";
      icon = Icons.error;
      iconColor = Colors.red;
    }else {
      message = "Payment cancelled";
      icon = Icons.cancel;
      iconColor = Colors.orange;
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Payment status")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: iconColor, size:80),
            const SizedBox(height: 16),
            Text(
              "Payment status : $status",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(message),
            const SizedBox(height: 64),
            const Text(
              "Purchase summary :",
              style: const TextStyle(fontSize: 18,fontWeight:FontWeight.bold)
            ),
            const SizedBox(height: 16),
            Column(
              children: items?.map((item) {
                return Text(
                  "${item['name']} x${item['quantity']} - ${item['price']} $currency",
                  style: const TextStyle(fontSize: 14),
                );
              }).toList() ?? [],
            ),
            const SizedBox(height: 16),
            if ((total ?? '').isNotEmpty && (currency ?? '').isNotEmpty)
              Text(
                "You just paid $total $currency",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: const Text('Go back to the website'),
            ),
          ],
        ),
        
      ),
    );
  }
}
