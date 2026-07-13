import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../models/wallet.dart';
import '../models/transaction.dart';

class WalletService {
  final ApiClient apiClient;

  WalletService(this.apiClient);

  Future<Wallet> getWallet() async {
    try {
      final response = await apiClient.getWallet();
      final data = response.data['data'];
      return Wallet.fromJson(data);
    } catch (e) {
      debugPrint('Error fetching wallet: $e');
      rethrow;
    }
  }

  Future<Wallet> fundWallet(double amount) async {
    try {
      final response = await apiClient.fundWallet(amount);
      final data = response.data['data'];
      return Wallet.fromJson(data);
    } catch (e) {
      debugPrint('Error funding wallet: $e');
      rethrow;
    }
  }

  Future<List<Transaction>> getWalletHistory({int page = 0, int size = 10}) async {
    try {
      final response = await apiClient.getWalletHistory(page: page, size: size);
      final data = response.data['data'];
      
      if (data is List) {
        return List<Transaction>.from(
          data.map((t) => Transaction.fromJson(t)),
        );
      } else if (data is Map && data.containsKey('content')) {
        return List<Transaction>.from(
          (data['content'] as List).map((t) => Transaction.fromJson(t)),
        );
      }
      
      return [];
    } catch (e) {
      debugPrint('Error fetching wallet history: $e');
      rethrow;
    }
  }
}
