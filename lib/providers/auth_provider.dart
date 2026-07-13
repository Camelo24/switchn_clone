import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../api/api_client.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiClient apiClient;
  final AuthService authService;
  late firebase_auth.FirebaseAuth firebaseAuth;

  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _token != null && _user != null;

  AuthProvider(this.apiClient, this.authService) {
    firebaseAuth = firebase_auth.FirebaseAuth.instance;
    _initAuthStateListener();
  }

  void _initAuthStateListener() {
    firebaseAuth.authStateChanges().listen((firebase_auth.User? firebaseUser) async {
      if (firebaseUser != null) {
        try {
          final idToken = await firebaseUser.getIdToken();
          if (idToken != null) {
            await _verifyWithBackend(idToken);
          }
        } catch (e) {
          _error = 'Token verification failed: $e';
          notifyListeners();
        }
      } else {
        _token = null;
        _user = null;
        apiClient.clearAuthToken();
        notifyListeners();
      }
    });
  }

  Future<void> loginWithFirebase(String email, String password) async {
    _setLoading(true);
    _error = null;

    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final idToken = await credential.user?.getIdToken();
      if (idToken != null) {
        await _verifyWithBackend(idToken);
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> registerWithFirebase(String email, String password) async {
    _setLoading(true);
    _error = null;

    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final idToken = await credential.user?.getIdToken();
      if (idToken != null) {
        await _verifyWithBackend(idToken);
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loginWithPhone(String phoneNumber, String verificationId, String smsCode) async {
    _setLoading(true);
    _error = null;

    try {
      final credential = firebase_auth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final userCredential = await firebaseAuth.signInWithCredential(credential);
      
      final idToken = await userCredential.user?.getIdToken();
      if (idToken != null) {
        await _verifyWithBackend(idToken);
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _verifyWithBackend(String firebaseToken) async {
    try {
      final response = await apiClient.verifyFirebaseToken(firebaseToken);
      final data = response.data['data'];
      
      _token = data['token'];
      _user = User.fromJson(data['user']);
      
      apiClient.setAuthToken(_token!);
      notifyListeners();
    } catch (e) {
      _error = 'Backend authentication failed: $e';
      rethrow;
    }
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
    await authService.signOut();
    _token = null;
    _user = null;
    apiClient.clearAuthToken();
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
