class User {
  final int id;
  final String? email;
  final String? phone;
  final String? fullName;
  final DateTime? createdAt;

  User({
    required this.id,
    this.email,
    this.phone,
    this.fullName,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'],
      phone: json['phone'],
      fullName: json['fullName'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'fullName': fullName,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
