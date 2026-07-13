import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../models/transaction.dart';
import '../models/isp.dart';

class TransactionProvider extends ChangeNotifier {
  final ApiClient apiClient;

  List<Transaction> _allTransactions = [];
  bool _isLoading = false;
  String? _error;

  List<Transaction> get allTransactions => _allTransactions;
  List<Transaction> get transactions => _allTransactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  TransactionProvider(this.apiClient);

  Future<void> fetchTransactions({int page = 0, int size = 10}) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await apiClient.getTransactions(page: page, size: size);
      final data = response.data['data'];
      
      if (data is List) {
        _allTransactions = List<Transaction>.from(
          data.map((t) => Transaction.fromJson(t)),
        );
      } else if (data is Map && data.containsKey('content')) {
        _allTransactions = List<Transaction>.from(
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

  Future<void> buyAirtime(String network, String phoneNumber, double amount) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await apiClient.buyAirtime(network, phoneNumber, amount);
      final transactionData = response.data['data'];
      
      Transaction transaction = Transaction.fromJson(transactionData);
      _allTransactions.insert(0, transaction);
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> buyBundle(int bundleId, String beneficiaryPhone) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await apiClient.buyBundle(bundleId, beneficiaryPhone);
      final transactionData = response.data['data'];
      
      Transaction transaction = Transaction.fromJson(transactionData);
      _allTransactions.insert(0, transaction);
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<TransferValidation> validateRecipient(String phoneNumber) async {
    try {
      final response = await apiClient.validateRecipient(phoneNumber);
      final data = response.data['data'];
      return TransferValidation.fromJson(data);
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> sendMoney(String senderNetwork, String recipientPhone, double amount) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await apiClient.sendMoney(senderNetwork, recipientPhone, amount);
      final transactionData = response.data['data'];
      
      Transaction transaction = Transaction.fromJson(transactionData);
      _allTransactions.insert(0, transaction);
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
