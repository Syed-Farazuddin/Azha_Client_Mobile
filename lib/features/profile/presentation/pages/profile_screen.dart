import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/loading_indicator.dart';
import 'package:mobile/core/colors/app_colors.dart';
import 'package:mobile/core/constants/text_styles.dart';
import 'package:mobile/features/auth/domain/providers/auth_provider.dart';
import 'package:mobile/features/profile/domain/providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: customTextStyles['sb20']?.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.dark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: profileAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text(
                'User details not found.',
                style: TextStyle(color: AppColors.white),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50.r,
                  backgroundColor: AppColors.blue500,
                  child: Text(
                    user.name.substring(0, 1).toUpperCase(),
                    style: customTextStyles['sb32']?.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  user.name,
                  style: customTextStyles['sb24']?.copyWith(
                    color: AppColors.white,
                  ),
                ),
                Text(
                  user.email,
                  style: customTextStyles['r16']?.copyWith(
                    color: AppColors.subTitles,
                  ),
                ),
                SizedBox(height: 40.h),

                _buildProfileOption(
                  icon: Icons.location_on_outlined,
                  title: 'My Addresses',
                  onTap: () => context.go('/addresses'),
                ),
                _buildProfileOption(
                  icon: Icons.shopping_bag_outlined,
                  title: 'My Orders',
                  onTap: () {
                    // Navigate to orders
                  },
                ),
                _buildProfileOption(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {},
                ),
                SizedBox(height: 40.h),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.red500),
                  title: Text(
                    'Logout',
                    style: customTextStyles['sb16']?.copyWith(
                      color: AppColors.red500,
                    ),
                  ),
                  onTap: () {
                    ref.read(authStateProvider.notifier).logout();
                    context.go('/login');
                  },
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: TextStyle(color: AppColors.red500)),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.white),
      title: Text(
        title,
        style: customTextStyles['sb16']?.copyWith(color: AppColors.white),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.subTitles,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
