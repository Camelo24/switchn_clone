import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;
    final isDemo = authService.isDemoMode;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Profile'),
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
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor: const Color(0xFF00BFE4),
              child: const Icon(Icons.person, size: 72, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text(
              user?.email ?? 'Unknown User',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (user?.phoneNumber != null)
              Text(
                user!.phoneNumber!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Active Account',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildProfileCard(
              icon: Icons.phone,
              title: 'Phone Number',
              subtitle: user?.phoneNumber ?? 'Not linked',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildProfileCard(
              icon: Icons.email,
              title: 'Email',
              subtitle: user?.email ?? 'Not linked',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildProfileCard(
              icon: Icons.security,
              title: 'Security Settings',
              subtitle: 'Manage PIN and biometrics',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Security settings coming soon')),
                );
              },
              trailing: const Icon(Icons.chevron_right),
            ),
            const SizedBox(height: 12),
            _buildProfileCard(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Manage your notifications',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification settings coming soon')),
                );
              },
              trailing: const Icon(Icons.chevron_right),
            ),
            const SizedBox(height: 12),
            _buildProfileCard(
              icon: Icons.help,
              title: 'Help & Support',
              subtitle: 'Get help with Switchn',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Help center coming soon')),
                );
              },
              trailing: const Icon(Icons.chevron_right),
            ),
            const SizedBox(height: 12),
            _buildProfileCard(
              icon: Icons.info,
              title: 'About',
              subtitle: 'App version 1.0.0',
              onTap: () {
                _showAboutDialog(context);
              },
              trailing: const Icon(Icons.chevron_right),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () async {
                  await authService.signOut();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'SIGN OUT',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF00BFE4)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
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
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
