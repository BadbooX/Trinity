import 'dart:convert';

import 'package:bite/models/product.dart';
import 'package:bite/services/http_service.dart';
import 'package:bite/services/jwt_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class ProductService {
  final HttpClientApi _httpClient = getIt<HttpClientApi>();
  final JwtService _jwtService = getIt<JwtService>();

  ProductService();

  Future<List<Product>> getProducts() async {
    if (_jwtService.token == null) {
      return Future.error('No token found');
    }
    List<Product> products = [];
    List<String> barCodesList = [];

    var response = await _httpClient.get(Uri.parse('/api/products'),
        headers: {'Authorization': 'Bearer ${_jwtService.token}'});

    if (response.statusCode == 200) {
      var decodedProduct = json.decode(response.body);
      // Safely collect barcodes
      for (var product in decodedProduct) {
        if (product['barCode'] != null) {
          barCodesList.add(product['barCode']);
        }
      }

      // Join the list with commas
      String barCodes = barCodesList.join(',');

      if (barCodes.isNotEmpty) {
        var openfoodfacts = await _getProductsFromOpenFoodFacts(barCodes);

        // Fix case sensitivity issue - 'barCode' in API response vs 'barcode' in your comparison
        for (var product in decodedProduct) {
          for (var openfoodfact in openfoodfacts) {
            if (product['barCode'] == openfoodfact['code']) {
              products.add(Product(
                  id: product['id'],
                  name: product['name'],
                  ingredients: openfoodfact['ingredients_text_en'] ??
                      openfoodfact['ingredients_text'] ??
                      'No ingredients',
                  barcode:
                      product['barCode'], // Changed from 'barcode' to 'barCode'
                  price: product['priceTTC'] / 100,
                  quantity: product['stock'],
                  image: openfoodfact['image_url'],
                  nutriscore: openfoodfact['nutriscore_grade'],
                  novaGroup: openfoodfact['nova_group'],
                  nutrientLevels: openfoodfact['nutrient_levels'],
                  shopName: product['Shop']['name']));
            }
          }
        }
      }

      return products;
    } else {
      return Future.error('Failed to fetch products');
    }
  }

  Future<dynamic> _getProductsFromOpenFoodFacts(String barCodes) async {
    var response = await _httpClient.get(Uri.parse(
        'https://world.openfoodfacts.org/api/v2/search?code=$barCodes&fields=code,ingredients_text_en,image_url,nutriscore_grade,nova_group,nutrient_levels'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['products'];
    } else {
      print(response.body);
      return Future.error('Failed to fetch products');
    }
  }

  Future<dynamic> _getProductFromOpenFoodFacts(String barCode) async {
    var response = await _httpClient.get(Uri.parse(
        'https://world.openfoodfacts.org/api/v2/product/$barCode?fields=code,ingredients_text_en,image_url,nutriscore_grade,nova_group,nutrient_levels'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['product'];
    } else {
      return Future.error('Failed to fetch product');
    }
  }

  Future<Product?> getProductById(String id) async {
    var response = await _httpClient.get(Uri.parse('/api/products/$id'),
        headers: {'Authorization': 'Bearer ${_jwtService.token}'});
    if (response.statusCode == 200) {
      var openfoodfact = await _getProductFromOpenFoodFacts(
          json.decode(response.body)['barCode']);
      print(openfoodfact);
      print(json.decode(response.body));
      return Product(
          id: json.decode(response.body)['id'],
          name: json.decode(response.body)['name'],
          ingredients: openfoodfact['ingredients_text_en'] ??
              openfoodfact['ingredients_text'],
          barcode: json.decode(response.body)['barCode'],
          price: json.decode(response.body)['priceTTC'] / 100,
          quantity: json.decode(response.body)['stock'],
          image: openfoodfact['image_url'],
          nutriscore: openfoodfact['nutriscore_grade'],
          novaGroup: openfoodfact['nova_group'],
          nutrientLevels: openfoodfact['nutrient_levels'],
          shopName: json.decode(response.body)['Shop']['name'] ??
              "No shop mentioned");
    } else {
      return Future.error('Failed to fetch product');
    }
  }

  Future<List<Product>> getProductByBarcode(String barcode) async {
    if (_jwtService.token == null) {
      return Future.error('No token found');
    }
    List<Product> products = [];
    List<String> barCodesList = [];

    var response = await _httpClient.get(Uri.parse('/api/product/$barcode'),
        headers: {'Authorization': 'Bearer ${_jwtService.token}'});

    if (response.statusCode == 200) {
      var decodedProduct = json.decode(response.body);
      // Safely collect barcodes
      for (var product in decodedProduct) {
        if (product['barCode'] != null) {
          barCodesList.add(product['barCode']);
        }
      }

      // Join the list with commas
      String barCodes = barCodesList.join(',');

      if (barCodes.isNotEmpty) {
        var openfoodfacts = await _getProductsFromOpenFoodFacts(barCodes);

        // Fix case sensitivity issue - 'barCode' in API response vs 'barcode' in your comparison
        for (var product in decodedProduct) {
          for (var openfoodfact in openfoodfacts) {
            if (product['barCode'] == openfoodfact['code']) {
              products.add(Product(
                  id: product['id'],
                  name: product['name'],
                  ingredients: openfoodfact['ingredients_text_en'] ??
                      openfoodfact['ingredients_text'] ??
                      'No ingredients',
                  barcode:
                      product['barCode'], // Changed from 'barcode' to 'barCode'
                  price: product['priceTTC'] / 100,
                  quantity: product['stock'],
                  image: openfoodfact['image_url'],
                  nutriscore: openfoodfact['nutriscore_grade'],
                  novaGroup: openfoodfact['nova_group'],
                  nutrientLevels: openfoodfact['nutrient_levels'],
                  shopName: product['Shop']['name']));
            }
          }
        }
      }
      return products;
    } else {
      return Future.error('Failed to fetch products');
    }
  }
}
