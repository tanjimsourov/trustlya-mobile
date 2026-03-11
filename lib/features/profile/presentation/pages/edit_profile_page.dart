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
import '../../domain/entities/user_profile.dart';
import '../../presentation/cubit/profile_cubit.dart';
import '../../presentation/cubit/profile_state.dart';

/// A form for editing the user's profile details. Prepopulates the
/// fields with existing data and saves changes via the profile cubit.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  UserProfile? _originalProfile;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (_) => getIt<ProfileCubit>()..loadProfile(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) async {
          if (state.status == Status.success && _originalProfile != null) {
            // On update success show confirmation if this isn't the initial load
            if (_originalProfile!.name != _nameController.text ||
                _originalProfile!.email != _emailController.text ||
                _originalProfile!.phone != _phoneController.text) {
              await showSuccessDialog(context,
                  title: 'Profile Updated',
                  message: 'Your profile has been successfully updated');
              Navigator.of(context).pop();
            }
          } else if (state.status == Status.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message ?? 'Failed to update profile')),
            );
          }
        },
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const LoadingWidget();
          }
          if (state.status == Status.error) {
            return shared.ErrorWidgetView(message: state.message);
          }
          if (state.status == Status.success) {
            final profile = state.data as UserProfile;
            // Populate controllers on first build
            if (_originalProfile == null) {
              _originalProfile = profile;
              _nameController.text = profile.name;
              _emailController.text = profile.email;
              _phoneController.text = profile.phone;
            }
            return AppScaffold(
              appBar: AppBar(title: const Text('Edit Profile')),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Full Name', style: AppTypography.subtitle1),
                        const SizedBox(height: AppSpacing.xs),
                        AppTextField(
                          controller: _nameController,
                          hintText: 'Enter your name',
                          prefixIcon: Icons.person,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text('Email Address', style: AppTypography.subtitle1),
                        const SizedBox(height: AppSpacing.xs),
                        AppTextField(
                          controller: _emailController,
                          hintText: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            final emailReg =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$');
                            if (!emailReg.hasMatch(value)) {
                              return 'Invalid email format';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text('Phone Number', style: AppTypography.subtitle1),
                        const SizedBox(height: AppSpacing.xs),
                        AppTextField(
                          controller: _phoneController,
                          hintText: 'Enter your phone',
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Row(
                          children: [
                            Expanded(
                              child: SecondaryButton(
                                label: 'Discard',
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
                                    final updated = profile.copyWith(
                                      name: _nameController.text.trim(),
                                      email: _emailController.text.trim(),
                                      phone: _phoneController.text.trim(),
                                    );
                                    context
                                        .read<ProfileCubit>()
                                        .updateProfile(updated);
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
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
