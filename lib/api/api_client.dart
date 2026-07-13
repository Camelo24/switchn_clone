import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  late Dio dio;
  static const String baseUrl = 'http://localhost:8081/api';

  ApiClient() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
    ));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('REQUEST: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('ERROR: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }

  // Auth Endpoints
  Future<Response> verifyFirebaseToken(String token) async {
    try {
      return await dio.post('/auth/verify', data: {'firebaseToken': token});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> getProfile() async {
    try {
      return await dio.get('/auth/profile');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Wallet Endpoints
  Future<Response> getWallet() async {
    try {
      return await dio.get('/wallet');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> fundWallet(double amount) async {
    try {
      return await dio.post('/wallet/fund', data: {'amount': amount});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> getWalletHistory({int page = 0, int size = 10}) async {
    try {
      return await dio.get('/wallet/history', queryParameters: {'page': page, 'size': size});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Purchase Endpoints
  Future<Response> buyAirtime(String network, String phoneNumber, double amount) async {
    try {
      return await dio.post('/purchases/airtime', data: {
        'network': network,
        'phoneNumber': phoneNumber,
        'amount': amount,
      });
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> buyBundle(int bundleId, String beneficiaryPhone) async {
    try {
      return await dio.post('/purchases/bundle', data: {
        'bundleId': bundleId,
        'beneficiaryPhone': beneficiaryPhone,
      });
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Transfer Endpoints
  Future<Response> validateRecipient(String phoneNumber) async {
    try {
      return await dio.get('/transfer/validate/$phoneNumber');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> sendMoney(String senderNetwork, String recipientPhone, double amount) async {
    try {
      return await dio.post('/transfer/send', data: {
        'senderNetwork': senderNetwork,
        'recipientPhone': recipientPhone,
        'amount': amount,
      });
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ISP Endpoints
  Future<Response> getISPs() async {
    try {
      return await dio.get('/isps');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> getBundles(int ispId) async {
    try {
      return await dio.get('/isps/$ispId/bundles');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Transaction Endpoints
  Future<Response> getTransactions({int page = 0, int size = 10}) async {
    try {
      return await dio.get('/transactions', queryParameters: {'page': page, 'size': size});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout. Check your internet and try again.';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return 'Server timeout. Try again.';
    } else if (error.response != null) {
      return error.response?.data['message'] ?? 'An error occurred';
    } else {
      return error.message ?? 'An unknown error occurred';
    }
  }
}
