import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/custom_button.dart';
import 'package:mobile/common/widgets/custom_text_field.dart';
import 'package:mobile/core/colors/app_colors.dart';
import 'package:mobile/core/constants/text_styles.dart';
import 'package:mobile/core/toasts/toaster.dart';
import 'package:mobile/features/auth/domain/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _onLogin() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final data = _formKey.currentState!.value;
      final success = await ref
          .read(authStateProvider.notifier)
          .login(data['email'], data['password']);

      if (success && mounted) {
        Toaster.onSuccess(message: 'Login successful');
        context.go('/home'); // Assuming home is the initial route after login
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                Text(
                  'Welcome Back!',
                  style: customTextStyles['sb24']?.copyWith(
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Log in to your account to continue',
                  style: customTextStyles['r16']?.copyWith(
                    color: AppColors.subTitles,
                  ),
                ),
                SizedBox(height: 48.h),
                CustomTextField(
                  name: 'email',
                  label: 'Email',
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  name: 'password',
                  label: 'Password',
                  hintText: 'Enter your password',
                  isPassword: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(6),
                  ]),
                ),
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: customTextStyles['sb14']?.copyWith(
                        color: AppColors.blue500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                CustomButton(
                  title: 'Log In',
                  isLoading: authState.isLoading,
                  onPressed: _onLogin,
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: customTextStyles['r14']?.copyWith(
                        color: AppColors.subTitles,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.go('/register');
                      },
                      child: Text(
                        'Sign Up',
                        style: customTextStyles['sb14']?.copyWith(
                          color: AppColors.blue500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
