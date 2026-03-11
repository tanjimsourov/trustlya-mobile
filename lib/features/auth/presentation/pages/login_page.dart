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

/// Sign in page allowing existing users to authenticate. Utilises the
/// design system text fields and buttons. Shows loading and error
/// states via the [AuthCubit]. Upon success the user is taken to
/// the application shell.
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == Status.success) {
            // Navigate to the main app shell upon successful login
            Navigator.of(context).pushReplacementNamed(Routes.shell);
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
                      Text('Welcome back', style: AppTypography.h2),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Sign in to continue',
                          style: AppTypography.body1
                              .copyWith(color: AppColorsDS.textSecondary)),
                      const SizedBox(height: AppSpacing.lg),
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
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) =>
                                setState(() => _rememberMe = value ?? false),
                            activeColor: AppColorsDS.primary,
                          ),
                          const SizedBox(width: 4),
                          Text('Remember me', style: AppTypography.body2),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(Routes.forgotPassword);
                            },
                            child: Text('Forgot password?',
                                style: AppTypography.body2
                                    .copyWith(color: AppColorsDS.primary)),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (state.status == Status.error)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: shared.ErrorWidgetView(message: state.message),
                        ),
                      PrimaryButton(
                        label: 'Sign In',
                        onPressed: () {
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          context.read<AuthCubit>().login(email, password);
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SecondaryButton(
                        label: 'Create Account',
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(Routes.register);
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'By signing in you agree to our Terms & Privacy Policy.',
                        style: AppTypography.caption
                            .copyWith(color: AppColorsDS.textSecondary),
                        textAlign: TextAlign.center,
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
