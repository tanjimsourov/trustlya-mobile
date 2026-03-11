import 'dart:async';

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

/// Allows users to enter a six‑digit one‑time password sent to their
/// email. Includes a countdown for resending the code and invokes the
/// appropriate [AuthCubit] methods. On verification success the
/// user is navigated into the app shell.
class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({Key? key}) : super(key: key);

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  String _code = '';
  int _secondsRemaining = 30;
  Timer? _timer;
  late String _email;

  @override
  void initState() {
    super.initState();
    // Extract the email from route arguments. If none provided we
    // default to an empty string which will cause verification to fail.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) {
        _email = args;
      } else {
        _email = '';
      }
      _startTimer();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() => _secondsRemaining = 0);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == Status.success) {
            // Navigate into the app upon successful verification
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Verify Code', style: AppTypography.h2),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Enter the 6‑digit code sent to $_email',
                          style: AppTypography.body1
                              .copyWith(color: AppColorsDS.textSecondary),
                          textAlign: TextAlign.center),
                      const SizedBox(height: AppSpacing.lg),
                      OtpInput(
                        length: 6,
                        onChanged: (value) => _code = value,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (state.status == Status.error)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: shared.ErrorWidgetView(message: state.message),
                        ),
                      PrimaryButton(
                        label: 'Verify',
                        onPressed: _code.length == 6
                            ? () {
                                context
                                    .read<AuthCubit>()
                                    .verifyOtp(_email, _code);
                              }
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Resend option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_secondsRemaining > 0)
                            Text('Resend code in $_secondsRemaining s',
                                style: AppTypography.body2
                                    .copyWith(color: AppColorsDS.textSecondary))
                          else
                            GhostButton(
                              label: 'Resend Code',
                              onPressed: () {
                                context.read<AuthCubit>().sendOtp(_email);
                                _startTimer();
                              },
                            ),
                        ],
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
