class Product {
  final dynamic id;
  final String name;
  final String barcode;
  final double price;
  final String? image;
  final String shopName;
  final int? quantity;
  final String? nutriscore;
  final String? ingredients;
  final int? novaGroup;
  final dynamic nutrientLevels;

  Product(
      {required this.name,
      required this.barcode,
      required this.price,
      required this.shopName,
      required this.id,
      this.quantity,
      this.nutrientLevels,
      this.novaGroup,
      this.ingredients,
      this.nutriscore,
      this.image});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        name: json['name'],
        ingredients: json['ingredients_text_en'] ?? json['ingredients_text'],
        barcode: json['barcode'],
        price: json['priceTTC'],
        quantity: json['stock'],
        image: json['image_url'],
        nutriscore: json['nutriscore_grade'],
        novaGroup: json['nova_group'],
        nutrientLevels: json['nutrient_levels'],
        shopName: json['Shop']['name']);
  }
}
