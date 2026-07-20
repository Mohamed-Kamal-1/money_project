import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/dimensions/dimension_app.dart';
import 'package:money/features/home/presentation/view/widgets/setting/app_version_footer.dart';
import 'package:money/features/home/presentation/view/widgets/setting/settings_section_header.dart';
import 'package:money/features/home/presentation/view/widgets/setting/settings_tile.dart';
import 'package:money/features/home/presentation/view/widgets/setting/user_profile_header.dart';

import '../../../../../../user_setting/presentation/cubit/user_settings/user_settings_cubit.dart';
import '../../../../../../user_setting/presentation/cubit/user_settings/user_settings_state.dart';
import '../../../auth_feature/presentation/view_model/cubit/auth_cubit.dart';
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
  late final String _userName;
  late final String _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      _userId = authState.user.uid;
      _userName = authState.user.displayName ?? 'User';
      _userEmail = authState.user.email ?? 'No email';
      context.read<UserSettingsCubit>().listenToSettings(_userId);
    } else {
      _userId = '';
      _userName = 'Guest';
      _userEmail = '';
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
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(Dimension.padding16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Profile Header
                UserProfileHeader(userName: _userName, userEmail: _userEmail),
                const SizedBox(height: 16),

                // APPEARANCE Section
                const SettingsSectionHeader(title: 'APPEARANCE'),
                SettingsTile(
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

                // NOTIFICATIONS Section
                const SettingsSectionHeader(title: 'NOTIFICATIONS'),
                SettingsTile(
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

                // ACCOUNT Section
                const SettingsSectionHeader(title: 'ACCOUNT'),
                SettingsTile(
                  icon: Icons.person,
                  iconColor: AppColor.emeraldGreen,
                  title: 'User Name',
                  subtitle: _userName,
                ),
                const SizedBox(height: 8),
                SettingsTile(
                  icon: Icons.email_outlined,
                  iconColor: AppColor.blueStart,
                  title: 'Email',
                  subtitle: _userEmail,
                ),
                const SizedBox(height: 8),
                // (User ID can be added here if needed)
                SettingsTile(
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
                const AppVersionFooter(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
