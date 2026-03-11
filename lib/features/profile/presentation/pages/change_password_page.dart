import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/dialogs.dart';
import '../../../../shared/widgets/inputs.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../presentation/cubit/profile_cubit.dart';
import '../../presentation/cubit/profile_state.dart';

/// A page that allows the user to change their password. It displays
/// the old password field, new password with a strength indicator and
/// confirm password. Validation ensures the new password is strong
/// enough and both new/confirm fields match. On success, a
/// success dialog is shown and the page is popped.
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String _passwordStrength(String value) {
    if (value.length >= 12 && _hasLetterAndNumber(value)) {
      return 'Strong';
    } else if (value.length >= 8) {
      return 'Medium';
    } else if (value.isNotEmpty) {
      return 'Weak';
    }
    return '';
  }

  bool _hasLetterAndNumber(String value) {
    final hasLetter = value.contains(RegExp(r'[A-Za-z]'));
    final hasNumber = value.contains(RegExp(r'[0-9]'));
    return hasLetter && hasNumber;
  }

  Color _strengthColor(String strength) {
    switch (strength) {
      case 'Strong':
        return AppColorsDS.success;
      case 'Medium':
        return AppColorsDS.warning;
      case 'Weak':
        return AppColorsDS.danger;
      default:
        return AppColorsDS.surface;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (_) => getIt<ProfileCubit>(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) async {
          if (state.status == Status.success) {
            await showSuccessDialog(context,
                title: 'Password Changed',
                message: 'Your password has been updated successfully');
            Navigator.of(context).pop();
          } else if (state.status == Status.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message ?? 'Failed to change password')),
            );
          }
        },
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const LoadingWidget();
          }
          return AppScaffold(
            appBar: AppBar(title: const Text('Change Password')),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Old Password', style: AppTypography.subtitle1),
                      const SizedBox(height: AppSpacing.xs),
                      AppTextField(
                        controller: _oldController,
                        obscureText: _obscureOld,
                        hintText: 'Enter current password',
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: _obscureOld
                            ? Icons.visibility
                            : Icons.visibility_off,
                        onSuffixTap: () =>
                            setState(() => _obscureOld = !_obscureOld),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your current password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text('New Password', style: AppTypography.subtitle1),
                      const SizedBox(height: AppSpacing.xs),
                      AppTextField(
                        controller: _newController,
                        obscureText: _obscureNew,
                        hintText: 'Enter new password',
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: _obscureNew
                            ? Icons.visibility
                            : Icons.visibility_off,
                        onSuffixTap: () =>
                            setState(() => _obscureNew = !_obscureNew),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Builder(
                        builder: (context) {
                          final strength =
                              _passwordStrength(_newController.text);
                          return Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: strength == 'Weak'
                                      ? 0.33
                                      : strength == 'Medium'
                                          ? 0.66
                                          : strength == 'Strong'
                                              ? 1.0
                                              : 0.0,
                                  backgroundColor: AppColorsDS.surface,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      _strengthColor(strength)),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                strength,
                                style: AppTypography.caption
                                    .copyWith(color: _strengthColor(strength)),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text('Confirm Password', style: AppTypography.subtitle1),
                      const SizedBox(height: AppSpacing.xs),
                      AppTextField(
                        controller: _confirmController,
                        obscureText: _obscureConfirm,
                        hintText: 'Re-enter new password',
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: _obscureConfirm
                            ? Icons.visibility
                            : Icons.visibility_off,
                        onSuffixTap: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your new password';
                          }
                          if (value != _newController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Row(
                        children: [
                          Expanded(
                            child: SecondaryButton(
                              label: 'Cancel',
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: PrimaryButton(
                              label: 'Save',
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  context.read<ProfileCubit>().changePassword(
                                        _oldController.text,
                                        _newController.text,
                                      );
                                }
                              },
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
        },
      ),
    );
  }
}
