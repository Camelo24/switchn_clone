import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import 'dashboard_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String platform;
  final String iconPath;
  final String? phoneNumber;

  const VerificationScreen({
    super.key,
    required this.platform,
    required this.iconPath,
    this.phoneNumber,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final AuthService _authService = AuthService();
  bool _isVerifying = false;
  
  String? _verificationId;

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_authService.isDemoMode) {
        _showDemoHint();
      } else {
        if (widget.platform == 'SMS') {
          _startPhoneAuth();
        } else if (widget.platform == 'Google') {
          _startGoogleAuth();
        } else {
          _startPlaceholderAuth();
        }
      }
    });
  }

  void _showDemoHint() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.info, color: Colors.white),
            SizedBox(width: 8),
            Text('Demo Mode: Enter 123456 to verify!'),
          ],
        ),
        backgroundColor: Colors.amber,
        duration: Duration(seconds: 5),
      ),
    );
  }

  void _startPlaceholderAuth() {
    // Placeholder flow
  }

  Future<void> _startPhoneAuth() async {
    if (widget.phoneNumber == null) return;
    
    setState(() => _isVerifying = true);

    try {
      // Format number
      String digits = widget.phoneNumber!.replaceAll(RegExp(r'\D'), '');
      if (digits.startsWith('237')) {
        digits = digits.substring(3);
      }
      String fullNumber = '+237$digits';

      // We need to access FirebaseAuth.instance (via raw instance as we check config elsewhere)
      final auth = _authService.isFirebaseAvailable ? _authService.loginWithEmail(email: '', password: '') : null; // check availability
      
      // Call Firebase Auth
      // Since verifyPhoneNumber is async, we do it in try block
      // To run standard firebase auth:
      // Note: we can use a direct helper in AuthService, but we can write it here as well:
      // await FirebaseAuth.instance.verifyPhoneNumber(...)
      // But we must check if Firebase is configured!
      if (_authService.isDemoMode) {
        setState(() => _isVerifying = false);
        return;
      }
      
      // Real firebase auth
      // (This will run if firebase is initialized)
      // ...
    } catch (e) {
      _onAuthError('Failed to send SMS: $e');
    }
  }

  Future<void> _startGoogleAuth() async {
    if (_authService.isDemoMode) {
      setState(() => _isVerifying = true);
      await Future.delayed(const Duration(milliseconds: 1500));
      _onAuthSuccess();
      return;
    }
    // Google Auth production implementation
  }

  void _onAuthSuccess() {
    if (mounted) {
      setState(() => _isVerifying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification Successful!')),
      );
      
      // Update phone number inside profile service
      // if (widget.phoneNumber != null) {
      //   _authService.updatePhoneNumber(widget.phoneNumber!);
      // }

      // Navigate to dashboard
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
        (route) => false,
      );
    }
  }

  void _onAuthError(String message) {
    if (mounted) {
      setState(() => _isVerifying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length < 6) {
      _onAuthError('Please enter a 6-digit code');
      return;
    }

    setState(() => _isVerifying = true);

    if (_authService.isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (code == '123456') {
        // Mock successful login
        // await _authService.loginWithPhoneSimulated(widget.phoneNumber ?? '677777777');
        _onAuthSuccess();
      } else {
        _onAuthError('Invalid OTP (hint: use 123456 in Demo Mode)');
      }
    } else {
      // Production SMS verification code check
      // ...
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isOTP = widget.platform == 'WhatsApp' || widget.platform == 'SMS';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                widget.iconPath, 
                width: 64, 
                height: 64,
                errorBuilder: (_, __, ___) => const Icon(Icons.security, size: 64, color: Color(0xFF00BFE4)),
              ),
              const SizedBox(height: 24),
              Text(
                isOTP ? 'Verification Code' : 'Connecting...',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isOTP 
                    ? 'Please enter the 6-digit code sent to your ${widget.platform}'
                    : 'Please wait while we connect your ${widget.platform} account securely.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
              if (isOTP) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 45,
                      height: 55,
                      child: KeyboardListener(
                        focusNode: FocusNode(canRequestFocus: false),
                        onKeyEvent: (event) {
                          if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
                            if (_controllers[index].text.isEmpty && index > 0) {
                              _controllers[index - 1].clear();
                              _focusNodes[index - 1].requestFocus();
                            }
                          }
                        },
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF00BFE4), width: 2),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              _focusNodes[index + 1].requestFocus();
                            }
                            if (index == 5 && value.isNotEmpty) {
                              FocusScope.of(context).unfocus();
                            }
                          },
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isVerifying ? null : _verify,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BFE4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child: _isVerifying
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            'Verify',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 60),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00BFE4)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
