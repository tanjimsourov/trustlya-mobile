import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/dialogs.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/inputs.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../cubit/deposit_cubit.dart';
import '../cubit/deposit_state.dart';

class DepositPage extends StatelessWidget {
  final String symbol;

  const DepositPage({Key? key, required this.symbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DepositCubit>(
      create: (_) => getIt<DepositCubit>()..load(symbol),
      child: BlocBuilder<DepositCubit, DepositState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading deposit instructions'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
                body: shared.ErrorWidgetView(message: state.message));
          }

          final data = state.data;
          if (data == null) {
            return const AppScaffold(
              body: Center(
                  child: StatusBadge(
                      label: 'No deposit data', tone: AppTone.neutral)),
            );
          }

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Deposit',
                      title: 'Fund $symbol operational wallet',
                      subtitle:
                          'Select the supported network, copy the deposit destination, and route funds only through the approved transfer rails shown here.',
                      metadata: [
                        StatusBadge(
                            label: data.selectedNetwork, tone: AppTone.primary),
                      ],
                    ),
                    const SectionSpacing(),
                    SectionCard(
                      title: 'Network selection',
                      subtitle:
                          'Choose the supported route before instructing the transfer.',
                      child: AppDropdown<String>(
                        value: data.selectedNetwork,
                        items: data.networks
                            .map(
                              (network) => DropdownMenuItem(
                                value: network,
                                child: Text(network),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            context.read<DepositCubit>().selectNetwork(value);
                          }
                        },
                      ),
                    ),
                    const SectionSpacing(),
                    SectionCard(
                      title: 'Deposit destination',
                      subtitle:
                          'Use the generated address and QR code for the selected network only.',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WalletAddressCard(
                            address: data.address,
                            onCopy: () {
                              Clipboard.setData(
                                  ClipboardData(text: data.address));
                              showAppSnackBar(context,
                                  message: 'Deposit address copied');
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Center(
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                color: AppColorsDS.surfaceMuted,
                                borderRadius: AppRadii.large,
                              ),
                              child: const Icon(Icons.qr_code_2,
                                  size: 92, color: AppColorsDS.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SectionSpacing(),
                    const InsightBanner(
                      title: 'Transfer control',
                      description:
                          'Send only the selected asset on the selected network. Unsupported assets or routes may result in irrecoverable loss.',
                      icon: Icons.shield_outlined,
                      tone: AppTone.warning,
                    ),
                    if (data.recentStatus != null) ...[
                      const SectionSpacing(height: AppSpacing.md),
                      SectionCard(
                        title: 'Most recent status',
                        subtitle: 'Latest transfer-related system note.',
                        child: Text(data.recentStatus!),
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
