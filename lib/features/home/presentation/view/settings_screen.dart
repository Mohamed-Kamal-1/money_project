import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/colors/app_color.dart';
import '../../../../core/dimensions/dimension_app.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../user_setting/presentation/cubit/user_settings/user_settings_cubit.dart';
import '../../../../user_setting/presentation/cubit/user_settings/user_settings_state.dart';
import '../../../auth_feature/presentation/view_model/cubit/auth_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static Future<void> show(BuildContext context) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
  }

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final String _userId;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      _userId = authState.user.uid;
      context.read<UserSettingsCubit>().listenToSettings(_userId);
    } else {
      _userId = '';
    }
  }

  Future<void> _signOut() async {
    await context.read<AuthCubit>().signOut();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signed out successfully'),
          backgroundColor: AppColor.emeraldGreen,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_userId.isEmpty) {
      return const Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return BlocBuilder<UserSettingsCubit, UserSettingsState>(
      builder: (context, state) {
        bool darkMode = true;
        bool notifications = true;
        if (state is UserSettingsLoaded) {
          darkMode = state.settings.darkMode;
          notifications = state.settings.notificationsEnabled;
        }

        return Scaffold(
          backgroundColor: AppColor.primaryColor,
          appBar: AppBar(
            backgroundColor: AppColor.primaryColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColor.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Settings',
              style: context.fonts.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(Dimension.padding16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Appearance Section
                const _SectionHeader(title: 'APPEARANCE'),
                _SettingTile(
                  icon: Icons.dark_mode,
                  iconColor: AppColor.softLavender,
                  title: 'Dark Mode',
                  subtitle: 'Use dark theme',
                  trailing: Switch(
                    value: darkMode,
                    onChanged: (value) {
                      context.read<UserSettingsCubit>().toggleDarkMode(
                        _userId,
                        value,
                      );
                    },
                    activeThumbColor: AppColor.blueStart,
                  ),
                ),
                const SizedBox(height: 8),

                // Notifications Section
                const _SectionHeader(title: 'NOTIFICATIONS'),
                _SettingTile(
                  icon: Icons.notifications,
                  iconColor: AppColor.amberOrange,
                  title: 'Push Notifications',
                  subtitle: 'Get notified about spending',
                  trailing: Switch(
                    value: notifications,
                    onChanged: (value) {
                      context.read<UserSettingsCubit>().toggleNotifications(
                        _userId,
                        value,
                      );
                    },
                    activeThumbColor: AppColor.blueStart,
                  ),
                ),
                const SizedBox(height: 8),

                // Account Section
                const _SectionHeader(title: 'ACCOUNT'),
                _SettingTile(
                  icon: Icons.person,
                  iconColor: AppColor.emeraldGreen,
                  title: 'User ID',
                  subtitle: _userId,
                ),
                const SizedBox(height: 8),

                _SettingTile(
                  icon: Icons.logout,
                  iconColor: AppColor.lightRed,
                  title: 'Sign Out',
                  subtitle: 'Log out of your account',
                  trailing: state is UserSettingsLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColor.lightRed,
                          ),
                        )
                      : null,
                  onTap: state is UserSettingsLoading ? null : _signOut,
                ),

                const Spacer(),

                // App version
                Center(
                  child: Text(
                    'Expense Tracker v1.0.0',
                    style: context.fonts.bodySmall?.copyWith(
                      color: AppColor.gray,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ==================== Helper Widgets ====================

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColor.gray,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColor.bottomNavBarBackGround,
          borderRadius: BorderRadius.circular(Dimension.circular12),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColor.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColor.gray,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            trailing ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
