import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/dialogs.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/item_trading_repository.dart';
import '../cubit/trade_builder_cubit.dart';
import '../cubit/trade_builder_state.dart';

/// Page for composing a new trade. The user selects items from their
/// inventory to offer and items from the market to request. The
/// [TradeBuilderCubit] maintains the offered and requested lists and
/// calculates totals and whether the trade is allowed. A trade is
/// allowed if the offered value is at least 90% of the requested
/// value. Once ready the user can proceed to the review page.
class TradeBuilderPage extends StatefulWidget {
  const TradeBuilderPage({Key? key}) : super(key: key);

  @override
  State<TradeBuilderPage> createState() => _TradeBuilderPageState();
}

class _TradeBuilderPageState extends State<TradeBuilderPage> {
  Future<void> _selectItem(BuildContext context, bool offered) async {
    final repo = getIt<ItemTradingRepository>();
    Result<List<Item>> result;
    if (offered) {
      result = await repo.getInventory();
    } else {
      result = await repo.getMarketItems();
    }
    if (result is Success<List<Item>>) {
      final items = result.value;
      final Item? selected = await showModalBottomSheet<Item>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return DraggableScrollableSheet(
            initialChildSize: 0.8,
            maxChildSize: 0.95,
            minChildSize: 0.5,
            builder: (_, controller) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColorsDS.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              offered
                                  ? 'Select Offered Item'
                                  : 'Select Requested Item',
                              style: AppTypography.h4),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        controller: controller,
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppSpacing.md,
                          mainAxisSpacing: AppSpacing.md,
                          childAspectRatio: 3 / 4,
                        ),
                        itemCount: items.length,
                        itemBuilder: (_, index) {
                          final item = items[index];
                          return AppCard(
                            onTap: () => Navigator.of(ctx).pop(item),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.imageUrl,
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      height: 100,
                                      width: double.infinity,
                                      color: AppColorsDS.surface,
                                      child:
                                          const Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(item.name,
                                    style: AppTypography.subtitle1,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 2),
                                Text('\$${item.price.toStringAsFixed(0)}',
                                    style: AppTypography.body2
                                        .copyWith(color: AppColorsDS.primary)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
      if (selected != null) {
        final cubit = context.read<TradeBuilderCubit>();
        if (offered) {
          cubit.addOffered(selected);
        } else {
          cubit.addRequested(selected);
        }
      }
    } else if (result is Error<List<Item>>) {
      showAppSnackBar(context,
          message: result.message ?? 'Failed to load items');
    }
  }

  Widget _buildSide({
    required String title,
    required List<Item> items,
    required VoidCallback onAdd,
    required bool offered,
    required TradeBuilderCubit cubit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTypography.subtitle1),
            TextButton(
              onPressed: onAdd,
              child: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (items.isEmpty)
          Text('No items',
              style: AppTypography.body2
                  .copyWith(color: AppColorsDS.textSecondary))
        else
          Column(
            children: items
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: AppCard(
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.imageUrl,
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 40,
                                  width: 40,
                                  color: AppColorsDS.surface,
                                  child: const Icon(Icons.image_not_supported,
                                      size: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, style: AppTypography.body1),
                                  Text('\$${item.price.toStringAsFixed(0)}',
                                      style: AppTypography.caption.copyWith(
                                          color: AppColorsDS.textSecondary)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: AppColorsDS.danger),
                              onPressed: () {
                                if (offered) {
                                  cubit.removeOffered(item);
                                } else {
                                  cubit.removeRequested(item);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildCenter(TradeBuilderState state) {
    final diff = state.offeredValue - state.requestedValue;
    final diffColor = diff >= 0 ? AppColorsDS.success : AppColorsDS.danger;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Summary', style: AppTypography.subtitle1),
        const SizedBox(height: AppSpacing.sm),
        Text('Offered: \$${state.offeredValue.toStringAsFixed(0)}',
            style: AppTypography.body1),
        Text('Requested: \$${state.requestedValue.toStringAsFixed(0)}',
            style: AppTypography.body1),
        Text(
            'Difference: ${diff >= 0 ? '+' : ''}\$${diff.abs().toStringAsFixed(0)}',
            style: AppTypography.body1.copyWith(color: diffColor)),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Icon(
              state.tradeAllowed ? Icons.check_circle : Icons.error,
              color:
                  state.tradeAllowed ? AppColorsDS.success : AppColorsDS.danger,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                state.tradeAllowed ? 'Trade allowed' : 'Trade not allowed',
                style: AppTypography.body2.copyWith(
                    color: state.tradeAllowed
                        ? AppColorsDS.success
                        : AppColorsDS.danger),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TradeBuilderCubit>(
      create: (_) => getIt<TradeBuilderCubit>(),
      child: BlocBuilder<TradeBuilderCubit, TradeBuilderState>(
        builder: (context, state) {
          final cubit = context.read<TradeBuilderCubit>();
          return AppScaffold(
            appBar: AppBar(title: const Text('Build Trade'), actions: [
              IconButton(
                icon: const Icon(Icons.clear_all),
                tooltip: 'Clear',
                onPressed: () => cubit.clear(),
              ),
            ]),
            body: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 800;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildSide(
                                  title: 'Your Offer',
                                  items: state.offered,
                                  onAdd: () => _selectItem(context, true),
                                  offered: true,
                                  cubit: cubit,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.lg),
                              Container(
                                width: 200,
                                padding: const EdgeInsets.all(AppSpacing.md),
                                decoration: BoxDecoration(
                                  color: AppColorsDS.surface,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: _buildCenter(state),
                              ),
                              const SizedBox(width: AppSpacing.lg),
                              Expanded(
                                child: _buildSide(
                                  title: 'Requested',
                                  items: state.requested,
                                  onAdd: () => _selectItem(context, false),
                                  offered: false,
                                  cubit: cubit,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSide(
                                title: 'Your Offer',
                                items: state.offered,
                                onAdd: () => _selectItem(context, true),
                                offered: true,
                                cubit: cubit,
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              _buildSide(
                                title: 'Requested',
                                items: state.requested,
                                onAdd: () => _selectItem(context, false),
                                offered: false,
                                cubit: cubit,
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(AppSpacing.md),
                                decoration: BoxDecoration(
                                  color: AppColorsDS.surface,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: _buildCenter(state),
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              child: PrimaryButton(
                label: 'Review Trade',
                onPressed: state.tradeAllowed &&
                        state.offered.isNotEmpty &&
                        state.requested.isNotEmpty
                    ? () {
                        Navigator.of(context)
                            .pushNamed(Routes.tradeReview, arguments: state);
                      }
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
