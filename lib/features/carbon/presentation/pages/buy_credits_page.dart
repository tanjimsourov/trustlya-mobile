import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/dialogs.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/inputs.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../cubit/project_detail_cubit.dart';
import '../cubit/project_detail_state.dart';

class BuyCreditsPage extends StatefulWidget {
  final String projectId;

  const BuyCreditsPage({Key? key, required this.projectId}) : super(key: key);

  @override
  State<BuyCreditsPage> createState() => _BuyCreditsPageState();
}

class _BuyCreditsPageState extends State<BuyCreditsPage> {
  final TextEditingController _quantityController = TextEditingController();
  bool _purchasePending = false;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectDetailCubit>(
      create: (_) => getIt<ProjectDetailCubit>()..load(widget.projectId),
      child: BlocConsumer<ProjectDetailCubit, ProjectDetailState>(
        listener: (context, state) async {
          if (_purchasePending &&
              state.status == Status.error &&
              state.message != null) {
            setState(() => _purchasePending = false);
            showAppSnackBar(context, message: state.message!);
          }

          if (_purchasePending &&
              state.status == Status.success &&
              state.data != null) {
            setState(() => _purchasePending = false);
            final quantity = double.tryParse(_quantityController.text) ?? 0;
            await showSuccessDialog(
              context,
              title: 'Purchase booked',
              message:
                  'The requested ${quantity.toStringAsFixed(2)} credits were added to your holdings for settlement and future retirement.',
            );
            if (context.mounted) {
              Navigator.of(context).pushReplacementNamed(Routes.carbonHoldings);
            }
          }
        },
        builder: (context, state) {
          if (state.status == Status.loading && state.data == null) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading purchase workspace'));
          }

          if (state.status == Status.error && state.data == null) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () =>
                    context.read<ProjectDetailCubit>().load(widget.projectId),
              ),
            );
          }

          final project = state.data;
          if (project == null) {
            return const AppScaffold(
              body: EmptyWidget(
                title: 'Project unavailable',
                message:
                    'The selected project is no longer available for purchase.',
                icon: Icons.shopping_cart_outlined,
              ),
            );
          }

          final quantity = double.tryParse(_quantityController.text) ?? 0;
          final total = quantity * project.pricePerCredit;
          final disabled = quantity <= 0 || quantity > project.availableCredits;

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Credit purchase',
                      title: 'Acquire ${project.name}',
                      subtitle:
                          'Confirm quantity, review indicative spend, and book verified credits into holdings with full pricing and inventory context.',
                      metadata: [
                        StatusBadge(
                            label: project.category, tone: AppTone.primary),
                        StatusBadge(
                          label:
                              '${AppFormatters.compactNumber(project.availableCredits)} available',
                          tone: AppTone.success,
                        ),
                      ],
                      actions: [
                        SizedBox(
                          width: 170,
                          child: GhostButton(
                            label: 'Project detail',
                            onPressed: () => Navigator.of(context).pushNamed(
                              Routes.carbonProjectDetail,
                              arguments: project.id,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    KpiStrip(
                      children: [
                        MetricCard(
                          title: 'Unit price',
                          value: AppFormatters.currency(
                            project.pricePerCredit,
                            symbol: '\$',
                            decimals: 2,
                            symbolFirst: true,
                          ),
                          icon: Icons.sell_outlined,
                        ),
                        MetricCard(
                          title: 'Projected spend',
                          value: AppFormatters.currency(
                            total,
                            symbol: '\$',
                            decimals: 2,
                            symbolFirst: true,
                          ),
                          icon: Icons.payments_outlined,
                          iconColor: AppColorsDS.secondary,
                        ),
                        MetricCard(
                          title: 'Inventory',
                          value: AppFormatters.compactNumber(
                              project.availableCredits),
                          icon: Icons.inventory_2_outlined,
                          iconColor: AppColorsDS.success,
                        ),
                        MetricCard(
                          title: 'Registry labels',
                          value: '${project.badges.length}',
                          icon: Icons.verified_outlined,
                          iconColor: AppColorsDS.warning,
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    if (project.availableCredits <= 0)
                      const EmptyWidget(
                        title: 'Project inventory exhausted',
                        message:
                            'This project has no immediately available credits. Browse the marketplace to source another position.',
                        icon: Icons.inventory_2_outlined,
                      )
                    else
                      SectionCard(
                        title: 'Purchase parameters',
                        subtitle:
                            'Enter the number of credits to acquire and review the business context.',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AmountInput(
                              controller: _quantityController,
                              hintText: 'Credit quantity',
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Wrap(
                              spacing: AppSpacing.xl,
                              runSpacing: AppSpacing.md,
                              children: [
                                InfoPair(
                                    label: 'Location', value: project.location),
                                InfoPair(
                                  label: 'Indicative spend',
                                  value: AppFormatters.currency(
                                    total,
                                    symbol: '\$',
                                    decimals: 2,
                                    symbolFirst: true,
                                  ),
                                ),
                                InfoPair(
                                  label: 'Available inventory',
                                  value: AppFormatters.compactNumber(
                                      project.availableCredits),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            const InsightBanner(
                              title: 'Settlement note',
                              description:
                                  'Purchased credits are booked into holdings for subsequent reporting and retirement workflows. This mock flow represents a confirmed marketplace allocation.',
                              icon: Icons.approval_outlined,
                              tone: AppTone.info,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Row(
                              children: [
                                Expanded(
                                  child: PrimaryButton(
                                    label: _purchasePending
                                        ? 'Submitting'
                                        : 'Submit purchase',
                                    loading: _purchasePending &&
                                        state.status == Status.loading,
                                    disabled: disabled,
                                    onPressed: disabled
                                        ? null
                                        : () async {
                                            final confirm =
                                                await showConfirmationDialog(
                                              context,
                                              title: 'Confirm purchase',
                                              message:
                                                  'Purchase ${quantity.toStringAsFixed(2)} credits from ${project.name} for ${AppFormatters.currency(total, symbol: '\$', decimals: 2, symbolFirst: true)}?',
                                              confirmLabel: 'Purchase',
                                            );
                                            if (confirm == true &&
                                                context.mounted) {
                                              setState(() =>
                                                  _purchasePending = true);
                                              context
                                                  .read<ProjectDetailCubit>()
                                                  .buy(quantity);
                                            }
                                          },
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: GhostButton(
                                    label: 'View holdings',
                                    onPressed: () => Navigator.of(context)
                                        .pushNamed(Routes.carbonHoldings),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
