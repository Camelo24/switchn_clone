import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../models/wallet.dart';
import '../models/transaction.dart';

class WalletProvider extends ChangeNotifier {
  final ApiClient apiClient;

  Wallet? _wallet;
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _error;

  Wallet? get wallet => _wallet;
  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  WalletProvider(this.apiClient);

  Future<void> fetchWallet() async {
    _setLoading(true);
    _error = null;

    try {
      final response = await apiClient.getWallet();
      final data = response.data['data'];
      _wallet = Wallet.fromJson(data);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fundWallet(double amount) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await apiClient.fundWallet(amount);
      final data = response.data['data'];
      _wallet = Wallet.fromJson(data);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchTransactionHistory({int page = 0, int size = 10}) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await apiClient.getWalletHistory(page: page, size: size);
      final data = response.data['data'];
      
      if (data is List) {
        _transactions = List<Transaction>.from(
          data.map((t) => Transaction.fromJson(t)),
        );
      } else if (data is Map && data.containsKey('content')) {
        _transactions = List<Transaction>.from(
          (data['content'] as List).map((t) => Transaction.fromJson(t)),
        );
      }
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
