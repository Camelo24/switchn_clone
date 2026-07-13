class Transaction {
  final int id;
  final String type; // AIRTIME, DATA, CALL, TRANSFER, FUND
  final double amount;
  final String status;
  final String? description;
  final DateTime? createdAt;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    this.description,
    this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      status: json['status'] ?? '',
      description: json['description'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'status': status,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
