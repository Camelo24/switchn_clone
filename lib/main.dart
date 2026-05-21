import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase init failed: $e");
  }
  runApp(const SwitchnApp());
}

class SwitchnApp extends StatelessWidget {
  const SwitchnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Switchn',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00BFE4)),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top spacing
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            
            // Welcome content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Welcome title
                  Text(
                    'Welcome to Switchn',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Subtitle
                  Text(
                    'Stress free airtime transfer',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            // Middle spacing
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
            
            // Logo box
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFF00BFE4),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Text(
                  'Switchn',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            // Middle spacing
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
            
            // Bottom content with links and button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Policy text
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                      children: [
                        const TextSpan(text: 'Read our '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: const TextStyle(
                            color: Color(0xFF00BFE4),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Terms text
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                      children: [
                        const TextSpan(text: 'Tap Agree and continue to accept the '),
                        TextSpan(
                          text: 'Terms and conditions',
                          style: const TextStyle(
                            color: Color(0xFF00BFE4),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Agree and Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to phone verification screen
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PhoneVerificationScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BFE4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'AGREE AND CONTINUE',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  late TextEditingController _phoneController;
  Timer? _detectionTimer;
  String? _detectedOperator; // 'mtn' or 'orange'
  bool _isDetecting = false;
  Timer? _validationTimer;
  double _validationProgress = 0.0;
  bool _isValidating = false;
  bool _isValidated = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _detectionTimer?.cancel();
    _validationTimer?.cancel();
    _phoneController.dispose();
    super.dispose();
  }

  void _onPhoneChanged(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    String normalized = digits;
    if (normalized.startsWith('237')) {
      normalized = normalized.substring(3);
    }

    if (normalized.length < 2) {
      _detectionTimer?.cancel();
      setState(() {
        _detectedOperator = null;
        _isDetecting = false;
        _isValidated = false;
      });
      _stopValidation(reset: true);
      return;
    }

    _detectionTimer?.cancel();
    setState(() {
      _isDetecting = true;
      _detectedOperator = null;
      _isValidated = false;
    });

    _detectionTimer = Timer(const Duration(milliseconds: 700), () {
      String? op;
      // Basic prefix detection (examples provided):
      // numbers starting with '65' -> MTN, '69' -> Orange
      if (normalized.startsWith('65') || normalized.startsWith('66') || normalized.startsWith('67')) {
        op = 'mtn';
      } else if (normalized.startsWith('69') || normalized.startsWith('68')) {
        op = 'orange';
      } else {
        if (normalized.startsWith('65')) op = 'mtn';
        if (normalized.startsWith('69')) op = 'orange';
      }

      setState(() {
        _detectedOperator = op;
        _isDetecting = false;
      });
      _stopValidation(reset: true);
    });
  }

  void _startValidation() {
    if (_isValidating || _isValidated) return;
    _validationTimer?.cancel();
    setState(() {
      _isValidating = true;
      _validationProgress = 0.0;
    });

    _validationTimer = Timer.periodic(const Duration(milliseconds: 80), (t) {
      setState(() {
        _validationProgress += 0.06;
        if (_validationProgress >= 1.0) {
          _validationProgress = 1.0;
          _isValidating = false;
          _isValidated = true;
          t.cancel();
        }
      });
    });
  }

  void _stopValidation({bool reset = false}) {
    _validationTimer?.cancel();
    setState(() {
      _isValidating = false;
      if (reset) {
        _validationProgress = 0.0;
        _isValidated = false;
      }
    });
  }

  void _handleNext() {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a phone number'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    // ensure operator detected
    if (_detectedOperator == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to detect operator. Please check the number.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Run a short validation/loading animation then show options
    _validateAndShowOptions();
  }

  Future<void> _validateAndShowOptions() async {
    // Always show the loading animation when Next is pressed.
    _validationTimer?.cancel();
    setState(() {
      _isValidating = true;
      _validationProgress = 0.0;
    });

    final completer = Completer<void>();
    int ticks = 0;
    _validationTimer = Timer.periodic(const Duration(milliseconds: 80), (t) {
      ticks++;
      setState(() {
        _validationProgress = (_validationProgress + 0.12).clamp(0.0, 1.0);
      });
      if (ticks >= 8) {
        // finish
        t.cancel();
        setState(() {
          _validationProgress = 1.0;
          _isValidating = false;
          _isValidated = true;
        });
        completer.complete();
      }
    });

    await completer.future;
    // small delay to let user see full bar
    await Future.delayed(const Duration(milliseconds: 220));
    _showOptionsModal();
  }

  void _showOptionsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          // Move the sheet slightly higher by increasing the initial size.
          initialChildSize: 0.72,
          minChildSize: 0.35,
          maxChildSize: 0.85,
          builder: (_, controller) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 10),
              ],
            ),
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _buildOptionButton(
                    'whatsapp.png',
                    'Continue with WhatsApp',
                    () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VerificationScreen(
                      platform: 'WhatsApp',
                      iconPath: 'whatsapp.png',
                      phoneNumber: _phoneController.text,
                    ),
                  ));
                }),
                const SizedBox(height: 12),
                _buildOptionButton(
                    'message.png',
                    'Continue with SMS',
                    () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VerificationScreen(
                      platform: 'SMS',
                      iconPath: 'message.png',
                      phoneNumber: _phoneController.text,
                    ),
                  ));
                }),
                const SizedBox(height: 12),
                _buildOptionButton(
                    'Google.png',
                    'Continue with Google',
                    () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const VerificationScreen(
                      platform: 'Google',
                      iconPath: 'Google.png',
                    ),
                  ));
                }),
                const SizedBox(height: 12),
                _buildOptionButton(
                    'Apple.png',
                    'Continue with Apple',
                    () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const VerificationScreen(
                      platform: 'Apple',
                      iconPath: 'Apple.png',
                    ),
                  ));
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionButton(String assetPath, String text, VoidCallback onTap) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Image.asset(assetPath, width: 28, height: 28),
              const SizedBox(width: 16),
              Text(
                text,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.black87,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top spacing
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              // Title
              Text(
                'Enter MOMO or OM phone number',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Description text
              Text(
                'Switchn will need to verify your phone number.\nEnsure that the SIM card is in a mobile phone',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              // Phone number label
              Text(
                'Enter primary number',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 12),

              // Phone number input field with operator detection
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                onChanged: _onPhoneChanged,
                decoration: InputDecoration(
                  hintText: 'e.g. 0541234567',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _detectedOperator != null ? const Color(0xFF00BFE4) : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _detectedOperator != null ? const Color(0xFF00BFE4) : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF00BFE4),
                      width: 3,
                    ),
                  ),
                  suffixIcon: _isDetecting
                      ? Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(const Color(0xFF00BFE4)),
                            ),
                          ),
                        )
                      : (_detectedOperator != null
                          ? Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Image.asset(
                                _detectedOperator == 'mtn' ? 'mtn.png' : 'orange.png',
                                width: 36,
                                height: 36,
                                fit: BoxFit.contain,
                              ),
                            )
                          : null),
                ),
              ),

              // Validation progress bar (shown when validating or if validated)
              if (_isValidating || _validationProgress > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: MediaQuery.of(context).size.width * 0.9 * _validationProgress,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00BFE4),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(height: MediaQuery.of(context).size.height * 0.20),

              // Next button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BFE4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    'Next',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Contact us text
              Center(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    children: [
                      const TextSpan(text: 'Having trouble signing? '),
                      TextSpan(
                        text: 'Contact us',
                        style: const TextStyle(
                          color: Color(0xFF00BFE4),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

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
  bool _isVerifying = false;
  
  String? _verificationId;
  FirebaseAuth? _auth;

  @override
  void initState() {
    super.initState();
    try {
      _auth = FirebaseAuth.instance;
    } catch (e) {
      debugPrint('Firebase Auth not initialized: $e');
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.platform == 'SMS') {
        _startPhoneAuth();
      } else if (widget.platform == 'Google') {
        _startGoogleAuth();
      } else {
        // WhatsApp or Apple placeholders
        _startPlaceholderAuth();
      }
    });
  }

  void _startPlaceholderAuth() {
     // Do nothing for now until user enters OTP for whatsapp, or simulate connecting for apple
  }

  Future<void> _startPhoneAuth() async {
    if (widget.phoneNumber == null) return;
    if (_auth == null) {
      _onAuthError('Firebase is not configured yet.');
      return;
    }
    
    // Ensure the number is formatted correctly as +237...
    String digits = widget.phoneNumber!.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('237')) {
      digits = digits.substring(3);
    }
    String fullNumber = '+237$digits';
    
    // Note: verifyPhoneNumber is for mobile. If you run on Web, this might fail silently or throw.
    try {
      await _auth!.verifyPhoneNumber(
      phoneNumber: fullNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await _auth!.signInWithCredential(credential);
          _onAuthSuccess();
        } catch (e) {
          _onAuthError('Auto-verification failed: $e');
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        _onAuthError(e.message ?? 'Verification Failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        if (mounted) {
          setState(() {
            _verificationId = verificationId;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Code sent via SMS')),
          );
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (mounted) {
          setState(() {
            _verificationId = verificationId;
          });
        }
      },
    );
    } catch (e) {
      _onAuthError('Failed to send SMS: $e');
    }
  }

  Future<void> _startGoogleAuth() async {
    if (_auth == null) {
      _onAuthError('Firebase is not configured yet.');
      return;
    }
    setState(() => _isVerifying = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth!.signInWithCredential(credential);
        _onAuthSuccess();
      } else {
        _onAuthError('Google Sign-In aborted');
      }
    } catch (e) {
      _onAuthError('Google Sign-In failed: $e');
    }
  }

  void _onAuthSuccess() {
    if (mounted) {
      setState(() => _isVerifying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification Successful!')),
      );
      // Navigate to home or next screen
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
    if (_verificationId == null && widget.platform == 'SMS') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait for the code to be sent')),
      );
      return;
    }
    if (_auth == null) {
      _onAuthError('Firebase is not configured yet.');
      return;
    }
    
    setState(() {
      _isVerifying = true;
    });
    
    if (widget.platform == 'SMS' || widget.platform == 'WhatsApp') {
      String smsCode = _controllers.map((c) => c.text).join();
      if (smsCode.length < 6) {
         _onAuthError('Please enter a 6-digit code');
         return;
      }
      if (widget.platform == 'SMS') {
        try {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: _verificationId!,
            smsCode: smsCode,
          );
          await _auth!.signInWithCredential(credential);
          _onAuthSuccess();
        } catch (e) {
          _onAuthError('Invalid OTP');
        }
      } else {
        // WhatsApp placeholder
        Future.delayed(const Duration(seconds: 2), () {
          _onAuthSuccess();
        });
      }
    } else {
      // Simulate placeholder
      Future.delayed(const Duration(seconds: 2), () {
        _onAuthSuccess();
      });
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
              Image.asset(widget.iconPath, width: 64, height: 64),
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
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                          } else if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                          if (index == 5 && value.isNotEmpty) {
                            FocusScope.of(context).unfocus();
                          }
                        },
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
