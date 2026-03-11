import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
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
import '../cubit/swap_cubit.dart';
import '../cubit/swap_state.dart';
import 'withdraw_page.dart';

class SwapPage extends StatefulWidget {
  const SwapPage({Key? key}) : super(key: key);

  @override
  State<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SwapCubit>(
      create: (_) => getIt<SwapCubit>()..init(),
      child: BlocConsumer<SwapCubit, SwapState>(
        listener: (context, state) {
          if (state.status == Status.error && state.message != null) {
            showAppSnackBar(context, message: state.message!);
          }
          if (state.status == Status.success && state.data?.submitted == true) {
            final data = state.data!;
            Navigator.of(context).pushNamed(
              Routes.transferConfirmation,
              arguments: TransferConfirmationArgs(
                type: 'swap',
                symbol: '${data.fromSymbol}/${data.toSymbol}',
                network: 'internal',
                destination: '',
                amount: data.amount,
                fee: 0,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == Status.loading && state.data == null) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading swap workspace'));
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
                      label: 'No swap data', tone: AppTone.neutral)),
            );
          }

          final currentAmount = data.amount == 0 ? '' : data.amount.toString();
          if (_amountController.text != currentAmount) {
            _amountController.text = currentAmount;
          }

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      eyebrow: 'Swap',
                      title: 'Asset conversion workspace',
                      subtitle:
                          'Prepare internal asset conversions with balance-backed pricing and operational confirmation before submission.',
                    ),
                    const SectionSpacing(),
                    SectionCard(
                      title: 'Swap parameters',
                      subtitle:
                          'Select the source asset, target asset, and requested conversion amount.',
                      child: Column(
                        children: [
                          AppDropdown<String>(
                            value: data.fromSymbol,
                            items: data.availableSymbols
                                .map((symbol) => DropdownMenuItem(
                                    value: symbol, child: Text(symbol)))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                context.read<SwapCubit>().updateFrom(value);
                              }
                            },
                            hint: 'From asset',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppDropdown<String>(
                            value: data.toSymbol,
                            items: data.availableSymbols
                                .map((symbol) => DropdownMenuItem(
                                    value: symbol, child: Text(symbol)))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                context.read<SwapCubit>().updateTo(value);
                              }
                            },
                            hint: 'To asset',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AmountInput(
                            controller: _amountController,
                            hintText: 'Amount',
                            onChanged: (value) {
                              final parsed = double.tryParse(value) ?? 0;
                              context.read<SwapCubit>().updateAmount(parsed);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SectionSpacing(),
                    SectionCard(
                      title: 'Conversion output',
                      subtitle:
                          'Indicative conversion values based on current mock pricing.',
                      child: Row(
                        children: [
                          Expanded(
                            child: InfoPair(
                              label: 'Indicative rate',
                              value:
                                  '1 ${data.fromSymbol} ≈ ${data.rate.toStringAsFixed(4)} ${data.toSymbol}',
                            ),
                          ),
                          Expanded(
                            child: InfoPair(
                              label: 'Estimated output',
                              value:
                                  '${data.toAmount.toStringAsFixed(4)} ${data.toSymbol}',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SectionSpacing(),
                    const InsightBanner(
                      title: 'Operational note',
                      description:
                          'Swaps settle internally in this mock environment and still require downstream balance reconciliation.',
                      icon: Icons.sync_alt,
                      tone: AppTone.info,
                    ),
                    const SectionSpacing(),
                    PrimaryButton(
                      label: state.status == Status.loading
                          ? 'Submitting'
                          : 'Submit swap',
                      loading: state.status == Status.loading &&
                          data.submitted == false,
                      disabled:
                          data.amount <= 0 || data.fromSymbol == data.toSymbol,
                      onPressed:
                          (data.amount <= 0 || data.fromSymbol == data.toSymbol)
                              ? null
                              : () => context.read<SwapCubit>().swap(),
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
