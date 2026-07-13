import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../models/isp.dart';
import '../models/bundle.dart';

class BundleService {
  final ApiClient apiClient;

  BundleService(this.apiClient);

  Future<List<ISP>> getISPs() async {
    try {
      final response = await apiClient.getISPs();
      final data = response.data['data'] as List;
      return List<ISP>.from(data.map((isp) => ISP.fromJson(isp)));
    } catch (e) {
      debugPrint('Error fetching ISPs: $e');
      rethrow;
    }
  }

  Future<List<Bundle>> getBundles(int ispId) async {
    try {
      final response = await apiClient.getBundles(ispId);
      final data = response.data['data'] as List;
      return List<Bundle>.from(data.map((bundle) => Bundle.fromJson(bundle)));
    } catch (e) {
      debugPrint('Error fetching bundles: $e');
      rethrow;
    }
  }

  Future<dynamic> buyAirtime(String network, String phoneNumber, double amount) async {
    try {
      final response = await apiClient.buyAirtime(network, phoneNumber, amount);
      return response.data['data'];
    } catch (e) {
      debugPrint('Error buying airtime: $e');
      rethrow;
    }
  }

  Future<dynamic> buyBundle(int bundleId, String beneficiaryPhone) async {
    try {
      final response = await apiClient.buyBundle(bundleId, beneficiaryPhone);
      return response.data['data'];
    } catch (e) {
      debugPrint('Error buying bundle: $e');
      rethrow;
    }
  }
}
