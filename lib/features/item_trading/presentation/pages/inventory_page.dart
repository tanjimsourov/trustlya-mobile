import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/filter_row.dart';
import '../../../../shared/widgets/inputs.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/chips.dart';
import '../../domain/entities/item.dart';
import '../cubit/inventory_cubit.dart';
import '../cubit/inventory_state.dart';
import '../widgets/item_card.dart';

/// Displays the user’s inventory of game items. Provides search,
/// filtering by rarity, sorting and a grid/list toggle. Uses
/// [InventoryCubit] to load mock data from the repository. When no
/// items are available, an empty state is shown. Errors are
/// communicated via the shared error widget.
class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final TextEditingController _searchController = TextEditingController();
  int _filterIndex = 0;
  int _sortIndex = 0;
  bool _gridView = true;

  final List<String> _rarityFilters = [
    'All',
    'Covert',
    'Classified',
    'Restricted',
    'Common'
  ];
  final List<String> _sortOptions = [
    'Price: High to Low',
    'Price: Low to High',
    'Wear: Low to High',
    'Wear: High to Low',
  ];

  @override
  void initState() {
    super.initState();
    // Load inventory when the page is first built
    Future.microtask(() => context.read<InventoryCubit>().loadInventory());
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Applies the current search, filter and sort settings to the given list
  /// of items. Returns a new list that matches the UI controls.
  List<Item> _applyFilters(List<Item> items) {
    var filtered = List<Item>.from(items);
    // Filter by rarity if not the 'All' option
    if (_filterIndex > 0) {
      final rarity = _rarityFilters[_filterIndex].toLowerCase();
      filtered = filtered
          .where((item) => item.rarity.toLowerCase() == rarity)
          .toList();
    }
    // Filter by search query
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered
          .where((item) => item.name.toLowerCase().contains(query))
          .toList();
    }
    // Sort according to selected option
    switch (_sortIndex) {
      case 0:
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 1:
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 2:
        filtered.sort((a, b) => a.wear.compareTo(b.wear));
        break;
      case 3:
        filtered.sort((a, b) => b.wear.compareTo(a.wear));
        break;
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InventoryCubit>(
      create: (_) => getIt<InventoryCubit>(),
      child: BlocBuilder<InventoryCubit, InventoryState>(
        builder: (context, state) {
          // Loading state
          if (state.status == Status.loading) {
            return const LoadingWidget();
          }
          // Error state
          if (state.status == Status.error) {
            return shared.ErrorWidgetView(message: state.message);
          }
          // Empty state
          if (state.status == Status.empty) {
            return AppScaffold(
              appBar: AppBar(title: const Text('Inventory')),
              body: const EmptyWidget(message: 'Your inventory is empty'),
            );
          }
          // Success state
          if (state.status == Status.success && state.data != null) {
            final items = _applyFilters(List<Item>.from(state.data!));
            return AppScaffold(
              appBar: AppBar(
                title: const Text('Inventory'),
                actions: [
                  IconButton(
                    icon: Icon(_gridView ? Icons.view_list : Icons.grid_view),
                    onPressed: () {
                      setState(() {
                        _gridView = !_gridView;
                      });
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search field
                      SearchField(controller: _searchController),
                      const SizedBox(height: AppSpacing.md),
                      // Filter row
                      FilterRow(
                        options: _rarityFilters,
                        selectedIndex: _filterIndex,
                        onSelected: (index) {
                          setState(() {
                            _filterIndex = index;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Sort dropdown and item count
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownButton<int>(
                            value: _sortIndex,
                            items: List.generate(_sortOptions.length, (index) {
                              return DropdownMenuItem<int>(
                                value: index,
                                child: Text(
                                  _sortOptions[index],
                                  style: AppTypography.body2,
                                ),
                              );
                            }),
                            onChanged: (value) {
                              setState(() {
                                _sortIndex = value ?? 0;
                              });
                            },
                          ),
                          Text(
                            '${items.length} items',
                            style: AppTypography.caption
                                .copyWith(color: AppColorsDS.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Grid or list view
                      _gridView
                          ? AdaptiveGrid(
                              itemCount: items.length,
                              minCellWidth: 160,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return ItemCard(
                                  item: item,
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        Routes.itemDetail,
                                        arguments: item.id);
                                  },
                                );
                              },
                            )
                          : Column(
                              children: items
                                  .map(
                                    (item) => Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: AppSpacing.md),
                                      child: AppCard(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              Routes.itemDetail,
                                              arguments: item.id);
                                        },
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                item.imageUrl,
                                                height: 60,
                                                width: 60,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    Container(
                                                  height: 60,
                                                  width: 60,
                                                  color: AppColorsDS.surface,
                                                  child: const Icon(Icons
                                                      .image_not_supported),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                                width: AppSpacing.md),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(item.name,
                                                      style: AppTypography
                                                          .subtitle1),
                                                  const SizedBox(height: 2),
                                                  AppChip(
                                                    label: item.rarity,
                                                    selected: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    textColor:
                                                        AppColorsDS.primary,
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    'Wear: ${item.wear.toStringAsFixed(2)}',
                                                    style: AppTypography.caption
                                                        .copyWith(
                                                            color: AppColorsDS
                                                                .textSecondary),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              '\$${item.price.toStringAsFixed(0)}',
                                              style: AppTypography.subtitle1
                                                  .copyWith(
                                                      color:
                                                          AppColorsDS.primary),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                    ],
                  ),
                ),
              ),
            );
          }
          // Fallback placeholder
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
