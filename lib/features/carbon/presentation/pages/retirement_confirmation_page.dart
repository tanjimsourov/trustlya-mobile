import 'package:flutter/material.dart';

import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../domain/entities/carbon_transaction.dart';

class RetirementConfirmationPage extends StatelessWidget {
  final CarbonTransaction transaction;

  const RetirementConfirmationPage({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SingleChildScrollView(
        child: ResponsivePageWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(
                eyebrow: 'Retirement confirmed',
                title: 'Carbon retirement recorded',
                subtitle:
                    'The retirement request has been completed and an auditable record is now available for reporting and portfolio review.',
                metadata: const [
                  StatusBadge(label: 'Completed', tone: AppTone.success),
                  StatusBadge(label: 'Audit ready', tone: AppTone.primary),
                ],
              ),
              const SectionSpacing(),
              KpiStrip(
                children: [
                  MetricCard(
                    title: 'Project',
                    value: 'Recorded',
                    icon: Icons.eco_outlined,
                    footer: transaction.projectName,
                  ),
                  MetricCard(
                    title: 'Retired quantity',
                    value: transaction.quantity.toStringAsFixed(2),
                    icon: Icons.assignment_turned_in_outlined,
                    iconColor: AppColorsDS.success,
                  ),
                  MetricCard(
                    title: 'Recorded value',
                    value: AppFormatters.currency(
                      transaction.total,
                      symbol: '\$',
                      decimals: 2,
                      symbolFirst: true,
                    ),
                    icon: Icons.payments_outlined,
                    iconColor: AppColorsDS.secondary,
                  ),
                  MetricCard(
                    title: 'Reference',
                    value: transaction.id,
                    icon: Icons.tag_outlined,
                    iconColor: AppColorsDS.warning,
                  ),
                ],
              ),
              const SectionSpacing(),
              SectionCard(
                title: 'Retirement record',
                subtitle:
                    'Summary information that can be referenced in downstream reporting.',
                child: Wrap(
                  spacing: AppSpacing.xl,
                  runSpacing: AppSpacing.md,
                  children: [
                    InfoPair(label: 'Project', value: transaction.projectName),
                    InfoPair(
                        label: 'Status',
                        value: AppFormatters.titleCase(transaction.status)),
                    InfoPair(
                        label: 'Date',
                        value: AppFormatters.dateTimeShort(transaction.date)),
                    InfoPair(
                        label: 'Type',
                        value: AppFormatters.titleCase(transaction.type)),
                  ],
                ),
              ),
              const SectionSpacing(),
              const InsightBanner(
                title: 'What happens next',
                description:
                    'The retired position is removed from active inventory and remains available in history and analytics for audit and sustainability reporting.',
                icon: Icons.fact_check_outlined,
                tone: AppTone.info,
              ),
              const SectionSpacing(),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  SizedBox(
                    width: 180,
                    child: PrimaryButton(
                      label: 'View holdings',
                      onPressed: () =>
                          Navigator.of(context).pushNamedAndRemoveUntil(
                        Routes.carbonHoldings,
                        (route) =>
                            route.isFirst ||
                            route.settings.name == Routes.shell,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: GhostButton(
                      label: 'Open history',
                      onPressed: () =>
                          Navigator.of(context).pushNamed(Routes.carbonHistory),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: GhostButton(
                      label: 'Dashboard',
                      onPressed: () =>
                          Navigator.of(context).pushNamedAndRemoveUntil(
                        Routes.carbonDashboard,
                        (route) =>
                            route.isFirst ||
                            route.settings.name == Routes.shell,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
