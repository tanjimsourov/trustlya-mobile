import 'package:flutter/material.dart';

import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/page_header.dart';
import 'withdraw_page.dart';

class TransferConfirmationPage extends StatelessWidget {
  final TransferConfirmationArgs args;

  const TransferConfirmationPage({Key? key, required this.args})
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
                eyebrow: 'Transfer submitted',
                title:
                    '${args.type[0].toUpperCase()}${args.type.substring(1)} confirmation',
                subtitle:
                    'The transfer request has been recorded. Use the summary below for operational reference and downstream reconciliation.',
                metadata: const [
                  StatusBadge(label: 'Submitted', tone: AppTone.success)
                ],
              ),
              const SectionSpacing(),
              SectionCard(
                title: 'Transfer summary',
                subtitle:
                    'Submitted payload captured for the transfer workflow.',
                child: Column(
                  children: [
                    _DetailRow(label: 'Type', value: args.type),
                    _DetailRow(label: 'Asset', value: args.symbol),
                    if (args.network.isNotEmpty)
                      _DetailRow(label: 'Network', value: args.network),
                    if (args.destination.isNotEmpty)
                      _DetailRow(label: 'Destination', value: args.destination),
                    _DetailRow(
                        label: 'Amount', value: args.amount.toStringAsFixed(4)),
                    _DetailRow(
                        label: 'Fee', value: args.fee.toStringAsFixed(6)),
                  ],
                ),
              ),
              const SectionSpacing(),
              const InsightBanner(
                title: 'Operational note',
                description:
                    'Network confirmation time, compliance checks, or linked payout validation may affect final completion timing.',
                icon: Icons.fact_check_outlined,
                tone: AppTone.info,
              ),
              const SectionSpacing(),
              PrimaryButton(
                label: 'Back to wallet',
                onPressed: () {
                  Navigator.of(context).popUntil(
                    (route) =>
                        route.settings.name == Routes.walletOverview ||
                        route.isFirst,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.mdSm),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.body2)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTypography.subtitle2
                  .copyWith(color: AppColorsDS.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
