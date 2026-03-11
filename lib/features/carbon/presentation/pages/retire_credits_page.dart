import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
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
import '../../domain/entities/carbon_holding.dart';
import '../../domain/entities/carbon_transaction.dart';
import '../cubit/retire_credits_cubit.dart';
import '../cubit/retire_credits_state.dart';

class RetireCreditsPage extends StatefulWidget {
  const RetireCreditsPage({Key? key}) : super(key: key);

  @override
  State<RetireCreditsPage> createState() => _RetireCreditsPageState();
}

class _RetireCreditsPageState extends State<RetireCreditsPage> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  String? _selectedProjectId;

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RetireCreditsCubit>(
      create: (_) => getIt<RetireCreditsCubit>()..loadHoldings(),
      child: BlocConsumer<RetireCreditsCubit, RetireCreditsState>(
        listener: (context, state) {
          if (state.status == Status.error && state.message != null) {
            showAppSnackBar(context, message: state.message!);
          }
          if (state.status == Status.success &&
              state.data is CarbonTransaction) {
            Navigator.of(context).pushReplacementNamed(
              Routes.carbonRetireConfirm,
              arguments: state.data as CarbonTransaction,
            );
          }
        },
        builder: (context, state) {
          final allHoldings = state.data is List<CarbonHolding>
              ? List<CarbonHolding>.from(state.data as List)
              : const <CarbonHolding>[];
          final activeHoldings = allHoldings
              .where((holding) => !holding.retired && holding.quantity > 0)
              .toList();

          CarbonHolding? selectedHolding;
          if (activeHoldings.isNotEmpty) {
            final selectedId = activeHoldings
                    .any((holding) => holding.projectId == _selectedProjectId)
                ? _selectedProjectId
                : activeHoldings.first.projectId;
            selectedHolding = activeHoldings
                .firstWhere((holding) => holding.projectId == selectedId);
          }

          final quantity = double.tryParse(_quantityController.text) ?? 0;
          final disabled = selectedHolding == null ||
              quantity <= 0 ||
              quantity > selectedHolding.quantity;

          if (state.status == Status.loading && allHoldings.isEmpty) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading retirement workspace'));
          }

          if (state.status == Status.error && allHoldings.isEmpty) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () =>
                    context.read<RetireCreditsCubit>().loadHoldings(),
              ),
            );
          }

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Retirement workflow',
                      title: 'Retire verified carbon credits',
                      subtitle:
                          'Select an active holding, confirm retirement quantity, and create an auditable retirement record for reporting and compliance workflows.',
                      metadata: const [
                        StatusBadge(
                            label: 'Audit ready', tone: AppTone.primary),
                        StatusBadge(
                            label: 'Retirement record', tone: AppTone.success),
                      ],
                      actions: [
                        SizedBox(
                          width: 160,
                          child: GhostButton(
                            label: 'Holdings',
                            onPressed: () => Navigator.of(context)
                                .pushNamed(Routes.carbonHoldings),
                          ),
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    KpiStrip(
                      children: [
                        MetricCard(
                          title: 'Active holdings',
                          value: '${activeHoldings.length}',
                          icon: Icons.inventory_2_outlined,
                        ),
                        MetricCard(
                          title: 'Credits available',
                          value: AppFormatters.compactNumber(
                            activeHoldings.fold<double>(
                                0, (sum, item) => sum + item.quantity),
                          ),
                          icon: Icons.eco_outlined,
                        ),
                        MetricCard(
                          title: 'Selected holding',
                          value: selectedHolding == null ? 'None' : 'Ready',
                          icon: Icons.assignment_turned_in_outlined,
                          footer: selectedHolding?.projectName,
                        ),
                        MetricCard(
                          title: 'Requested retirement',
                          value:
                              quantity == 0 ? '0' : quantity.toStringAsFixed(2),
                          icon: Icons.verified_outlined,
                        ),
                      ],
                    ),
                    const SectionSpacing(),
                    if (activeHoldings.isEmpty)
                      EmptyWidget(
                        title: 'No active positions to retire',
                        message:
                            'Purchase credits first to create an eligible position for retirement.',
                        actionLabel: 'Browse projects',
                        onAction: () => Navigator.of(context)
                            .pushNamed(Routes.carbonProjects),
                      )
                    else
                      SectionCard(
                        title: 'Retirement parameters',
                        subtitle:
                            'Select the holding to retire and provide an optional reporting reason.',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppDropdown<String>(
                              value: selectedHolding?.projectId,
                              items: activeHoldings
                                  .map(
                                    (holding) => DropdownMenuItem(
                                      value: holding.projectId,
                                      child: Text(
                                        '${holding.projectName} (${holding.quantity.toStringAsFixed(2)} credits)',
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _selectedProjectId = value);
                                }
                              },
                              hint: 'Select holding',
                            ),
                            const SizedBox(height: AppSpacing.md),
                            AmountInput(
                              controller: _quantityController,
                              hintText: 'Retirement quantity',
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            AppTextField(
                              controller: _reasonController,
                              labelText: 'Retirement reason',
                              hintText: 'Optional reporting rationale',
                              maxLines: 3,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Wrap(
                              spacing: AppSpacing.xl,
                              runSpacing: AppSpacing.md,
                              children: [
                                InfoPair(
                                    label: 'Project',
                                    value: selectedHolding?.projectName ??
                                        'Not selected'),
                                InfoPair(
                                  label: 'Available quantity',
                                  value: selectedHolding == null
                                      ? '0'
                                      : selectedHolding.quantity
                                          .toStringAsFixed(2),
                                ),
                                InfoPair(
                                  label: 'Indicative value',
                                  value: selectedHolding == null
                                      ? '\$0.00'
                                      : AppFormatters.currency(
                                          quantity *
                                              selectedHolding.pricePerCredit,
                                          symbol: '\$',
                                          decimals: 2,
                                          symbolFirst: true,
                                        ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            const InsightBanner(
                              title: 'Retirement note',
                              description:
                                  'Retirement permanently removes credits from active inventory and creates an auditable record for sustainability and compliance reporting.',
                              icon: Icons.fact_check_outlined,
                              tone: AppTone.info,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Row(
                              children: [
                                Expanded(
                                  child: PrimaryButton(
                                    label: state.status == Status.loading
                                        ? 'Submitting'
                                        : 'Submit retirement',
                                    loading: state.status == Status.loading &&
                                        allHoldings.isNotEmpty,
                                    disabled: disabled,
                                    onPressed: disabled
                                        ? null
                                        : () async {
                                            final confirm =
                                                await showConfirmationDialog(
                                              context,
                                              title: 'Confirm retirement',
                                              message:
                                                  'Retire ${quantity.toStringAsFixed(2)} credits from ${selectedHolding!.projectName}?',
                                              confirmLabel: 'Retire',
                                            );
                                            if (confirm == true &&
                                                context.mounted) {
                                              context
                                                  .read<RetireCreditsCubit>()
                                                  .retire(
                                                    selectedHolding.projectId,
                                                    quantity,
                                                    reason: _reasonController
                                                            .text
                                                            .trim()
                                                            .isEmpty
                                                        ? null
                                                        : _reasonController.text
                                                            .trim(),
                                                  );
                                            }
                                          },
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: GhostButton(
                                    label: 'View history',
                                    onPressed: () => Navigator.of(context)
                                        .pushNamed(Routes.carbonHistory),
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
