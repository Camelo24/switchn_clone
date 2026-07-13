import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../providers/wallet_provider.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import '../models/wallet.dart';
import 'airtime_screen.dart';
import 'bundle_screen.dart';
import 'transfer_screen.dart';
import 'transaction_history_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    
    await Future.wait([
      walletProvider.fetchWallet(),
      transactionProvider.fetchTransactions(page: 0, size: 10),
    ]);
  }

  void _handleSignOut() async {
    await _authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final isDemo = _authService.isDemoMode;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Switchn',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF00BFE4),
        actions: [
          if (isDemo)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red[400],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Demo Mode',
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _handleSignOut,
            tooltip: 'Sign Out',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(icon: Icon(Icons.history), text: 'History'),
            Tab(icon: Icon(Icons.person), text: 'Profile'),
            Tab(icon: Icon(Icons.settings), text: 'More'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHomeTab(),
          _buildHistoryTab(),
          _buildProfileTab(),
          _buildMoreTab(),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return Consumer<WalletProvider>(
      builder: (context, walletProvider, child) {
        final wallet = walletProvider.wallet;
        final isLoading = walletProvider.isLoading;

        if (isLoading && wallet == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00BFE4), Color(0xFF0095B6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00BFE4).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Wallet Balance',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'XAF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        wallet != null 
                            ? '${wallet.balance.toStringAsFixed(0)}'
                            : '0',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Available for transactions',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildQuickActionCard(
                      icon: Icons.phone_android,
                      label: 'Buy Airtime',
                      color: const Color(0xFFF1C40F),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AirtimeScreen()),
                        );
                      },
                    ),
                    _buildQuickActionCard(
                      icon: Icons.data_usage,
                      label: 'Buy Bundle',
                      color: const Color(0xFF9B59B6),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BundleScreen()),
                        );
                      },
                    ),
                    _buildQuickActionCard(
                      icon: Icons.send,
                      label: 'Send Money',
                      color: const Color(0xFFE67E22),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TransferScreen()),
                        );
                      },
                    ),
                    _buildQuickActionCard(
                      icon: Icons.account_balance_wallet,
                      label: 'Fund Wallet',
                      color: const Color(0xFF2ECC71),
                      onTap: () => _showFundWalletDialog(context),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Consumer<TransactionProvider>(
                  builder: (context, transactionProvider, child) {
                    final transactions = transactionProvider.transactions;
                    
                    if (transactions.isEmpty) {
                      return const Card(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.receipt_long, size: 48, color: Colors.grey),
                                SizedBox(height: 16),
                                Text('No transactions yet'),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: transactions.take(5).map((tx) => _buildTransactionCard(tx)).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3), width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    IconData icon;
    Color iconColor;

    switch (transaction.type.toUpperCase()) {
      case 'AIRTIME':
        icon = Icons.phone_android;
        iconColor = const Color(0xFFF1C40F);
        break;
      case 'DATA':
        icon = Icons.data_usage;
        iconColor = const Color(0xFF9B59B6);
        break;
      case 'TRANSFER':
        icon = Icons.send;
        iconColor = const Color(0xFFE67E22);
        break;
      case 'FUND':
        icon = Icons.account_balance_wallet;
        iconColor = const Color(0xFF2ECC71);
        break;
      default:
        icon = Icons.receipt;
        iconColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          transaction.type,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          transaction.description ?? 'No description',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              transaction.type.toUpperCase() == 'FUND'
                  ? '+${transaction.amount.toStringAsFixed(0)}'
                  : '-${transaction.amount.toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: transaction.type.toUpperCase() == 'FUND'
                    ? const Color(0xFF2ECC71)
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return const TransactionHistoryScreen();
  }

  Widget _buildProfileTab() {
    return const ProfileScreen();
  }

  Widget _buildMoreTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSettingsCard(
          icon: Icons.notifications,
          title: 'Notifications',
          subtitle: 'Manage your notifications',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Coming soon')),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildSettingsCard(
          icon: Icons.security,
          title: 'Security',
          subtitle: 'PIN, biometrics, and security settings',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Coming soon')),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildSettingsCard(
          icon: Icons.help,
          title: 'Help & Support',
          subtitle: 'Get help with Switchn',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Coming soon')),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildSettingsCard(
          icon: Icons.info,
          title: 'About',
          subtitle: 'App version 1.0.0',
          onTap: () {
            _showAboutDialog();
          },
        ),
      ],
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF00BFE4)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showFundWalletDialog(BuildContext context) {
    final TextEditingController amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fund Wallet'),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount (XAF)',
            prefixIcon: Icon(Icons.payments),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                Navigator.pop(context);
                final walletProvider = Provider.of<WalletProvider>(context, listen: false);
                try {
                  await walletProvider.fundWallet(amount);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Wallet funded with ${amount.toStringAsFixed(0)} XAF'),
                        backgroundColor: const Color(0xFF2ECC71),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BFE4),
            ),
            child: const Text('Fund'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Switchn'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Switchn - Universal Digital Callbox'),
            SizedBox(height: 8),
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text(
              'Switchn allows you to buy airtime, data bundles, and send money between MTN and Orange networks in Cameroon.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}