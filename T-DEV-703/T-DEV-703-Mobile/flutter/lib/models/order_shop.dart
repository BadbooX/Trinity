import 'package:bite/models/order.dart';
import 'package:flutter/material.dart';

class OrderShop {
  final int shopId;
  final String shopName;

  OrderShop ({
    required this.shopId, required this.shopName
  });

  factory OrderShop.fromJson(Map<String, dynamic> json) {
    return OrderShop(
      shopId: json['shopId'],
      shopName: json['shopName']
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'shopId':shopId,
      'shopName':shopName
    };
  }
}