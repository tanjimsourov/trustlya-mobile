import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/inputs.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../presentation/cubit/auth_cubit.dart';
import '../../presentation/cubit/auth_state.dart';

/// Sign up page allowing new users to create an account. Collects
/// basic information and triggers the authentication flow via
/// [AuthCubit]. After registration an OTP is sent and the user is
/// navigated to the verification page.
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _referralController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;
    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')));
      return;
    }
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please accept the terms')));
      return;
    }
    context.read<AuthCubit>().register(name, email, password);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state.status == Status.success && state.data != null) {
            final user = state.data!;
            final email = user.email;
            // Immediately send OTP and navigate to verification page
            await context.read<AuthCubit>().sendOtp(email);
            Navigator.of(context)
                .pushReplacementNamed(Routes.verifyOtp, arguments: email);
          }
        },
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const LoadingWidget();
          }
          return AppScaffold(
            body: ResponsivePageWrapper(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Create Account', style: AppTypography.h2),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Join Trustlya and explore the ecosystem',
                          style: AppTypography.body1
                              .copyWith(color: AppColorsDS.textSecondary)),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _nameController,
                        hintText: 'Name',
                        prefixIcon: Icons.person,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        prefixIcon: Icons.lock,
                        obscureText: _obscurePassword,
                        suffixIcon: _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        onSuffixTap: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm Password',
                        prefixIcon: Icons.lock,
                        obscureText: _obscureConfirm,
                        suffixIcon: _obscureConfirm
                            ? Icons.visibility
                            : Icons.visibility_off,
                        onSuffixTap: () {
                          setState(() => _obscureConfirm = !_obscureConfirm);
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: _referralController,
                        hintText: 'Referral Code (Optional)',
                        prefixIcon: Icons.card_giftcard,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Checkbox(
                            value: _acceptedTerms,
                            onChanged: (value) =>
                                setState(() => _acceptedTerms = value ?? false),
                            activeColor: AppColorsDS.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'I agree to the Terms of Service and Privacy Policy',
                              style: AppTypography.body2
                                  .copyWith(color: AppColorsDS.textSecondary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (state.status == Status.error)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: shared.ErrorWidgetView(message: state.message),
                        ),
                      PrimaryButton(
                        label: 'Sign Up',
                        onPressed: () => _submit(context),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      GhostButton(
                        label: 'Already have an account? Sign In',
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(Routes.login);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
