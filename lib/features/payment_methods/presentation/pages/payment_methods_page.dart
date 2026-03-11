import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/page_header.dart';
import '../../domain/entities/payment_method.dart';
import '../cubit/payment_methods_cubit.dart';
import '../cubit/payment_methods_state.dart';

/// Displays all payment methods associated with the user. Shows
/// cards for each method and provides an action to add a new one.
class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaymentMethodsCubit>(
      create: (_) => getIt<PaymentMethodsCubit>()..loadMethods(),
      child: BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
        builder: (context, state) {
          Widget body;
          switch (state.status) {
            case Status.loading:
              body = const LoadingWidget(label: 'Loading payment methods');
              break;
            case Status.error:
              body = shared.ErrorWidgetView(message: state.message);
              break;
            case Status.empty:
              body = const EmptyWidget(message: 'No payment methods added');
              break;
            case Status.success:
              final methods = state.data!;
              body = SingleChildScrollView(
                child: ResponsivePageWrapper(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PageHeader(
                        eyebrow: 'Payment methods',
                        title: 'Operational payment and settlement methods',
                        subtitle:
                            'Review cards, banks, wallets, and crypto bridges with clearer brand cues and routing context.',
                        metadata: [
                          const StatusBadge(
                            label: 'Brand-aware methods',
                            tone: AppTone.primary,
                          ),
                          StatusBadge(
                            label: '${methods.length} active methods',
                            tone: AppTone.info,
                          ),
                        ],
                      ),
                      const SectionSpacing(),
                      SectionCard(
                        title: 'Connected methods',
                        subtitle:
                            'Stored methods are presented with branded rail badges for faster operator recognition.',
                        child: Column(
                          children: List.generate(methods.length, (index) {
                            final method = methods[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == methods.length - 1
                                    ? 0
                                    : AppSpacing.md,
                              ),
                              child: PaymentMethodCard(
                                provider: method.provider,
                                type: method.type,
                                maskedNumber: method.maskedNumber.isNotEmpty
                                    ? method.maskedNumber
                                    : method.type.toUpperCase(),
                                expiryDate: method.expiryDate,
                                isDefault: method.isDefault,
                                onTap: () {
                                  // In future allow editing of payment method
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              break;
            default:
              body = Center(
                child: ElevatedButton(
                  onPressed: () =>
                      context.read<PaymentMethodsCubit>().loadMethods(),
                  child: const Text('Load Methods'),
                ),
              );
          }
          return AppScaffold(
            body: body,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.addPaymentMethod);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Method'),
            ),
          );
        },
      ),
    );
  }
}
