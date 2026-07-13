class ISP {
  final int id;
  final String name;
  final String? displayName;

  ISP({
    required this.id,
    required this.name,
    this.displayName,
  });

  factory ISP.fromJson(Map<String, dynamic> json) {
    return ISP(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      displayName: json['displayName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
    };
  }
}

class TransferValidation {
  final String phone;
  final String network;
  final String name;

  TransferValidation({
    required this.phone,
    required this.network,
    required this.name,
  });

  factory TransferValidation.fromJson(Map<String, dynamic> json) {
    return TransferValidation(
      phone: json['phone'] ?? '',
      network: json['network'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'network': network,
      'name': name,
    };
  }
}
