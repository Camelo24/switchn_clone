import 'package:flutter/material.dart';
import 'package:switchn/services/auth_service.dart';
import 'otp_screen.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendOtp() async {
    final rawPhoneNumber = _phoneController.text.trim();
    if (rawPhoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a phone number')),
      );
      return;
    }

    String formattedPhoneNumber;

    if (rawPhoneNumber.startsWith('+')) {
      // Keep '+' and strip all other non-digits
      final digits = rawPhoneNumber.substring(1).replaceAll(RegExp(r'\D'), '');
      formattedPhoneNumber = '+$digits';
    } else if (rawPhoneNumber.startsWith('00')) {
      // Convert '00' to '+' and strip all other non-digits
      final digits = rawPhoneNumber.substring(2).replaceAll(RegExp(r'\D'), '');
      formattedPhoneNumber = '+$digits';
    } else {
      // Default to Cameroon prefix (+237)
      String digits = rawPhoneNumber.replaceAll(RegExp(r'\D'), '');
      if (digits.startsWith('237') && digits.length > 9) {
        digits = digits.substring(3);
      }
      
      if (digits.length != 9) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid 9-digit Cameroon number, or use international format starting with +'),
          ),
        );
        return;
      }
      formattedPhoneNumber = '+237$digits';
    }

    debugPrint('[OTP Auth] Raw input: $rawPhoneNumber -> Formatted E.164: $formattedPhoneNumber');

    setState(() => _isLoading = true);

    try {
      await AuthService().sendOtp(
        phoneNumber: formattedPhoneNumber,
        onCodeSent: (verificationId) {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OtpScreen(
                phoneNumber: formattedPhoneNumber,
                verificationId: verificationId,
              ),
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('[OTP Auth] Error sending OTP: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send OTP: $e'),
          duration: const Duration(seconds: 8),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Enter your phone number',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                hintText: '+237 6XX XXX XXX',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 30),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _sendOtp,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Send OTP'),
              ),
          ],
        ),
      ),
    );
  }
}