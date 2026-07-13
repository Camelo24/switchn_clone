class Bundle {
  final int id;
  final String ispName;
  final String name;
  final String type; // DATA, CALL, SMS
  final String volume;
  final double price;
  final int? validityDays;

  Bundle({
    required this.id,
    required this.ispName,
    required this.name,
    required this.type,
    required this.volume,
    required this.price,
    this.validityDays,
  });

  factory Bundle.fromJson(Map<String, dynamic> json) {
    return Bundle(
      id: json['id'] ?? 0,
      ispName: json['ispName'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      volume: json['volume'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      validityDays: json['validityDays'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ispName': ispName,
      'name': name,
      'type': type,
      'volume': volume,
      'price': price,
      'validityDays': validityDays,
    };
  }
}
