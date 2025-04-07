class Address {
  String? id;
  String? street;
  String? city;
  String? state;
  String? zip;

  Address({
    this.id,
    this.street,
    this.city,
    this.state,
    this.zip,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      street: json['street'],
      city: json['city'],
      state: json['country'],
      zip: json['postalCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'street': street,
      'city': city,
      'country': state,
      'postalCode': zip,
    };
  }
}
