import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/loading_indicator.dart';
import 'package:mobile/core/colors/app_colors.dart';
import 'package:mobile/core/constants/text_styles.dart';
import 'package:mobile/features/auth/domain/providers/auth_provider.dart';
import 'package:mobile/features/profile/domain/providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: profileAsync.when(
        data: (user) {
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off_outlined,
                    size: 64,
                    color: AppColors.subTitles,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Unable to load profile',
                    style: customTextStyles['sb18']?.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextButton(
                    onPressed: () => ref.invalidate(profileProvider),
                    child: Text(
                      'Retry',
                      style: TextStyle(color: AppColors.blue500),
                    ),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // Custom App Bar with gradient
              SliverAppBar(
                expandedHeight: 260.h,
                pinned: true,
                backgroundColor: AppColors.dark,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    margin: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.blue700,
                          AppColors.blue500,
                          AppColors.background,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20.h),
                          // Avatar
                          Container(
                            width: 90.w,
                            height: 90.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [AppColors.blue400, AppColors.purple],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.blue500.withValues(
                                    alpha: 0.4,
                                  ),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                user.name.isNotEmpty
                                    ? user.name.substring(0, 1).toUpperCase()
                                    : '?',
                                style: customTextStyles['sb32']?.copyWith(
                                  color: AppColors.white,
                                ),
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
                          SizedBox(height: 4.h),
                          Text(
                            user.email,
                            style: customTextStyles['r14']?.copyWith(
                              color: AppColors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Profile Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Info Card
                      _buildSectionCard(
                        title: 'Personal Information',
                        trailing: GestureDetector(
                          onTap: () => _showEditProfileSheet(context, user),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.blue500.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: AppColors.blue500,
                                  size: 14,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Edit',
                                  style: customTextStyles['sb12']?.copyWith(
                                    color: AppColors.blue500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        children: [
                          _buildInfoRow(
                            Icons.person_outline,
                            'Name',
                            user.name,
                          ),
                          _buildInfoRow(
                            Icons.email_outlined,
                            'Email',
                            user.email,
                          ),
                          _buildInfoRow(
                            Icons.phone_outlined,
                            'Phone',
                            user.phone ?? 'Not set',
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Quick Actions
                      _buildSectionCard(
                        title: 'My Activity',
                        children: [
                          _buildActionTile(
                            icon: Icons.shopping_bag_outlined,
                            title: 'My Orders',
                            subtitle: 'Track, return or buy again',
                            color: AppColors.orange300,
                            onTap: () {
                              // TODO: Navigate to orders
                            },
                          ),
                          Divider(
                            color: AppColors.whitish,
                            height: 1,
                            indent: 52.w,
                          ),
                          _buildActionTile(
                            icon: Icons.shopping_cart_outlined,
                            title: 'My Cart',
                            subtitle: 'View items in your cart',
                            color: AppColors.blue500,
                            onTap: () => context.push('/cart'),
                          ),
                          Divider(
                            color: AppColors.whitish,
                            height: 1,
                            indent: 52.w,
                          ),
                          _buildActionTile(
                            icon: Icons.location_on_outlined,
                            title: 'Saved Addresses',
                            subtitle: 'Manage your delivery addresses',
                            color: AppColors.green500,
                            onTap: () => context.push('/addresses'),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Offers Section
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.purple, AppColors.blue700],
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.local_offer_outlined,
                              color: AppColors.primaryYellow,
                              size: 36,
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Exclusive Offers',
                                    style: customTextStyles['sb16']?.copyWith(
                                      color: AppColors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Get up to 50% off on your next order!',
                                    style: customTextStyles['r12']?.copyWith(
                                      color: AppColors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Settings Section
                      _buildSectionCard(
                        title: 'Settings',
                        children: [
                          _buildActionTile(
                            icon: Icons.notifications_outlined,
                            title: 'Notifications',
                            subtitle: 'Manage notification preferences',
                            color: AppColors.orange300,
                            onTap: () {},
                          ),
                          Divider(
                            color: AppColors.whitish,
                            height: 1,
                            indent: 52.w,
                          ),
                          _buildActionTile(
                            icon: Icons.help_outline,
                            title: 'Help & Support',
                            subtitle: 'Get help with your orders',
                            color: AppColors.blue400,
                            onTap: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Logout Button
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: AppColors.dark,
                              title: Text(
                                'Logout',
                                style: customTextStyles['sb18']?.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                              content: Text(
                                'Are you sure you want to logout?',
                                style: customTextStyles['r14']?.copyWith(
                                  color: AppColors.subTitles,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: AppColors.subTitles,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ref
                                        .read(authStateProvider.notifier)
                                        .logout();
                                    context.go('/login');
                                  },
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(color: AppColors.red500),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            color: AppColors.red500.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.red500.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                color: AppColors.red500,
                                size: 20,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Logout',
                                style: customTextStyles['sb16']?.copyWith(
                                  color: AppColors.red500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.red500),
              SizedBox(height: 16.h),
              Text(
                'Something went wrong',
                style: customTextStyles['sb16']?.copyWith(
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: () => ref.invalidate(profileProvider),
                child: Text(
                  'Retry',
                  style: TextStyle(color: AppColors.blue500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    Widget? trailing,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.whitish),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: customTextStyles['sb16']?.copyWith(
                    color: AppColors.white,
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
          ...children,
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          Icon(icon, color: AppColors.subTitles, size: 20),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: customTextStyles['r12']?.copyWith(
                  color: AppColors.subTitles,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: customTextStyles['sb14']?.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: customTextStyles['sb14']?.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: customTextStyles['r12']?.copyWith(
                      color: AppColors.subTitles,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.subTitles, size: 14),
          ],
        ),
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context, dynamic user) {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(
          24.w,
          24.h,
          24.w,
          MediaQuery.of(ctx).viewInsets.bottom + 24.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.dark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.subTitles,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Edit Profile',
              style: customTextStyles['sb20']?.copyWith(color: AppColors.white),
            ),
            SizedBox(height: 24.h),
            _buildEditField('Name', nameController, Icons.person_outline),
            SizedBox(height: 16.h),
            _buildEditField('Email', emailController, Icons.email_outlined),
            SizedBox(height: 16.h),
            _buildEditField(
              'Phone',
              phoneController,
              Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Call update profile API
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Profile update coming soon!'),
                      backgroundColor: AppColors.blue500,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Save Changes',
                  style: customTextStyles['sb16']?.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: customTextStyles['r16']?.copyWith(color: AppColors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: customTextStyles['r14']?.copyWith(
          color: AppColors.subTitles,
        ),
        prefixIcon: Icon(icon, color: AppColors.subTitles, size: 20),
        filled: true,
        fillColor: AppColors.whitish,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.blue500),
        ),
      ),
    );
  }
}
