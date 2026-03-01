import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/extensions/theme_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SettingsScreen(),
    );
  }

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = true;
  bool _notifications = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? true;
      _notifications = prefs.getBool('notifications') ?? false;
    });
  }

  Future<void> _saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    setState(() => _darkMode = value);
  }

  Future<void> _saveNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
    setState(() => _notifications = value);
  }

  Future<void> _signOut() async {
    setState(() => _isLoading = true);

    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (!mounted) return;
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signed out successfully'),
          backgroundColor: AppColor.emeraldGreen,
        ),
      );

      // Navigate to login screen
      // Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: ${e.toString()}'),
          backgroundColor: AppColor.lightRed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.bottomNavBarBackGround,
        title: Text('Sign Out?', style: context.fonts.headlineSmall),
        content: Text(
          'Are you sure you want to sign out?',
          style: context.fonts.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: context.fonts.bodyMedium?.copyWith(color: AppColor.gray),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _signOut();
            },
            child: Text(
              'Sign Out',
              style: context.fonts.bodyMedium?.copyWith(
                color: AppColor.lightRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: AppColor.bottomNavBarBackGround,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Settings',
                  style: context.fonts.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColor.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Dark Mode
            _SettingsRow(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              subtitle: _darkMode ? 'Currently enabled' : 'Currently disabled',
              trailing: Switch(
                value: _darkMode,
                onChanged: (val) => _saveDarkMode(val),
                activeThumbColor: AppColor.blueStart,
                activeTrackColor: AppColor.blueStart.withValues(alpha: 0.3),
                inactiveTrackColor: AppColor.borderGray,
                inactiveThumbColor: AppColor.gray,
              ),
            ),
            const SizedBox(height: 8),

            // Notifications
            _SettingsRow(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Budget alerts & insights',
              trailing: Switch(
                value: _notifications,
                onChanged: (val) => _saveNotifications(val),
                activeThumbColor: AppColor.blueStart,
                activeTrackColor: AppColor.blueStart.withValues(alpha: 0.3),
                inactiveTrackColor: AppColor.borderGray,
                inactiveThumbColor: AppColor.gray,
              ),
            ),
            const SizedBox(height: 8),

            // Privacy & Security
            _SettingsRow(
              icon: Icons.shield_outlined,
              title: 'Privacy & Security',
              subtitle: 'Manage your data',
              trailing: const Icon(Icons.chevron_right, color: AppColor.gray),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Privacy & Security - Coming soon'),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),

            // Help & Support
            _SettingsRow(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get assistance',
              trailing: const Icon(Icons.chevron_right, color: AppColor.gray),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Help & Support - Coming soon')),
                );
              },
            ),
            const SizedBox(height: 16),

            // Sign Out
            GestureDetector(
              onTap: _isLoading ? null : _showSignOutDialog,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.lightRed.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColor.lightRed,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.logout,
                              color: AppColor.lightRed,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Sign Out',
                              style: context.fonts.bodyMedium?.copyWith(
                                color: AppColor.lightRed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const Spacer(),

            // Version
            Center(
              child: Text(
                'Expense Tracker V1.0.0',
                style: context.fonts.bodyMedium?.copyWith(
                  color: AppColor.gray,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = true;
  bool _notifications = false;
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    height:
    MediaQuery.of(context).size.height * 0.55;

    return Container(
      decoration: const BoxDecoration(
        color: AppColor.bottomNavBarBackGround,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Settings',
                  style: context.fonts.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColor.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Dark Mode
            _SettingsRow(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              subtitle: _darkMode ? 'Currently enabled' : 'Currently disabled',
              trailing: Switch(
                value: _darkMode,
                onChanged: (val) => setState(() => _darkMode = val),
                activeThumbColor: AppColor.blueStart,
                activeTrackColor: AppColor.blueStart.withValues(alpha: 0.3),
                inactiveTrackColor: AppColor.borderGray,
                inactiveThumbColor: AppColor.gray,
              ),
            ),
            const SizedBox(height: 8),

            // Notifications
            _SettingsRow(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Budget alerts & insights',
              trailing: Switch(
                value: _notifications,
                onChanged: (val) => setState(() => _notifications = val),
                activeThumbColor: AppColor.blueStart,
                activeTrackColor: AppColor.blueStart.withValues(alpha: 0.3),
                inactiveTrackColor: AppColor.borderGray,
                inactiveThumbColor: AppColor.gray,
              ),
            ),
            const SizedBox(height: 8),

            // Privacy & Security
            _SettingsRow(
              icon: Icons.shield_outlined,
              title: 'Privacy & Security',
              subtitle: 'Manage your data',
              trailing: const Icon(Icons.chevron_right, color: AppColor.gray),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Privacy & Security - Coming soon'),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),

            // Help & Support
            _SettingsRow(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get assistance',
              trailing: const Icon(Icons.chevron_right, color: AppColor.gray),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Help & Support - Coming soon')),
                );
              },
            ),
            const SizedBox(height: 16),

            // Sign Out
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Signed out')));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.emeraldGreen.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.logout,
                        color: AppColor.emeraldGreen,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Sign Out',
                        style: TextStyle(
                          color: AppColor.emeraldGreen,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),

            // Version
            Center(
              child: Text(
                'Expense Tracker V1.0.0',
                style: context.fonts.bodyMedium?.copyWith(
                  color: AppColor.gray,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColor.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.fonts.bodyMedium?.copyWith(
                      color: AppColor.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: context.fonts.bodyMedium?.copyWith(
                      color: AppColor.gray,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
