import 'package:bite/components/link.dart';
import 'package:bite/services/product_service.dart';
import 'package:bite/services/router.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

final getIt = GetIt.instance;

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => ScannerViewState();
}

class ScannerViewState extends State<ScannerView> {
  String? qrCode;
  final productsService = getIt<ProductService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (barcodeCapture) {
                setState(() {
                  qrCode = barcodeCapture.barcodes.first.rawValue;
                  if (qrCode != null) {
                    router.go('/search/$qrCode');
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
