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

/// Allows the user to reset their password by requesting a reset code.
/// Sends an OTP to the provided email and navigates to the verification
/// page on success.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == Status.success) {
            final email = _emailController.text;
            // Navigate to OTP verification with the email
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
                      Text('Forgot Password', style: AppTypography.h2),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Enter your email to receive a reset code',
                          style: AppTypography.body1
                              .copyWith(color: AppColorsDS.textSecondary)),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (state.status == Status.error)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: shared.ErrorWidgetView(message: state.message),
                        ),
                      PrimaryButton(
                        label: 'Send Reset Code',
                        onPressed: () {
                          final email = _emailController.text;
                          context.read<AuthCubit>().sendOtp(email);
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      GhostButton(
                        label: 'Back to Sign In',
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
