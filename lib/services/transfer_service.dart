import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../models/isp.dart';
import '../models/transaction.dart';

class TransferService {
  final ApiClient apiClient;

  TransferService(this.apiClient);

  Future<TransferValidation> validateRecipient(String phoneNumber) async {
    try {
      final response = await apiClient.validateRecipient(phoneNumber);
      final data = response.data['data'];
      return TransferValidation.fromJson(data);
    } catch (e) {
      debugPrint('Error validating recipient: $e');
      rethrow;
    }
  }

  Future<Transaction> sendMoney(String senderNetwork, String recipientPhone, double amount) async {
    try {
      final response = await apiClient.sendMoney(senderNetwork, recipientPhone, amount);
      final data = response.data['data'];
      return Transaction.fromJson(data);
    } catch (e) {
      debugPrint('Error sending money: $e');
      rethrow;
    }
  }
}
