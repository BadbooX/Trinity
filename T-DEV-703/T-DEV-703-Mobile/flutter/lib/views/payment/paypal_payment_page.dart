import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:bite/views/payment/payment_status_page.dart';
import 'package:bite/services/order_service.dart';
import 'package:bite/models/order.dart';
import 'package:go_router/go_router.dart';
import 'package:bite/services/notifications_service.dart';



class PaypalPaymentPage extends StatefulWidget {
  final int orderId;
  
  const PaypalPaymentPage({Key? key, required this.orderId}) : super(key: key);

  @override
  State<PaypalPaymentPage> createState() => _PaypalPaymentPageState();
}

class _PaypalPaymentPageState extends State<PaypalPaymentPage> {
  OrderService orderService = GetIt.instance<OrderService>();
  Order? order;
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    try {
      Order? fetchedOrder = await orderService.fetchOrderById(widget.orderId);
      if (fetchedOrder == null) {
        setState(() {
          errorMessage = "Order not found.";
          isLoading = false;
        });
        return;
      }

      setState(() {
        order = fetchedOrder;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error while loading order.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientId = dotenv.env['CLIENT_ID_PAYPAL'];
    final secretKey = dotenv.env['SECRET_KEY_PAYPAL'];
    
    if(clientId == null || secretKey == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Paypal payment")),
        body: const Center(
          child: Text("Error:  Paypal key not found."),
        ),
      );
    }

    if(isLoading){
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if(errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Paypal payment")),
        body: Center(
          child: Text(errorMessage, style: const TextStyle(color: Colors.red))
        ),
      );
    }

    if(order == null){
      return Scaffold(
        appBar: AppBar(title: const Text("Paypal payment")),
        body: Center(
          child: Text("No orders found."),
        ),
      );
    }

    // Extract data's of order 
    double totalAmount = order!.priceTTC.toDouble();
    String currency =  "EUR";
    List<Map<String,dynamic>> items = order!.orderProducts.map((product) {
      return{
        "name": product.name,
        "quantity": product.quantity,
        "price": product.priceHT.toString(),
        "currency": "EUR",
      };
    }).toList();


    return Scaffold(
      appBar: AppBar(title: const Text("Paypal payment")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Future.delayed(Duration.zero, () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => PaypalCheckoutView(
                  sandboxMode: true,
                  clientId: clientId,
                  secretKey: secretKey,
                  transactions: [
                    {
                      "amount": {
                        "total": totalAmount.toStringAsFixed(2),
                        "currency": currency,
                        "details": {
                          "subtotal": totalAmount.toStringAsFixed(2),
                          "shipping": '0',
                          "shipping_discount": 0
                        }
                      },
                      "description": "Order n°${order!.id}",
                      "item_list": {
                        "items": items
                      }
                    }
                  ],
                  note: "Contact us if you have some questions.",

                  // In case of success
                  onSuccess: (Map params) async {
                    log("this is the complete logs of params : $params");
                    var totalPaid = params['data']['transactions'][0]['amount']['total'];
                    var currencyUsed = params['data']['transactions'][0]['amount']['currency'];
                    var purchasedItems = params['data']['transactions'][0]['item_list']['items'];
                    
                    // Display a notification with the total Paid
                    await NotificationService.showNotification(
                      title: "Payment Successful 🎉",
                      body: "You paid $totalPaid $currencyUsed successfully!",
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Paiement réussi : $totalPaid $currencyUsed")),
                    );
                    context.go('/payment-status', extra: {
                      "status": "success",
                      "total": totalPaid,
                      "currency": currencyUsed,
                      "items": purchasedItems,
                    });
                  },
                  // In case of error
                  onError: (error) {
                    log("Payment Failed");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Payment failed : $error")),
                    );
                    context.go('/payment-status', extra: {
                      "status": "error",
                    });
                  },
                  onCancel: () {
                    log("payment canceled");
                    ScaffoldMessenger.of(context).showSnackBar( 
                    const SnackBar(content: Text("Payment canceled by user.")),
                    );
                    context.go('/payment-status', extra: {
                      "status": "cancel",
                    });
                  },
                ),
              ));
            });
          },
          child: const Text('Pay with paypal'),
        ),
      ),
    );
  }
}
