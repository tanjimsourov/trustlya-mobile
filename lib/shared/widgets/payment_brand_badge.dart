import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class PaymentBrandBadge extends StatelessWidget {
  final String provider;
  final String? type;
  final double height;
  final bool compact;
  final bool showLabel;

  const PaymentBrandBadge({
    Key? key,
    required this.provider,
    this.type,
    this.height = 48,
    this.compact = false,
    this.showLabel = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spec = _PaymentBrandSpec.resolve(provider: provider, type: type);
    final emblem = _PaymentBrandEmblem(spec: spec, size: compact ? 20 : 22);

    return Container(
      height: height,
      constraints: BoxConstraints(
        minWidth: compact ? height : height * 1.7,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.sm : AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: spec.background,
        borderRadius: BorderRadius.circular(compact ? 14 : AppRadii.md),
        border: Border.all(color: spec.border),
        boxShadow: [
          BoxShadow(
            color: spec.shadow,
            blurRadius: compact ? 12 : 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: showLabel
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                emblem,
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    spec.label,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.subtitle2.copyWith(
                      color: spec.foreground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            )
          : Center(child: emblem),
    );
  }
}

class _PaymentBrandEmblem extends StatelessWidget {
  final _PaymentBrandSpec spec;
  final double size;

  const _PaymentBrandEmblem({
    required this.spec,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    switch (spec.kind) {
      case _PaymentBrandKind.visa:
        return Text(
          'VISA',
          style: AppTypography.overline.copyWith(
            color: spec.foreground,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        );
      case _PaymentBrandKind.mastercard:
        return SizedBox(
          width: size * 1.8,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                child: Container(
                  width: size,
                  height: size,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE3462C),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: Container(
                  width: size,
                  height: size,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8A032),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        );
      case _PaymentBrandKind.amex:
        return Text(
          'AMEX',
          style: AppTypography.overline.copyWith(
            color: spec.foreground,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.7,
          ),
        );
      case _PaymentBrandKind.bank:
        return Icon(Icons.account_balance_rounded,
            size: size, color: spec.foreground);
      case _PaymentBrandKind.wallet:
        return Icon(Icons.account_balance_wallet_rounded,
            size: size, color: spec.foreground);
      case _PaymentBrandKind.crypto:
        return Icon(Icons.currency_bitcoin_rounded,
            size: size, color: spec.foreground);
      case _PaymentBrandKind.regional:
        return Icon(Icons.language_rounded, size: size, color: spec.foreground);
      case _PaymentBrandKind.genericCard:
        return Icon(Icons.credit_card_rounded,
            size: size, color: spec.foreground);
    }
  }
}

enum _PaymentBrandKind {
  visa,
  mastercard,
  amex,
  bank,
  wallet,
  crypto,
  regional,
  genericCard,
}

class _PaymentBrandSpec {
  final String label;
  final Color background;
  final Color foreground;
  final Color border;
  final Color shadow;
  final _PaymentBrandKind kind;

  const _PaymentBrandSpec({
    required this.label,
    required this.background,
    required this.foreground,
    required this.border,
    required this.shadow,
    required this.kind,
  });

  factory _PaymentBrandSpec.resolve({
    required String provider,
    String? type,
  }) {
    final normalizedProvider = provider.toLowerCase();
    final normalizedType = (type ?? '').toLowerCase();

    if (normalizedProvider.contains('visa')) {
      return const _PaymentBrandSpec(
        label: 'Visa',
        background: AppColorsDS.primaryVariant,
        foreground: AppColorsDS.white,
        border: Color(0x1FFFFFFF),
        shadow: Color(0x220D2340),
        kind: _PaymentBrandKind.visa,
      );
    }

    if (normalizedProvider.contains('master')) {
      return const _PaymentBrandSpec(
        label: 'Mastercard',
        background: AppColorsDS.surface,
        foreground: AppColorsDS.textPrimary,
        border: AppColorsDS.borderStrong,
        shadow: Color(0x120D2340),
        kind: _PaymentBrandKind.mastercard,
      );
    }

    if (normalizedProvider.contains('amex') ||
        normalizedProvider.contains('american express')) {
      return const _PaymentBrandSpec(
        label: 'American Express',
        background: AppColorsDS.secondary,
        foreground: AppColorsDS.white,
        border: Color(0x1FFFFFFF),
        shadow: Color(0x182474EA),
        kind: _PaymentBrandKind.amex,
      );
    }

    if (normalizedType == 'bank' || normalizedProvider.contains('bank')) {
      return const _PaymentBrandSpec(
        label: 'Bank',
        background: AppColorsDS.accentBlueSoft,
        foreground: AppColorsDS.primaryVariant,
        border: AppColorsDS.borderStrong,
        shadow: Color(0x102474EA),
        kind: _PaymentBrandKind.bank,
      );
    }

    if (normalizedType == 'e-wallet' ||
        normalizedProvider.contains('wallet') ||
        normalizedProvider.contains('paypal')) {
      return const _PaymentBrandSpec(
        label: 'Wallet',
        background: AppColorsDS.accentGreenSoft,
        foreground: AppColorsDS.success,
        border: AppColorsDS.borderStrong,
        shadow: Color(0x10127A45),
        kind: _PaymentBrandKind.wallet,
      );
    }

    if (normalizedType == 'crypto' ||
        normalizedProvider.contains('crypto') ||
        normalizedProvider.contains('bridge') ||
        normalizedProvider.startsWith('0x')) {
      return const _PaymentBrandSpec(
        label: 'Crypto',
        background: AppColorsDS.secondaryVariant,
        foreground: AppColorsDS.white,
        border: Color(0x1FFFFFFF),
        shadow: Color(0x180A0F18),
        kind: _PaymentBrandKind.crypto,
      );
    }

    if (normalizedType == 'regional' ||
        normalizedProvider.contains('regional') ||
        normalizedProvider.contains('local')) {
      return const _PaymentBrandSpec(
        label: 'Regional',
        background: AppColorsDS.primarySoft,
        foreground: AppColorsDS.primaryVariant,
        border: AppColorsDS.borderStrong,
        shadow: Color(0x10F47A20),
        kind: _PaymentBrandKind.regional,
      );
    }

    if (normalizedType == 'card') {
      return const _PaymentBrandSpec(
        label: 'Card',
        background: AppColorsDS.surfaceMuted,
        foreground: AppColorsDS.primaryVariant,
        border: AppColorsDS.borderStrong,
        shadow: Color(0x120D2340),
        kind: _PaymentBrandKind.genericCard,
      );
    }

    final fallbackLabel = provider.trim().isEmpty ? 'Payment' : provider.trim();
    return _PaymentBrandSpec(
      label: fallbackLabel,
      background: AppColorsDS.surfaceMuted,
      foreground: AppColorsDS.primaryVariant,
      border: AppColorsDS.borderStrong,
      shadow: const Color(0x120D2340),
      kind: _PaymentBrandKind.genericCard,
    );
  }
}
