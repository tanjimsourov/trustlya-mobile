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
import '../cubit/market_cubit.dart';
import '../cubit/market_state.dart';
import '../widgets/item_card.dart';

/// Market browse page listing all available game items. Users can search,
/// filter by rarity, sort by price or wear and toggle between grid and
/// list views. Items can be tapped to view details. Uses [MarketCubit]
/// to fetch the combined list of market items from the repository.
class MarketPage extends StatefulWidget {
  const MarketPage({Key? key}) : super(key: key);

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
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
    Future.microtask(() => context.read<MarketCubit>().loadMarket());
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Item> _applyFilters(List<Item> items) {
    var filtered = List<Item>.from(items);
    // Filter by rarity
    if (_filterIndex > 0) {
      final rarity = _rarityFilters[_filterIndex].toLowerCase();
      filtered = filtered
          .where((item) => item.rarity.toLowerCase() == rarity)
          .toList();
    }
    // Search
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered
          .where((item) => item.name.toLowerCase().contains(query))
          .toList();
    }
    // Sort
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
    return BlocProvider<MarketCubit>(
      create: (_) => getIt<MarketCubit>(),
      child: BlocBuilder<MarketCubit, MarketState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const LoadingWidget();
          }
          if (state.status == Status.error) {
            return shared.ErrorWidgetView(message: state.message);
          }
          if (state.status == Status.empty) {
            return AppScaffold(
              appBar: AppBar(title: const Text('Market')),
              body: const EmptyWidget(message: 'No items found'),
            );
          }
          if (state.status == Status.success && state.data != null) {
            final items = _applyFilters(List<Item>.from(state.data!));
            return AppScaffold(
              appBar: AppBar(
                title: const Text('Market'),
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
                      SearchField(controller: _searchController),
                      const SizedBox(height: AppSpacing.md),
                      FilterRow(
                        options: _rarityFilters,
                        selectedIndex: _filterIndex,
                        onSelected: (i) {
                          setState(() {
                            _filterIndex = i;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
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
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
