import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'motion.dart';
import 'payment_brand_badge.dart';

enum AppTone { neutral, primary, success, warning, danger, info }

class _ToneColors {
  final Color background;
  final Color foreground;

  const _ToneColors(this.background, this.foreground);
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool gradient;
  final Color? borderColor;

  const AppCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.onTap,
    this.gradient = false,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient ? null : AppColorsDS.card,
        gradient: gradient
            ? const LinearGradient(
                colors: [AppColorsDS.primary, AppColorsDS.primaryVariant],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [AppColorsDS.surface, AppColorsDS.surfaceMuted],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: AppRadii.large,
        border: Border.all(color: borderColor ?? AppColorsDS.border),
        boxShadow: gradient ? AppShadows.medium : AppShadows.low,
      ),
      child: child,
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadii.large,
        onTap: onTap,
        child: content,
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  const SectionCard({
    Key? key,
    required this.title,
    this.subtitle,
    required this.child,
    this.trailing,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MotionReveal(
      delay: const Duration(milliseconds: 140),
      duration: const Duration(milliseconds: 760),
      beginOffset: const Offset(0, 0.024),
      beginBlur: 9,
      child: AppCard(
        padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
        borderColor: AppColorsDS.borderStrong,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 560;
            final summary = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.h4),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(subtitle!, style: AppTypography.body2),
                ],
              ],
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (stacked)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      summary,
                      if (trailing != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        trailing!,
                      ],
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: summary),
                      if (trailing != null) ...[
                        const SizedBox(width: AppSpacing.md),
                        Flexible(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: trailing!,
                          ),
                        ),
                      ],
                    ],
                  ),
                const SizedBox(height: AppSpacing.md),
                const Divider(height: 1, color: AppColorsDS.divider),
                const SizedBox(height: AppSpacing.lg),
                child,
              ],
            );
          },
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String label;
  final AppTone tone;
  final IconData? icon;

  const StatusBadge({
    Key? key,
    required this.label,
    this.tone = AppTone.neutral,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = _toneColors(tone);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: AppRadii.large,
        border: Border.all(color: colors.foreground.withOpacity(0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: colors.foreground),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: AppTypography.overline.copyWith(
              color: colors.foreground,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  _ToneColors _toneColors(AppTone tone) {
    switch (tone) {
      case AppTone.primary:
        return const _ToneColors(AppColorsDS.primarySoft, AppColorsDS.primary);
      case AppTone.success:
        return const _ToneColors(
            AppColorsDS.accentGreenSoft, AppColorsDS.success);
      case AppTone.warning:
        return const _ToneColors(
            AppColorsDS.accentAmberSoft, AppColorsDS.warning);
      case AppTone.danger:
        return const _ToneColors(AppColorsDS.accentRedSoft, AppColorsDS.danger);
      case AppTone.info:
        return const _ToneColors(AppColorsDS.accentBlueSoft, AppColorsDS.info);
      case AppTone.neutral:
        return const _ToneColors(
            AppColorsDS.accentSlateSoft, AppColorsDS.textSecondary);
    }
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final Widget? chart;
  final String? footer;

  const MetricCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.chart,
    this.footer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final highlight = iconColor ?? AppColorsDS.primary;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lgSm),
      borderColor: AppColorsDS.borderStrong,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 148),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: highlight.withOpacity(0.12),
                    borderRadius: AppRadii.large,
                  ),
                  child: Icon(icon, color: highlight, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.subtitle2.copyWith(
                      color: AppColorsDS.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(value, style: AppTypography.h3),
            if (footer != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(footer!, style: AppTypography.caption),
            ],
            if (chart != null) ...[
              const SizedBox(height: AppSpacing.md),
              SizedBox(height: 44, child: chart!),
            ],
          ],
        ),
      ),
    );
  }
}

class KpiStrip extends StatelessWidget {
  final List<Widget> children;

  const KpiStrip({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 720;
        if (compact) {
          return Column(
            children: children
                .map(
                  (child) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: SizedBox(width: double.infinity, child: child),
                  ),
                )
                .toList(),
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(children.length, (index) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: index == children.length - 1 ? 0 : AppSpacing.md),
                child: children[index],
              ),
            );
          }),
        );
      },
    );
  }
}

class AppListTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const AppListTile({
    Key? key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tile = Padding(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.mdSm, horizontal: AppSpacing.md),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 420 && trailing != null;
          final textContent = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.subtitle1),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xxs),
                Text(subtitle!, style: AppTypography.body2),
              ],
            ],
          );

          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: AppSpacing.md),
                    ],
                    Expanded(child: textContent),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                trailing!,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(child: textContent),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.md),
                trailing!,
              ],
            ],
          );
        },
      ),
    );

    if (onTap == null) {
      return tile;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, borderRadius: AppRadii.medium, child: tile),
    );
  }
}

class TransactionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final bool negative;
  final VoidCallback? onTap;

  const TransactionRow({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.negative = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final amountColor = negative ? AppColorsDS.danger : AppColorsDS.success;
    return AppCard(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      onTap: onTap,
      child: AppListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: amountColor.withOpacity(0.12),
            borderRadius: AppRadii.medium,
          ),
          child: Icon(icon, color: amountColor, size: 18),
        ),
        title: title,
        subtitle: subtitle,
        trailing: Text(amount,
            style: AppTypography.subtitle2.copyWith(color: amountColor)),
      ),
    );
  }
}

class AssetRow extends StatelessWidget {
  final String symbol;
  final String name;
  final String price;
  final String change;

  const AssetRow({
    Key? key,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final changeValue = double.tryParse(change.replaceAll('%', '')) ?? 0;
    final changeColor =
        changeValue >= 0 ? AppColorsDS.success : AppColorsDS.danger;
    return AppCard(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      child: AppListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColorsDS.accentBlueSoft,
            borderRadius: AppRadii.medium,
          ),
          child: Center(
            child: Text(symbol.substring(0, 1),
                style: AppTypography.subtitle2
                    .copyWith(color: AppColorsDS.primary)),
          ),
        ),
        title: name,
        subtitle: symbol,
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(price,
                style: AppTypography.subtitle2
                    .copyWith(color: AppColorsDS.textPrimary)),
            Text(change,
                style: AppTypography.caption.copyWith(color: changeColor)),
          ],
        ),
      ),
    );
  }
}

class WalletAddressCard extends StatelessWidget {
  final String address;
  final VoidCallback? onCopy;

  const WalletAddressCard({
    Key? key,
    required this.address,
    this.onCopy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: SelectableText(
              address,
              style:
                  AppTypography.mono.copyWith(color: AppColorsDS.textSecondary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            icon: const Icon(Icons.copy, size: 18),
            color: AppColorsDS.primary,
            onPressed: onCopy,
          ),
        ],
      ),
    );
  }
}

class InfoPair extends StatelessWidget {
  final String label;
  final String value;
  final CrossAxisAlignment alignment;

  const InfoPair({
    Key? key,
    required this.label,
    required this.value,
    this.alignment = CrossAxisAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(label, style: AppTypography.caption),
        const SizedBox(height: AppSpacing.xxs),
        Text(value,
            style: AppTypography.subtitle2
                .copyWith(color: AppColorsDS.textPrimary)),
      ],
    );
  }
}

class TimelineTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;
  final Color accent;

  const TimelineTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.accent = AppColorsDS.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
            ),
            Container(width: 2, height: 52, color: AppColorsDS.divider),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.subtitle1),
                const SizedBox(height: AppSpacing.xxs),
                Text(subtitle, style: AppTypography.body2),
                const SizedBox(height: AppSpacing.xs),
                Text(trailing, style: AppTypography.caption),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class InsightBanner extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final AppTone tone;
  final Widget? trailing;

  const InsightBanner({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    this.tone = AppTone.primary,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = _toneColors(tone);
    return AppCard(
      borderColor: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 520;
          final leadingIcon = Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: AppRadii.medium,
            ),
            child: Icon(icon, color: colors.foreground),
          );
          final textBlock = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.h5),
              const SizedBox(height: AppSpacing.xxs),
              Text(description, style: AppTypography.body2),
            ],
          );

          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    leadingIcon,
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: textBlock),
                  ],
                ),
                if (trailing != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  trailing!,
                ],
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leadingIcon,
              const SizedBox(width: AppSpacing.md),
              Expanded(child: textBlock),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.md),
                trailing!,
              ],
            ],
          );
        },
      ),
    );
  }

  _ToneColors _toneColors(AppTone tone) {
    switch (tone) {
      case AppTone.primary:
        return const _ToneColors(
            AppColorsDS.accentBlueSoft, AppColorsDS.primary);
      case AppTone.success:
        return const _ToneColors(
            AppColorsDS.accentGreenSoft, AppColorsDS.success);
      case AppTone.warning:
        return const _ToneColors(
            AppColorsDS.accentAmberSoft, AppColorsDS.warning);
      case AppTone.danger:
        return const _ToneColors(AppColorsDS.accentRedSoft, AppColorsDS.danger);
      case AppTone.info:
        return const _ToneColors(AppColorsDS.accentBlueSoft, AppColorsDS.info);
      case AppTone.neutral:
        return const _ToneColors(
            AppColorsDS.accentSlateSoft, AppColorsDS.textSecondary);
    }
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const GlassCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.large,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppColorsDS.white.withOpacity(0.7),
            borderRadius: AppRadii.large,
            border: Border.all(color: AppColorsDS.white.withOpacity(0.9)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class PaymentMethodCard extends StatelessWidget {
  final String provider;
  final String maskedNumber;
  final String? type;
  final String? expiryDate;
  final bool isDefault;
  final VoidCallback? onTap;

  const PaymentMethodCard({
    Key? key,
    required this.provider,
    required this.maskedNumber,
    this.type,
    this.expiryDate,
    this.isDefault = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 420;
          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(provider, style: AppTypography.subtitle1),
                  ),
                  if (isDefault) ...[
                    const SizedBox(width: AppSpacing.sm),
                    const StatusBadge(
                      label: 'Default',
                      tone: AppTone.primary,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(maskedNumber, style: AppTypography.caption),
              if (expiryDate != null && expiryDate!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xxs),
                Text('Expiry $expiryDate', style: AppTypography.caption),
              ],
            ],
          );

          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PaymentBrandBadge(provider: provider, type: type),
                const SizedBox(height: AppSpacing.md),
                details,
              ],
            );
          }

          return Row(
            children: [
              PaymentBrandBadge(provider: provider, type: type),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: details),
            ],
          );
        },
      ),
    );
  }
}

class MarketItemCard extends StatelessWidget {
  final String name;
  final String price;
  final String? imageUrl;
  final VoidCallback? onTap;

  const MarketItemCard({
    Key? key,
    required this.name,
    required this.price,
    this.imageUrl,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColorsDS.surfaceMuted,
              borderRadius: AppRadii.medium,
            ),
            child: Icon(
              imageUrl == null ? Icons.image_outlined : Icons.image,
              size: 34,
              color: AppColorsDS.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(name, style: AppTypography.subtitle1),
          Text(price, style: AppTypography.body2),
        ],
      ),
    );
  }
}

class CasinoGameCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final VoidCallback? onTap;

  const CasinoGameCard({
    Key? key,
    required this.name,
    this.imageUrl,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColorsDS.surfaceMuted,
              borderRadius: AppRadii.medium,
            ),
            child: const Center(
              child: Icon(Icons.videogame_asset_outlined,
                  size: 40, color: AppColorsDS.textSecondary),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(name, style: AppTypography.subtitle1),
        ],
      ),
    );
  }
}

class CarbonProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final VoidCallback? onTap;

  const CarbonProjectCard({
    Key? key,
    required this.title,
    required this.description,
    required this.price,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.subtitle1),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: AppTypography.body2,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            price,
            style:
                AppTypography.subtitle2.copyWith(color: AppColorsDS.secondary),
          ),
        ],
      ),
    );
  }
}
