import 'package:flutter/material.dart';

import '../../app/dependency_injection.dart';
import '../../core/config/app_backend.dart';
import '../../core/config/backend_registry.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'cards.dart';
import 'motion.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? eyebrow;
  final List<Widget>? actions;
  final List<Widget>? metadata;
  final bool showContextTools;
  final bool showBackButton;
  final bool showBackendButton;
  final VoidCallback? onBack;

  const PageHeader({
    Key? key,
    required this.title,
    required this.subtitle,
    this.eyebrow,
    this.actions,
    this.metadata,
    this.showContextTools = true,
    this.showBackButton = true,
    this.showBackendButton = true,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final backendInfo = showContextTools && canPop && showBackendButton
        ? _BackendHeaderInfo.maybeResolve()
        : null;
    final utilityActions = <Widget>[
      if (showContextTools && showBackButton && canPop)
        _HeaderUtilityButton(
          icon: Icons.arrow_back_rounded,
          label: 'Back',
          onTap: onBack ?? () => Navigator.of(context).maybePop(),
        ),
      if (backendInfo != null)
        _HeaderUtilityButton(
          icon: backendInfo.icon,
          label: backendInfo.badgeLabel,
          onTap: () => _showBackendStatusDialog(context, backendInfo),
        ),
    ];

    return MotionReveal(
      delay: const Duration(milliseconds: 40),
      beginOffset: const Offset(0, 0.018),
      beginScale: 0.994,
      beginBlur: 8,
      duration: const Duration(milliseconds: 780),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.xl),
        borderColor: AppColorsDS.borderStrong,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 860;
            final summary = ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (utilityActions.isNotEmpty) ...[
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: utilityActions,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  if (eyebrow != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColorsDS.primarySoft,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColorsDS.borderStrong),
                      ),
                      child: Text(
                        eyebrow!,
                        style: AppTypography.overline
                            .copyWith(color: AppColorsDS.primary),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  Text(title, style: AppTypography.h2),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    subtitle,
                    style: AppTypography.body1
                        .copyWith(color: AppColorsDS.textSecondary),
                  ),
                  if (metadata != null && metadata!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: metadata!,
                    ),
                  ],
                ],
              ),
            );

            if (stacked) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  summary,
                  if (actions != null && actions!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: actions!,
                    ),
                  ],
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: summary),
                if (actions != null && actions!.isNotEmpty) ...[
                  const SizedBox(width: AppSpacing.xl),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      alignment: WrapAlignment.end,
                      children: actions!,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  static Future<void> _showBackendStatusDialog(
    BuildContext context,
    _BackendHeaderInfo backendInfo,
  ) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Backend workspace',
            style: AppTypography.h4,
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  backendInfo.summary,
                  style: AppTypography.body2,
                ),
                const SizedBox(height: AppSpacing.lg),
                _BackendDetailRow(
                  label: 'Workspace mode',
                  value: backendInfo.modeLabel,
                ),
                _BackendDetailRow(
                  label: 'Coverage',
                  value: backendInfo.coverageLabel,
                ),
                _BackendDetailRow(
                  label: 'Endpoint',
                  value: backendInfo.endpointLabel,
                ),
                _BackendDetailRow(
                  label: 'Fallback policy',
                  value: backendInfo.fallbackLabel,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class FilterToolbar extends StatelessWidget {
  final Widget? leading;
  final Widget? center;
  final Widget? trailing;

  const FilterToolbar({
    Key? key,
    this.leading,
    this.center,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MotionReveal(
      delay: const Duration(milliseconds: 120),
      beginOffset: const Offset(0, 0.02),
      beginBlur: 8,
      duration: const Duration(milliseconds: 720),
      child: AppCard(
        borderColor: AppColorsDS.borderStrong,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 860;
            if (stacked) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (leading != null) leading!,
                  if (center != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    center!,
                  ],
                  if (trailing != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    trailing!,
                  ],
                ],
              );
            }

            return Row(
              children: [
                if (leading != null) Expanded(flex: 3, child: leading!),
                if (center != null) ...[
                  const SizedBox(width: AppSpacing.md),
                  Expanded(flex: 4, child: center!),
                ],
                if (trailing != null) ...[
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: trailing!,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeaderUtilityButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HeaderUtilityButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColorsDS.surfaceElevated,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColorsDS.borderStrong),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColorsDS.primary),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.caption
                  .copyWith(color: AppColorsDS.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackendDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _BackendDetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 108,
            child: Text(label, style: AppTypography.caption),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              value,
              style: AppTypography.subtitle2
                  .copyWith(color: AppColorsDS.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackendHeaderInfo {
  final String badgeLabel;
  final IconData icon;
  final String summary;
  final String modeLabel;
  final String coverageLabel;
  final String endpointLabel;
  final String fallbackLabel;

  const _BackendHeaderInfo({
    required this.badgeLabel,
    required this.icon,
    required this.summary,
    required this.modeLabel,
    required this.coverageLabel,
    required this.endpointLabel,
    required this.fallbackLabel,
  });

  static _BackendHeaderInfo? maybeResolve() {
    if (!getIt.isRegistered<AppBackendConfig>() ||
        !getIt.isRegistered<BackendRegistry>()) {
      return null;
    }

    final config = getIt<AppBackendConfig>();
    final registry = getIt<BackendRegistry>();
    final icon = registry.hasFallbacks
        ? Icons.sync_problem_outlined
        : config.usesApi
            ? Icons.cloud_done_outlined
            : Icons.hub_outlined;

    final badgeLabel = config.usesApi
        ? (registry.hasFallbacks ? 'API + fallback' : 'API workspace')
        : 'Mock workspace';

    return _BackendHeaderInfo(
      badgeLabel: badgeLabel,
      icon: icon,
      summary: registry.summaryLabel,
      modeLabel: config.statusLabel,
      coverageLabel: '${registry.registrations.length} modules registered',
      endpointLabel: config.hasBaseUrl ? config.baseUrl! : config.detailLabel,
      fallbackLabel: config.allowMockFallback
          ? 'Mock fallback allowed'
          : 'Live responses only',
    );
  }
}
