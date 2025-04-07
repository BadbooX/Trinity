class OrderProduct {
  final int productId;
  final String name;
  final int priceHT;
  final int priceTVA;
  final int priceTTC;
  final int quantity;

  OrderProduct ({
    required this.productId,
    required this.name,
    required this.priceHT,
    required this.priceTVA,
    required this.priceTTC,
    required this.quantity,
  });

  factory OrderProduct.fromJson(Map<String, dynamic>json){
    return OrderProduct(
      productId: json['productId'],
      name: json['name'] ?? 'Unknown product',
      priceHT: json['priceHT'] ?? 0,
      priceTVA: json['priceTVA'] ?? 0,
      priceTTC: json['priceTTC'] ?? 0,
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'productId':productId,
      'name':name,
      'priceHT':priceHT,
      'priceTVA':priceTVA,
      'priceTTC':priceTTC,
      'quantity':quantity,
    };
  }
}