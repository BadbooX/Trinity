import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import '../models/order.dart';
import 'package:get_it/get_it.dart';
import 'http_service.dart';

class OrderService {
  List<Order> orders = [];
  final HttpClientApi _httpClient = GetIt.instance<HttpClientApi>();
  final baseUrl = '/api/orders'; // the basic url for the api

  // Retrieive all orders for the user connected
  Future<List<Order>> fetchMyOrders() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/my')
      );

      if(response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Error retrieving my orders (${response.statusCode})');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Network error: $e');
      }
      return [];
    }
  }

  // Retrieive an order by ID
  Future<Order?> fetchOrderById(int orderId) async {
    try {
      final response = await _httpClient.get(
        Uri.parse(baseUrl)
      );
      if(response.statusCode == 200) {
        return Order.fromJson(jsonDecode(response.body));

      } else {
        if(kDebugMode){
          print('Order not found (${response.statusCode})');
        }
        return null;
      }
    } catch (e) {
      if(kDebugMode){
        print('Error while retrieving order : $e ');
      }
      return null;
    }
  }

  // Create a new command
  Future<Order?> createOrder(Order newOrder) async {
    try {
      final response = await _httpClient.post(
        Uri.parse(baseUrl),
        body: jsonEncode(newOrder.toJson()),
      );
      if(response.statusCode == 201){
        return Order.fromJson(jsonDecode(response.body));
      }else {
        if(kDebugMode) {
          print('Error while creating order : (${response.statusCode})');
        }
        return null;
      }
    } catch (e) {
      if(kDebugMode){
        print('Error while creating order : $e ');
      }
      return null;
    }
  }
  
  // Delete order
  Future<bool> deleteOrder(int orderId) async {
    try {
      final response = await _httpClient.delete(
        Uri.parse('$baseUrl/$orderId/delete')
      );
      if(response.statusCode == 200){
        if(kDebugMode){
          print('Order deleted succefully : $orderId ');
        }
        return true;
      } else {
        if(kDebugMode){
          print('Error while deleting order : ${response.statusCode}');
        }
        return false;
      }
    } catch (e) {
      if(kDebugMode){
        print('Error while deleting order : $e');
      }
      return false;
    }
  }
}