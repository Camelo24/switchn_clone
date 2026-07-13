import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'api/api_client.dart';
import 'providers/auth_provider.dart';
import 'providers/wallet_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/bundle_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase init failed: $e");
  }

  AuthService().initialize();

  runApp(const SwitchnApp());
}

class SwitchnApp extends StatelessWidget {
  const SwitchnApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    final authService = AuthService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(apiClient, authService),
        ),
        ChangeNotifierProvider(
          create: (_) => WalletProvider(apiClient),
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionProvider(apiClient),
        ),
        ChangeNotifierProvider(
          create: (_) => BundleProvider(apiClient),
        ),
      ],
      child: MaterialApp(
        title: 'Switchn',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00BFE4)),
          useMaterial3: true,
        ),
        home: const AuthGate(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SwitchnUser?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        if (snapshot.hasData && snapshot.data != null) {
          return const DashboardScreen();
        }

        return const WelcomeScreen();
      },
    );
  }
}