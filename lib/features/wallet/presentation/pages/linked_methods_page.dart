import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/dialogs.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/payment_brand_badge.dart';
import '../../domain/entities/linked_method.dart';
import '../cubit/linked_methods_cubit.dart';
import '../cubit/linked_methods_state.dart';

class LinkedMethodsPage extends StatelessWidget {
  const LinkedMethodsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LinkedMethodsCubit>(
      create: (_) => getIt<LinkedMethodsCubit>()..load(),
      child: BlocBuilder<LinkedMethodsCubit, LinkedMethodsState>(
        builder: (context, state) {
          final methods = state.data ?? const <LinkedMethod>[];
          final verifiedCount =
              methods.where((method) => method.verified).length;
          final defaultMethod = methods.cast<LinkedMethod?>().firstWhere(
                (method) => method?.isDefault ?? false,
                orElse: () => null,
              );

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Linked methods',
                      title: 'Payout and treasury method controls',
                      subtitle:
                          'Manage bank, card, and wallet methods used for fiat settlement and withdrawal routing across the operational wallet stack.',
                      metadata: const [
                        StatusBadge(
                            label: 'Method governance', tone: AppTone.primary),
                        StatusBadge(
                            label: 'Verification tracking', tone: AppTone.info),
                      ],
                      actions: [
                        SizedBox(
                          width: 180,
                          child: GhostButton(
                            label: 'Fiat rails',
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Routes.fiatRamp),
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: PrimaryButton(
                            label: 'Add method',
                            icon: Icons.add,
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(Routes.addPaymentMethod)
                                  .then((_) {
                                context.read<LinkedMethodsCubit>().load();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    KpiStrip(
                      children: [
                        MetricCard(
                          title: 'Linked methods',
                          value: '${methods.length}',
                          icon: Icons.link_outlined,
                        ),
                        MetricCard(
                          title: 'Verified',
                          value: '$verifiedCount',
                          icon: Icons.verified_outlined,
                          iconColor: AppColorsDS.success,
                        ),
                        MetricCard(
                          title: 'Default route',
                          value: defaultMethod?.provider ?? 'None',
                          icon: Icons.star_outline,
                          iconColor: AppColorsDS.secondary,
                        ),
                        MetricCard(
                          title: 'Method types',
                          value:
                              '${methods.map((method) => method.type).toSet().length}',
                          icon: Icons.category_outlined,
                          iconColor: AppColorsDS.warning,
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    if (state.status == Status.loading && methods.isEmpty)
                      const LoadingWidget(
                          label: 'Loading linked payout methods')
                    else if (state.status == Status.error)
                      shared.ErrorWidgetView(
                        message: state.message,
                        onRetry: () =>
                            context.read<LinkedMethodsCubit>().load(),
                      )
                    else if (methods.isEmpty)
                      EmptyWidget(
                        title: 'No linked methods configured',
                        message:
                            'Add a payout or settlement method to support withdrawals and fiat settlement workflows.',
                        actionLabel: 'Add method',
                        onAction: () {
                          Navigator.of(context)
                              .pushNamed(Routes.addPaymentMethod)
                              .then((_) {
                            context.read<LinkedMethodsCubit>().load();
                          });
                        },
                      )
                    else ...[
                      SectionCard(
                        title: 'Active methods',
                        subtitle:
                            'Linked endpoints used by withdrawal and fiat settlement workflows.',
                        child: Column(
                          children: methods
                              .map(
                                (method) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppSpacing.md),
                                  child: _LinkedMethodCard(method: method),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SectionSpacing(),
                      const InsightBanner(
                        title: 'Control note',
                        description:
                            'Default and verified method visibility should be maintained to reduce routing errors during withdrawals and treasury settlement runs.',
                        icon: Icons.rule_folder_outlined,
                        tone: AppTone.primary,
                      ),
                    ],
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

class _LinkedMethodCard extends StatelessWidget {
  final LinkedMethod method;

  const _LinkedMethodCard({required this.method});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 640;
          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(method.provider, style: AppTypography.h5),
                  ),
                  if (method.verified)
                    const Padding(
                      padding: EdgeInsets.only(left: AppSpacing.sm),
                      child:
                          StatusBadge(label: 'Verified', tone: AppTone.success),
                    ),
                  if (method.isDefault)
                    const Padding(
                      padding: EdgeInsets.only(left: AppSpacing.sm),
                      child:
                          StatusBadge(label: 'Default', tone: AppTone.primary),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xl,
                runSpacing: AppSpacing.md,
                children: [
                  InfoPair(label: 'Type', value: _title(method.type)),
                  InfoPair(label: 'Identifier', value: method.maskedNumber),
                  InfoPair(
                    label: 'Verification',
                    value: method.verified
                        ? 'Ready for settlement'
                        : 'Pending review',
                  ),
                ],
              ),
            ],
          );

          final removeButton = ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: GhostButton(
              label: 'Remove',
              icon: Icons.delete_outline,
              onPressed: () async {
                final confirm = await showConfirmationDialog(
                  context,
                  title: 'Remove linked method',
                  message:
                      'This method will no longer be available for withdrawals or fiat settlement routing.',
                  confirmLabel: 'Remove',
                );
                if (confirm == true && context.mounted) {
                  await context
                      .read<LinkedMethodsCubit>()
                      .removeMethod(method.id);
                }
              },
            ),
          );

          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PaymentBrandBadge(provider: method.provider, type: method.type),
                const SizedBox(height: AppSpacing.md),
                details,
                const SizedBox(height: AppSpacing.md),
                removeButton,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PaymentBrandBadge(provider: method.provider, type: method.type),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: details),
              const SizedBox(width: AppSpacing.md),
              removeButton,
            ],
          );
        },
      ),
    );
  }

  String _title(String type) {
    return type.isEmpty ? type : '${type[0].toUpperCase()}${type.substring(1)}';
  }
}
