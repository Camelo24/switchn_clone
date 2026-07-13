import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../models/isp.dart';
import '../models/bundle.dart';

class BundleProvider extends ChangeNotifier {
  final ApiClient apiClient;

  List<ISP> _isps = [];
  Map<int, List<Bundle>> _bundlesByISP = {};
  bool _isLoading = false;
  String? _error;

  List<ISP> get isps => _isps;
  bool get isLoading => _isLoading;
  String? get error => _error;

  BundleProvider(this.apiClient);

  Future<void> fetchISPs() async {
    _setLoading(true);
    _error = null;

    try {
      final response = await apiClient.getISPs();
      final data = response.data['data'];
      
      if (data is List) {
        _isps = List<ISP>.from(
          data.map((isp) => ISP.fromJson(isp)),
        );
      }
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Bundle>> fetchBundles(int ispId) async {
    if (_bundlesByISP.containsKey(ispId)) {
      return _bundlesByISP[ispId]!;
    }

    _setLoading(true);
    _error = null;

    try {
      final response = await apiClient.getBundles(ispId);
      final data = response.data['data'];
      
      List<Bundle> bundles = [];
      if (data is List) {
        bundles = List<Bundle>.from(
          data.map((bundle) => Bundle.fromJson(bundle)),
        );
      }
      
      _bundlesByISP[ispId] = bundles;
      notifyListeners();
      return bundles;
    } catch (e) {
      _error = e.toString();
      return [];
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
