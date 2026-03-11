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
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../presentation/cubit/deposit_cubit.dart';
import '../../presentation/cubit/deposit_state.dart';

class ReceivePage extends StatelessWidget {
  final String symbol;

  const ReceivePage({Key? key, required this.symbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DepositCubit>(
      create: (_) => getIt<DepositCubit>()..load(symbol),
      child: BlocBuilder<DepositCubit, DepositState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading receive instructions'));
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
                      label: 'No receive data', tone: AppTone.neutral)),
            );
          }

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Receive',
                      title: 'Receive $symbol',
                      subtitle:
                          'Use this address for inbound transfers on the configured network and distribute it only through approved operational channels.',
                      metadata: [
                        StatusBadge(
                            label: data.selectedNetwork, tone: AppTone.primary)
                      ],
                    ),
                    const SectionSpacing(),
                    SectionCard(
                      title: 'Inbound destination',
                      subtitle:
                          'Address and QR code for the active receiving route.',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          const SizedBox(height: AppSpacing.lg),
                          WalletAddressCard(
                            address: data.address,
                            onCopy: () {
                              Clipboard.setData(
                                  ClipboardData(text: data.address));
                              showAppSnackBar(context,
                                  message: 'Receive address copied');
                            },
                          ),
                        ],
                      ),
                    ),
                    const SectionSpacing(),
                    InsightBanner(
                      title: 'Network restriction',
                      description:
                          'Send only $symbol over ${data.selectedNetwork}. Any other route can leave funds unrecoverable.',
                      icon: Icons.info_outline,
                      tone: AppTone.info,
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
