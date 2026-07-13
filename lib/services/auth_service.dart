import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:rxdart/rxdart.dart';

/// User profile model
class SwitchnUser {
  final String uid;
  final String? email;
  final String? phoneNumber;
  final bool isAnonymous;

  SwitchnUser({
    required this.uid,
    this.email,
    this.phoneNumber,
    this.isAnonymous = false,
  });
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  firebase_auth.FirebaseAuth? get _auth {
    if (isDemoMode) return null;
    try {
      return firebase_auth.FirebaseAuth.instance;
    } catch (e) {
      debugPrint("Failed to get FirebaseAuth instance: $e");
      return null;
    }
  }

  bool get isFirebaseAvailable {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  bool get isDemoMode => !isFirebaseAvailable;

  final BehaviorSubject<SwitchnUser?> _authStateController = BehaviorSubject<SwitchnUser?>();
  Stream<SwitchnUser?> get authStateChanges => _authStateController.stream;

  SwitchnUser? _currentUser;
  SwitchnUser? get currentUser => _currentUser;

  void initialize() {
    if (!isDemoMode && _auth != null) {
      _auth!.authStateChanges().listen((firebase_auth.User? firebaseUser) {
        if (firebaseUser != null) {
          _currentUser = SwitchnUser(
            uid: firebaseUser.uid,
            email: firebaseUser.email,
            phoneNumber: firebaseUser.phoneNumber,
            isAnonymous: firebaseUser.isAnonymous,
          );
        } else {
          _currentUser = null;
        }
        _authStateController.add(_currentUser);
      });
    } else {
      _currentUser = null;
      _authStateController.add(null);
    }
  }

  // Email/Password
  Future<SwitchnUser> signUpWithEmail({required String email, required String password}) async {
    if (isDemoMode) {
      await Future.delayed(const Duration(seconds: 1));
      _currentUser = SwitchnUser(uid: 'demo_user_${DateTime.now().millisecondsSinceEpoch}', email: email);
      _authStateController.add(_currentUser);
      return _currentUser!;
    } else {
      final credential = await _auth!.createUserWithEmailAndPassword(email: email, password: password);
      try {
        await credential.user!.sendEmailVerification();
      } catch (e) {
        debugPrint("Failed to send verification email: $e");
      }
      _currentUser = SwitchnUser(uid: credential.user!.uid, email: credential.user!.email);
      _authStateController.add(_currentUser);
      return _currentUser!;
    }
  }

  Future<SwitchnUser> loginWithEmail({required String email, required String password}) async {
    if (isDemoMode) {
      await Future.delayed(const Duration(seconds: 1));
      _currentUser = SwitchnUser(uid: 'demo_user_12345', email: email, phoneNumber: '+237677777777');
      _authStateController.add(_currentUser);
      return _currentUser!;
    } else {
      final credential = await _auth!.signInWithEmailAndPassword(email: email, password: password);
      _currentUser = SwitchnUser(uid: credential.user!.uid, email: credential.user!.email);
      _authStateController.add(_currentUser);
      return _currentUser!;
    }
  }

  // 🔹 Phone Authentication – NEW methods
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
  }) async {
    if (isDemoMode) {
      await Future.delayed(const Duration(seconds: 1));
      onCodeSent('demo_verification_id_${DateTime.now().millisecondsSinceEpoch}');
      return;
    }

    if (_auth == null) throw Exception('Firebase Auth not available');

    await _auth!.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (firebase_auth.PhoneAuthCredential credential) async {
        await _auth!.signInWithCredential(credential);
      },
      verificationFailed: (firebase_auth.FirebaseAuthException e) {
        throw Exception('Verification failed: ${e.message}');
      },
      codeSent: (verificationId, forceResendingToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  Future<SwitchnUser> verifyOtpAndLogin({
    required String verificationId,
    required String otpCode,
  }) async {
    if (isDemoMode) {
      await Future.delayed(const Duration(seconds: 1));
      _currentUser = SwitchnUser(
        uid: 'demo_phone_user_${DateTime.now().millisecondsSinceEpoch}',
        phoneNumber: 'demo_phone',
      );
      _authStateController.add(_currentUser);
      return _currentUser!;
    }

    if (_auth == null) throw Exception('Firebase Auth not available');

    final credential = firebase_auth.PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpCode,
    );

    final userCredential = await _auth!.signInWithCredential(credential);
    final firebaseUser = userCredential.user!;
    _currentUser = SwitchnUser(
      uid: firebaseUser.uid,
      phoneNumber: firebaseUser.phoneNumber,
    );
    _authStateController.add(_currentUser);
    return _currentUser!;
  }

  // Other helpers
  Future<SwitchnUser> loginWithPhoneSimulated(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 2));
    _currentUser = SwitchnUser(
      uid: 'demo_phone_user_${DateTime.now().millisecondsSinceEpoch}',
      phoneNumber: phoneNumber,
    );
    _authStateController.add(_currentUser);
    return _currentUser!;
  }

  void updatePhoneNumber(String phoneNumber) {
    if (_currentUser != null) {
      _currentUser = SwitchnUser(
        uid: _currentUser!.uid,
        email: _currentUser!.email,
        phoneNumber: phoneNumber,
        isAnonymous: _currentUser!.isAnonymous,
      );
      _authStateController.add(_currentUser);
    }
  }

  Future<void> resetPassword(String email) async {
    if (isDemoMode) {
      await Future.delayed(const Duration(seconds: 1));
      debugPrint("Demo Mode: Password reset link simulation sent to $email");
    } else {
      if (_auth != null) {
        await _auth!.sendPasswordResetEmail(email: email);
      } else {
        throw Exception("Firebase Auth service is unavailable.");
      }
    }
  }

  Future<void> signOut() async {
    if (isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));
    } else {
      await _auth!.signOut();
    }
    _currentUser = null;
    _authStateController.add(null);
  }
}