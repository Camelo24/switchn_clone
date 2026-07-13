import 'package:flutter/material.dart';
import '../services/bundle_service.dart';
import '../models/isp.dart';
import '../models/bundle.dart';
import '../api/api_client.dart';

class BundleScreen extends StatefulWidget {
  const BundleScreen({super.key});

  @override
  State<BundleScreen> createState() => _BundleScreenState();
}

class _BundleScreenState extends State<BundleScreen> {
  final ApiClient _apiClient = ApiClient();
  late BundleService _bundleService;
  
  final TextEditingController _phoneController = TextEditingController();
  
  List<ISP> _isps = [];
  List<Bundle> _bundles = [];
  ISP? _selectedISP;
  Bundle? _selectedBundle;
  bool _isLoading = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _bundleService = BundleService(_apiClient);
    _loadISPs();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadISPs() async {
    setState(() => _isLoading = true);
    try {
      final isps = await _bundleService.getISPs();
      setState(() {
        _isps = isps;
        if (isps.isNotEmpty) {
          _selectedISP = isps.first;
          _loadBundles(isps.first.id);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading ISPs: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadBundles(int ispId) async {
    setState(() => _isLoading = true);
    try {
      final bundles = await _bundleService.getBundles(ispId);
      setState(() {
        _bundles = bundles;
        _selectedBundle = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading bundles: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _buyBundle() async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter phone number')),
      );
      return;
    }

    if (_selectedBundle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a bundle')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      await _bundleService.buyBundle(
        _selectedBundle!.id,
        phone,
      );
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('Bundle purchased successfully! ${_selectedBundle!.name}'),
            ],
          ),
          backgroundColor: const Color(0xFF2ECC71),
        ),
      );
      
      _phoneController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error purchasing bundle: $e')),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Data Bundle'),
        backgroundColor: const Color(0xFF00BFE4),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Network',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (_isps.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No networks available'),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _isps.map((isp) {
                        final isSelected = _selectedISP?.id == isp.id;
                        return InkWell(
                          onTap: () {
                            setState(() => _selectedISP = isp);
                            _loadBundles(isp.id);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF00BFE4) : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF00BFE4)
                                    : Colors.grey[300]!,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isp.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 24),
                  if (_bundles.isNotEmpty) ...[
                    const Text(
                      'Select Bundle',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ..._bundles.map((bundle) {
                      final isSelected = _selectedBundle?.id == bundle.id;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFF00BFE4)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: InkWell(
                          onTap: () => setState(() => _selectedBundle = bundle),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bundle.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${bundle.volume} - ${bundle.validityDays ?? 30} days',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${bundle.price.toStringAsFixed(0)} XAF',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xFF00BFE4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                  ],
                  const Text(
                    'Phone Number',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'e.g. 677777777',
                      prefixIcon: const Icon(Icons.phone),
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
                      onPressed: _isProcessing ? null : _buyBundle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BFE4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isProcessing
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'PURCHASE BUNDLE',
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
}
