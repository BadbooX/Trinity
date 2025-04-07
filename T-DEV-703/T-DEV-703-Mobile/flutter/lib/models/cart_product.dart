class CartProduct {
  final int id;
  final String name;
  int quantity;
  final double price;
  final String imgUri;

  CartProduct({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imgUri,
  });

  // Add this method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'imgUri': imgUri,
    };
  }

  // Make sure your fromJson method correctly parses the JSON
  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
      imgUri: json['imgUri'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartProduct && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
