import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // For loading assets
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';

Future<File> generateInvoicePDF(Map<String, dynamic> orderData) async {
  final pdf = pw.Document();

  // Load Roboto fonts from assets
  final regularFont = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));
  final boldFont = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Bold.ttf'));

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) => [
        _buildHeader(orderData, regularFont, boldFont),
        pw.SizedBox(height: 20),
        _buildOrderInfo(orderData, regularFont, boldFont),
        pw.SizedBox(height: 20),
        _buildProductsByShop(orderData['orderProducts'], orderData['OrderShops'], regularFont, boldFont),
        pw.SizedBox(height: 20),
        _buildTotal(orderData, regularFont, boldFont),
        pw.SizedBox(height: 20),
        _buildShopInfo(orderData['OrderShops'], regularFont, boldFont),
      ],
    ),
  );

  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/invoice_${orderData['id']}.pdf');
  await file.writeAsBytes(await pdf.save());
  
  return file;
}

// Header section
pw.Widget _buildHeader(Map<String, dynamic> orderData, pw.Font regularFont, pw.Font boldFont) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text('INVOICE #${orderData['id']}', 
        style: pw.TextStyle(fontSize: 24, font: boldFont)),
      pw.Text('Date: ${orderData['createdAt'].substring(0, 10)}', style: pw.TextStyle(font: regularFont)),
    ],
  );
}

// Order information section
pw.Widget _buildOrderInfo(Map<String, dynamic> orderData, pw.Font regularFont, pw.Font boldFont) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Delivery Address', style: pw.TextStyle(font: boldFont)),
          pw.Text(orderData['deliverystreet'], style: pw.TextStyle(font: regularFont)),
          pw.Text('${orderData['deliverypostalCode']} ${orderData['deliverycity']}', style: pw.TextStyle(font: regularFont)),
          pw.Text(orderData['deliverycountry'].toString().toUpperCase(), style: pw.TextStyle(font: regularFont)),
        ],
      ),
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Billing Address', style: pw.TextStyle(font: boldFont)),
          pw.Text(orderData['billingstreet'], style: pw.TextStyle(font: regularFont)),
          pw.Text('${orderData['billingpostalCode']} ${orderData['billingcity']}', style: pw.TextStyle(font: regularFont)),
          pw.Text(orderData['billingcountry'].toString().toUpperCase(), style: pw.TextStyle(font: regularFont)),
        ],
      ),
    ],
  );
}

// Products by shop
pw.Widget _buildProductsByShop(List<dynamic> products, List<dynamic> orderShops, pw.Font regularFont, pw.Font boldFont) {
  final shopMap = Map.fromEntries(
    orderShops.map((shop) => MapEntry(shop['shopId'], shop['shop']['name'])),
  );

  final Map<int, List<dynamic>> productsByShop = {};
  for (var product in products) {
    final shopId = product['shopId'];
    if (!productsByShop.containsKey(shopId)) {
      productsByShop[shopId] = [];
    }
    productsByShop[shopId]!.add(product);
  }

  final List<pw.Widget> shopSections = [];
  productsByShop.forEach((shopId, shopProducts) {
    shopSections.addAll([
      pw.Text('Shop: ${shopMap[shopId]}',
        style: pw.TextStyle(fontSize: 16, font: boldFont)),
      pw.SizedBox(height: 10),
      pw.Table(
        border: pw.TableBorder.all(),
        columnWidths: {
          0: pw.FlexColumnWidth(2),
          1: pw.FlexColumnWidth(1),
          2: pw.FlexColumnWidth(1),
          3: pw.FlexColumnWidth(1),
        },
        children: [
          pw.TableRow(
            decoration: pw.BoxDecoration(color: PdfColors.grey300),
            children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text('Product', style: pw.TextStyle(font: boldFont)),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text('Quantity', style: pw.TextStyle(font: boldFont)),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text('Unit Price (€)', style: pw.TextStyle(font: boldFont)),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text('Total (€)', style: pw.TextStyle(font: boldFont)),
              ),
            ],
          ),
          ...shopProducts.map((product) => pw.TableRow(
            children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text(product['name'], style: pw.TextStyle(font: regularFont)),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text(
                  (product['priceTotalHT'] / product['priceHT']).toStringAsFixed(0),
                  style: pw.TextStyle(font: regularFont),
                ),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text(
                  '${(product['priceTTC'] / 100).toStringAsFixed(2)} €',
                  style: pw.TextStyle(font: regularFont),
                ),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Text(
                  '${(product['priceTotalTTC'] / 100).toStringAsFixed(2)} €',
                  style: pw.TextStyle(font: regularFont),
                ),
              ),
            ],
          )).toList(),
        ],
      ),
      pw.SizedBox(height: 20),
    ]);
  });

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: shopSections,
  );
}

// Total section
pw.Widget _buildTotal(Map<String, dynamic> orderData, pw.Font regularFont, pw.Font boldFont) {
  return pw.Container(
    alignment: pw.Alignment.centerRight,
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            pw.Text('Subtotal (HT): ', style: pw.TextStyle(font: regularFont)),
            pw.Text('${(orderData['priceHT'] / 100).toStringAsFixed(2)} €', style: pw.TextStyle(font: regularFont)),
          ],
        ),
        pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            pw.Text('VAT (TVA): ', style: pw.TextStyle(font: regularFont)),
            pw.Text('${(orderData['priceTVA'] / 100).toStringAsFixed(2)} €', style: pw.TextStyle(font: regularFont)),
          ],
        ),
        pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            pw.Text('Total (TTC): ', style: pw.TextStyle(font: boldFont)),
            pw.Text('${(orderData['priceTTC'] / 100).toStringAsFixed(2)} €', style: pw.TextStyle(font: boldFont)),
          ],
        ),
      ],
    ),
  );
}

// Shop information section
pw.Widget _buildShopInfo(List<dynamic> shops, pw.Font regularFont, pw.Font boldFont) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text('Shop Information', style: pw.TextStyle(font: boldFont)),
      pw.SizedBox(height: 10),
      ...shops.map((shop) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(shop['shop']['name'], style: pw.TextStyle(font: regularFont)),
          pw.Text(shop['shopstreet'], style: pw.TextStyle(font: regularFont)),
          pw.Text('${shop['shoppostalCode']} ${shop['shopcity']}', style: pw.TextStyle(font: regularFont)),
          pw.Text(shop['shopcountry'].toString().toUpperCase(), style: pw.TextStyle(font: regularFont)),
          pw.Text('Phone: ${shop['shop']['phoneNumber']}', style: pw.TextStyle(font: regularFont)),
          pw.Text('Email: ${shop['shop']['email']}', style: pw.TextStyle(font: regularFont)),
          pw.SizedBox(height: 10),
        ],
      )).toList(),
    ],
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PdfGeneratorScreen(),
    );
  }
}

class PdfGeneratorScreen extends StatefulWidget {
  @override
  _PdfGeneratorScreenState createState() => _PdfGeneratorScreenState();
}

class _PdfGeneratorScreenState extends State<PdfGeneratorScreen> {
  bool _isGenerating = false;

  final Map<String, dynamic> orderData = {
    "id": 1,
    "userId": 1,
    "adminId": null,
    "priceHT": 20500,
    "priceTVA": 4100,
    "priceTTC": 24600,
    "deliverycountry": "FRANCE",
    "deliverycity": "Nancy",
    "deliverypostalCode": 54000,
    "deliverystreet": "15 rue gambetta",
    "billingcountry": "FRANCE",
    "billingcity": "Nancy",
    "billingpostalCode": 54000,
    "billingstreet": "1 rue des factures perdue",
    "createdAt": "2025-03-18T14:55:22.751Z",
    "updatedAt": "2025-03-18T14:55:22.751Z",
    "status": "PENDING",
    "user": {
      "id": 1,
      "email": "user@example.com",
      "firstName": "string",
      "lastName": "string",
      "phoneNumber": "+33659837095"
    },
    "orderProducts": [
      {
        "productId": 1,
        "orderId": 1,
        "shopId": 1,
        "name": "steak de cheval",
        "barCode": "12345",
        "priceHT": 500,
        "priceTVA": 100,
        "priceTTC": 600,
        "priceTotalHT": 4000,
        "priceTotalTVA": 800,
        "priceTotalTTC": 4800,
        "stock": 8,
        "createdAt": "2025-03-18T14:55:22.751Z",
        "updatedAt": "2025-03-18T14:55:22.751Z",
        "product": {
          "id": 1,
          "barCode": "12345",
          "name": "steak de cheval",
          "priceHT": 500,
          "priceTTC": 600,
          "priceTVA": 100,
          "stock": 12,
          "idShop": 1
        }
      },
      {
        "productId": 2,
        "orderId": 1,
        "shopId": 1,
        "name": "cote de boeuf",
        "barCode": "12345",
        "priceHT": 6000,
        "priceTVA": 1200,
        "priceTTC": 7200,
        "priceTotalHT": 12000,
        "priceTotalTVA": 2400,
        "priceTotalTTC": 14400,
        "stock": 2,
        "createdAt": "2025-03-18T14:55:22.751Z",
        "updatedAt": "2025-03-18T14:55:22.751Z",
        "product": {
          "id": 2,
          "barCode": "12345",
          "name": "cote de boeuf",
          "priceHT": 6000,
          "priceTTC": 7200,
          "priceTVA": 1200,
          "stock": 3,
          "idShop": 1
        }
      },
      {
        "productId": 3,
        "orderId": 1,
        "shopId": 2,
        "name": "haricot",
        "barCode": "564329854",
        "priceHT": 300,
        "priceTVA": 60,
        "priceTTC": 360,
        "priceTotalHT": 4500,
        "priceTotalTVA": 900,
        "priceTotalTTC": 5400,
        "stock": 15,
        "createdAt": "2025-03-18T14:55:22.751Z",
        "updatedAt": "2025-03-18T14:55:22.751Z",
        "product": {
          "id": 3,
          "barCode": "564329854",
          "name": "haricot",
          "priceHT": 300,
          "priceTTC": 360,
          "priceTVA": 60,
          "stock": 35,
          "idShop": 2
        }
      }
    ],
    "OrderShops": [
      {
        "orderId": 1,
        "shopId": 1,
        "shopcountry": "FRANCE",
        "shopcity": "Nancy",
        "shoppostalCode": 54000,
        "shopstreet": "82 rue des fleurs",
        "priceHT": 16000,
        "priceTVA": 3200,
        "priceTTC": 19200,
        "createdAt": "2025-03-18T14:55:22.751Z",
        "updatedAt": "2025-03-18T14:55:22.751Z",
        "status": "PENDING",
        "shop": {
          "id": 1,
          "idPaypal": "xxxxx",
          "name": "boucher robert",
          "phoneNumber": "+33656565656",
          "email": "boucher.robert@example.com",
          "idAddress": 1,
          "idUser": 1
        }
      },
      {
        "orderId": 1,
        "shopId": 2,
        "shopcountry": "FRANCE",
        "shopcity": "Nancy",
        "shoppostalCode": 54000,
        "shopstreet": "a 3 rue de la gare",
        "priceHT": 4500,
        "priceTVA": 900,
        "priceTTC": 5400,
        "createdAt": "2025-03-18T14:55:22.751Z",
        "updatedAt": "2025-03-18T14:55:22.751Z",
        "status": "PENDING",
        "shop": {
          "id": 2,
          "idPaypal": "xxxxx",
          "name": "supermarché",
          "phoneNumber": "+33612345678",
          "email": "supermarcher@example.com",
          "idAddress": 2,
          "idUser": 1
        }
      }
    ]
  };

  Future<void> _generateAndShowPdf() async {
    setState(() => _isGenerating = true);
    try {
      final pdfFile = await generateInvoicePDF(orderData);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(pdfPath: pdfFile.path),
        ),
      );
      print('PDF generated at: ${pdfFile.path}');
    } catch (e) {
      print('Error generating PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: $e')),
      );
    }
    setState(() => _isGenerating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Generator'),
      ),
      body: Center(
        child: _isGenerating
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _generateAndShowPdf,
                child: Text('Generate and View PDF'),
              ),
      ),
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String pdfPath;

  const PDFViewerScreen({required this.pdfPath});

  Future<void> _downloadPdf(BuildContext context) async {
    try {
      await Share.shareXFiles([XFile(pdfPath)], text: 'Invoice #${pdfPath.split('/').last}');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading PDF: $e')),
      );
    }
  }

  Future<void> _openPdf() async {
    final result = await OpenFile.open(pdfPath);
    if (result.type != ResultType.done) {
      print('Error opening PDF: ${result.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Viewer'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => _downloadPdf(context),
            tooltip: 'Download PDF',
          ),
          IconButton(
            icon: Icon(Icons.open_in_new),
            onPressed: _openPdf,
            tooltip: 'Open with default viewer',
          ),
        ],
      ),
      body: PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading PDF: $error')),
          );
        },
        onPageError: (page, error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error on page $page: $error')),
          );
        },
      ),
    );
  }
}