import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/dialogs.dart';
import '../../../../shared/widgets/inputs.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../presentation/cubit/kyc_cubit.dart';
import '../../presentation/cubit/kyc_state.dart';

/// A comprehensive document upload page for KYC. Allows selecting
/// document type and simulates uploading front and back images as
/// well as a selfie. Uses the [KycCubit] to persist uploads and
/// updates the verification status accordingly. This is a mock
/// implementation without actual file picking.
class DocumentUploadPage extends StatefulWidget {
  const DocumentUploadPage({Key? key}) : super(key: key);

  @override
  State<DocumentUploadPage> createState() => _DocumentUploadPageState();
}

class _DocumentUploadPageState extends State<DocumentUploadPage> {
  String _docType = 'passport';
  bool _frontUploaded = false;
  bool _backUploaded = false;
  bool _selfieUploaded = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<KycCubit>(
      create: (_) => getIt<KycCubit>(),
      child: BlocConsumer<KycCubit, KycState>(
        listener: (context, state) async {
          if (state.status == Status.success) {
            await showSuccessDialog(context,
                title: 'Documents Submitted',
                message: 'Your documents have been submitted for review.');
            // After submission, navigate back to status page
            Navigator.of(context)
                .popUntil((route) => route.settings.name == Routes.kycStatus);
          } else if (state.status == Status.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'Upload failed')),
            );
          }
        },
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const LoadingWidget();
          }
          return AppScaffold(
            appBar: AppBar(title: const Text('Upload Documents')),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Document Type', style: AppTypography.h3),
                    const SizedBox(height: AppSpacing.sm),
                    AppDropdown<String>(
                      value: _docType,
                      items: const [
                        DropdownMenuItem(
                            value: 'passport', child: Text('Passport')),
                        DropdownMenuItem(
                            value: 'id', child: Text('National ID')),
                        DropdownMenuItem(
                            value: 'license', child: Text('Driver’s License')),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _docType = val ?? 'passport';
                        });
                      },
                    ),
                    const SectionSpacing(),
                    Text('Upload Front', style: AppTypography.h3),
                    const SizedBox(height: AppSpacing.sm),
                    _UploadPlaceholder(
                      uploaded: _frontUploaded,
                      label: 'Front of document',
                      onTap: () {
                        // Simulate selection
                        setState(() {
                          _frontUploaded = true;
                        });
                      },
                    ),
                    const SectionSpacing(height: AppSpacing.lg),
                    Text('Upload Back', style: AppTypography.h3),
                    const SizedBox(height: AppSpacing.sm),
                    _UploadPlaceholder(
                      uploaded: _backUploaded,
                      label: 'Back of document',
                      onTap: () {
                        setState(() {
                          _backUploaded = true;
                        });
                      },
                    ),
                    const SectionSpacing(height: AppSpacing.lg),
                    Text('Selfie', style: AppTypography.h3),
                    const SizedBox(height: AppSpacing.sm),
                    _UploadPlaceholder(
                      uploaded: _selfieUploaded,
                      label: 'Your selfie',
                      onTap: () {
                        setState(() {
                          _selfieUploaded = true;
                        });
                      },
                    ),
                    const SectionSpacing(),
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
                            label: 'Submit',
                            onPressed: (_frontUploaded &&
                                    _backUploaded &&
                                    _selfieUploaded)
                                ? () {
                                    // Simulate upload of identity and document
                                    context
                                        .read<KycCubit>()
                                        .uploadIdentity('$_docType-front');
                                    context
                                        .read<KycCubit>()
                                        .uploadDocument('$_docType-back');
                                  }
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A placeholder widget representing a file upload field. Shows an
/// upload icon and label and toggles to a check icon once uploaded.
class _UploadPlaceholder extends StatelessWidget {
  final bool uploaded;
  final String label;
  final VoidCallback onTap;
  const _UploadPlaceholder(
      {Key? key,
      required this.uploaded,
      required this.label,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColorsDS.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColorsDS.surface.withOpacity(0.5)),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                uploaded ? Icons.check_circle : Icons.cloud_upload,
                size: 48,
                color: uploaded ? AppColorsDS.success : AppColorsDS.primary,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(label,
                  style: AppTypography.body2
                      .copyWith(color: AppColorsDS.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
