import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:bite/models/order_shop.dart';
import 'package:bite/models/order_product.dart';

class Order {
  final int id;
  final int userId;
  final int priceHT;
  final int priceTVA;
  final int priceTTC;
  final OrderStatus status; // Enum to match with the backend
  late final List<OrderProduct> orderProducts;  // list of products
  late final List<OrderShop> orderShops; // list of shops 
  final DateTime createdAt;
  final DateTime updatedAt; 

  Order({
    required this.id,
    required this.userId,
    required this.priceHT,
    required this.priceTVA,
    required this.priceTTC,
    required this.status,
    required this.orderProducts,
    required this.orderShops,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      priceHT: json['priceHT'] ?? 0,
      priceTVA: json['priceTVA'] ?? 0,
      priceTTC: json['priceTTC'] ?? 0,
      status: OrderStatus.values.byName(json['status']), // json Conversion
      orderProducts: (json['orderProducts'] as List<dynamic>?)?.map((e) => OrderProduct.fromJson(e)).toList() ?? [], // if orderProducts is empty return an empty list
      orderShops: (json['orderShops'] as List<dynamic>?)?.map((e) => OrderShop.fromJson(e)).toList() ?? [], // same here
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt'])
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'userId':userId,
      'priceHT':priceHT,
      'priceTVA':priceTVA,
      'priceTTC':priceTTC,
      'status':status.name, // Permit enum
      'orderProducts':orderProducts.map((e) => e.toJson()).toList(),
      'orderShops':orderShops.map((e) => e.toJson()).toList(),
      'createdAt':createdAt.toIso8601String(),
      'updatedAt':createdAt.toIso8601String(),
    };
  }
}

// Enum for orderStatus
enum OrderStatus {
  PENDING,
  CONFIRMED,
  CANCELED,
  IN_TRANSIT,
  DELIVERED,
  PAID,
  REFUNDED,
}