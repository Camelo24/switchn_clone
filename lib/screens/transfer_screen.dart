import 'package:flutter/material.dart';
import '../services/transfer_service.dart';
import '../models/isp.dart';
import '../api/api_client.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final ApiClient _apiClient = ApiClient();
  late TransferService _transferService;
  
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  
  String _selectedNetwork = 'MTN';
  TransferValidation? _validationResult;
  bool _isValidating = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _transferService = TransferService(_apiClient);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _validateRecipient() async {
    final phone = _phoneController.text.trim();
    
    if (phone.isEmpty) {
      setState(() => _validationResult = null);
      return;
    }

    setState(() => _isValidating = true);

    try {
      final result = await _transferService.validateRecipient(phone);
      setState(() {
        _validationResult = result;
        _selectedNetwork = result.network;
      });
    } catch (e) {
      setState(() => _validationResult = null);
    } finally {
      setState(() => _isValidating = false);
    }
  }

  Future<void> _sendMoney() async {
    final phone = _phoneController.text.trim();
    final amountStr = _amountController.text.trim();

    if (phone.isEmpty || amountStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter phone number and amount')),
      );
      return;
    }

    if (_validationResult == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please validate recipient first')),
      );
      return;
    }

    final amount = double.tryParse(amountStr);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      await _transferService.sendMoney(
        _selectedNetwork,
        phone,
        amount,
      );
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('Successfully transferred ${amount.toStringAsFixed(0)} XAF!'),
            ],
          ),
          backgroundColor: const Color(0xFF2ECC71),
        ),
      );
      
      _phoneController.clear();
      _amountController.clear();
      setState(() => _validationResult = null);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending money: $e')),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Money'),
        backgroundColor: const Color(0xFF00BFE4),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Your Network',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildNetworkButton('MTN', _selectedNetwork == 'MTN'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNetworkButton('ORANGE', _selectedNetwork == 'ORANGE'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Recipient Phone Number',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                if (value.length >= 9) {
                  _validateRecipient();
                }
              },
              decoration: InputDecoration(
                hintText: 'e.g. 677777777',
                prefixIcon: const Icon(Icons.phone),
                suffixIcon: _isValidating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : _validationResult != null
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            if (_validationResult != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[300]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _validationResult!.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${_validationResult!.network} - ${_validationResult!.phone}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'Amount (XAF)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Minimum 100 XAF',
                prefixIcon: const Icon(Icons.payments),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _sendMoney,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BFE4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'SEND MONEY',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkButton(String network, bool isSelected) {
    final color = network == 'MTN' ? const Color(0xFFF1C40F) : const Color(0xFFE67E22);
    final textColor = network == 'MTN' ? Colors.black : Colors.white;

    return InkWell(
      onTap: () => setState(() => _selectedNetwork = network),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            network,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? textColor : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }
}
