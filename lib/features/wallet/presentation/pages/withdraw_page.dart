import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/dialogs.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/inputs.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../cubit/withdraw_cubit.dart';
import '../cubit/withdraw_state.dart';

class WithdrawPage extends StatefulWidget {
  final String symbol;

  const WithdrawPage({Key? key, required this.symbol}) : super(key: key);

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WithdrawCubit>(
      create: (_) => getIt<WithdrawCubit>()..init(widget.symbol),
      child: BlocConsumer<WithdrawCubit, WithdrawState>(
        listener: (context, state) {
          if (state.status == Status.error && state.message != null) {
            showAppSnackBar(context, message: state.message!);
          }
          if (state.status == Status.success && state.data?.submitted == true) {
            final data = state.data!;
            Navigator.of(context).pushNamed(
              Routes.transferConfirmation,
              arguments: TransferConfirmationArgs(
                type: 'withdraw',
                symbol: data.symbol,
                network: data.selectedNetwork,
                destination: data.destination,
                amount: data.amount,
                fee: data.fee,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == Status.loading && state.data == null) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading withdrawal form'));
          }

          if (state.status == Status.error && state.data == null) {
            return AppScaffold(
                body: shared.ErrorWidgetView(message: state.message));
          }

          final data = state.data;
          if (data == null) {
            return const AppScaffold(
              body: Center(
                  child: StatusBadge(
                      label: 'No withdrawal data', tone: AppTone.neutral)),
            );
          }

          if (_addressController.text != data.destination) {
            _addressController.text = data.destination;
          }
          final amountText = data.amount == 0 ? '' : data.amount.toString();
          if (_amountController.text != amountText) {
            _amountController.text = amountText;
          }

          final disabled = data.amount <= 0 ||
              data.amount > data.balance ||
              data.destination.isEmpty;

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Withdraw',
                      title: 'Outbound transfer for ${widget.symbol}',
                      subtitle:
                          'Prepare a controlled outbound movement with route selection, address validation, and fee visibility before submission.',
                      metadata: [
                        StatusBadge(
                            label: data.selectedNetwork, tone: AppTone.primary)
                      ],
                    ),
                    const SectionSpacing(),
                    SectionCard(
                      title: 'Transfer route',
                      subtitle:
                          'Choose the network approved for this withdrawal.',
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
                            context.read<WithdrawCubit>().selectNetwork(value);
                          }
                        },
                      ),
                    ),
                    const SectionSpacing(),
                    SectionCard(
                      title: 'Destination details',
                      subtitle:
                          'Provide the validated receiving address and requested amount.',
                      child: Column(
                        children: [
                          AppTextField(
                            controller: _addressController,
                            labelText: 'Destination address',
                            hintText: '0x...',
                            onChanged: (value) => context
                                .read<WithdrawCubit>()
                                .updateDestination(value),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AmountInput(
                            controller: _amountController,
                            hintText: 'Amount',
                            onChanged: (value) {
                              final parsed = double.tryParse(value) ?? 0;
                              context
                                  .read<WithdrawCubit>()
                                  .updateAmount(parsed);
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GhostButton(
                              label: 'Use max balance',
                              fullWidth: false,
                              onPressed: () {
                                _amountController.text =
                                    data.balance.toString();
                                context
                                    .read<WithdrawCubit>()
                                    .updateAmount(data.balance);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SectionSpacing(),
                    SectionCard(
                      title: 'Transfer summary',
                      subtitle:
                          'Review balance and fee impact before submission.',
                      child: Row(
                        children: [
                          Expanded(
                            child: InfoPair(
                              label: 'Available balance',
                              value: data.balance.toStringAsFixed(4),
                            ),
                          ),
                          Expanded(
                            child: InfoPair(
                              label: 'Estimated fee',
                              value: data.fee.toStringAsFixed(6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SectionSpacing(),
                    InsightBanner(
                      title: 'Transfer control',
                      description:
                          'Ensure the destination address is correct and compatible with ${data.selectedNetwork}. Route mismatches may be irrecoverable.',
                      icon: Icons.shield_outlined,
                      tone: AppTone.warning,
                    ),
                    const SectionSpacing(),
                    PrimaryButton(
                      label: state.status == Status.loading
                          ? 'Submitting'
                          : 'Submit withdrawal',
                      loading: state.status == Status.loading &&
                          data.submitted == false,
                      disabled: disabled,
                      onPressed: disabled
                          ? null
                          : () => context.read<WithdrawCubit>().submit(),
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

class TransferConfirmationArgs {
  final String type;
  final String symbol;
  final String network;
  final String destination;
  final double amount;
  final double fee;

  TransferConfirmationArgs({
    required this.type,
    required this.symbol,
    required this.network,
    required this.destination,
    required this.amount,
    required this.fee,
  });
}
