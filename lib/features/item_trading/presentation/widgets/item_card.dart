import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/chips.dart';
import '../../domain/entities/item.dart';

/// A card displaying a game item’s artwork, name, rarity, wear and
/// price. Tapping the card triggers the optional [onTap] callback.
class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback? onTap;
  const ItemCard({Key? key, required this.item, this.onTap}) : super(key: key);

  Color _rarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'covert':
        return AppColorsDS.primary;
      case 'classified':
        return AppColorsDS.success;
      case 'restricted':
        return AppColorsDS.warning;
      case 'common':
        return AppColorsDS.textSecondary;
      default:
        return AppColorsDS.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColorsDS.surface,
                  child: const Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.name,
            style: AppTypography.subtitle1,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          AppChip(
            label: item.rarity,
            selected: true,
            backgroundColor: _rarityColor(item.rarity).withOpacity(0.1),
            textColor: _rarityColor(item.rarity),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Wear: ${item.wear.toStringAsFixed(2)}',
                  style: AppTypography.caption
                      .copyWith(color: AppColorsDS.textSecondary)),
              Text('\$${item.price.toStringAsFixed(0)}',
                  style: AppTypography.subtitle2
                      .copyWith(color: AppColorsDS.primary)),
            ],
          ),
        ],
      ),
    );
  }
}
