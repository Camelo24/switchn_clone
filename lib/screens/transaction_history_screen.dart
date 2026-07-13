import 'package:flutter/material.dart';
import '../services/wallet_service.dart';
import '../models/transaction.dart';
import '../api/api_client.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final ApiClient _apiClient = ApiClient();
  late WalletService _walletService;
  
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  int _currentPage = 0;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _walletService = WalletService(_apiClient);
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    try {
      final transactions = await _walletService.getWalletHistory(
        page: _currentPage,
        size: _pageSize,
      );
      setState(() {
        _transactions = transactions;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading transactions: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: const Color(0xFF00BFE4),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _transactions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No transactions yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadTransactions,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _transactions[index];
                      return _buildTransactionCard(transaction);
                    },
                  ),
                ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    IconData icon;
    Color iconColor;
    String typeLabel;

    switch (transaction.type.toUpperCase()) {
      case 'AIRTIME':
        icon = Icons.phone_android;
        iconColor = const Color(0xFF00BFE4);
        typeLabel = 'Airtime';
        break;
      case 'DATA':
        icon = Icons.data_usage;
        iconColor = const Color(0xFF9B59B6);
        typeLabel = 'Data Bundle';
        break;
      case 'TRANSFER':
        icon = Icons.send;
        iconColor = const Color(0xFFE67E22);
        typeLabel = 'Transfer';
        break;
      case 'FUND':
        icon = Icons.account_balance_wallet;
        iconColor = const Color(0xFF2ECC71);
        typeLabel = 'Wallet Funding';
        break;
      default:
        icon = Icons.receipt;
        iconColor = Colors.grey;
        typeLabel = transaction.type;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    typeLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (transaction.description != null)
                    Text(
                      transaction.description!,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (transaction.createdAt != null)
                    Text(
                      _formatDate(transaction.createdAt!),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  transaction.type.toUpperCase() == 'FUND'
                      ? '+${transaction.amount.toStringAsFixed(0)} XAF'
                      : '-${transaction.amount.toStringAsFixed(0)} XAF',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: transaction.type.toUpperCase() == 'FUND'
                        ? const Color(0xFF2ECC71)
                        : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: transaction.status == 'COMPLETED'
                        ? Colors.green[50]
                        : Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    transaction.status,
                    style: TextStyle(
                      color: transaction.status == 'COMPLETED'
                          ? Colors.green[800]
                          : Colors.orange[800],
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
