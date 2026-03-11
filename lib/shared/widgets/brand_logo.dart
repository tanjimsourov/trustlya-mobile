import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class BrandAssetPaths {
  BrandAssetPaths._();

  static const String mark = 'assets/images/branding/trustlya_mark.png';
  static const String lockupDark =
      'assets/images/branding/trustlya_lockup_dark.png';
  static const String lockupLight =
      'assets/images/branding/trustlya_lockup_light.png';
}

class BrandMark extends StatelessWidget {
  final double size;
  final bool useAsset;

  const BrandMark({
    Key? key,
    this.size = 56,
    this.useAsset = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!useAsset) {
      return _BrandMarkFallback(size: size);
    }

    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        BrandAssetPaths.mark,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _BrandMarkFallback(
          size: size,
        ),
      ),
    );
  }
}

class BrandLockup extends StatelessWidget {
  final double height;
  final bool light;
  final bool useAsset;

  const BrandLockup({
    Key? key,
    this.height = 36,
    this.light = false,
    this.useAsset = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!useAsset) {
      return _BrandLockupFallback(height: height, light: light);
    }

    return SizedBox(
      height: height,
      child: Image.asset(
        light ? BrandAssetPaths.lockupLight : BrandAssetPaths.lockupDark,
        fit: BoxFit.contain,
        alignment: Alignment.centerLeft,
        errorBuilder: (context, error, stackTrace) => _BrandLockupFallback(
          height: height,
          light: light,
        ),
      ),
    );
  }
}

class _BrandMarkFallback extends StatelessWidget {
  final double size;

  const _BrandMarkFallback({
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: const LinearGradient(
          colors: [
            AppColorsDS.primary,
            AppColorsDS.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22152338),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'T',
          style: AppTypography.h2.copyWith(
            color: AppColorsDS.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _BrandLockupFallback extends StatelessWidget {
  final double height;
  final bool light;

  const _BrandLockupFallback({
    required this.height,
    required this.light,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = light ? AppColorsDS.white : AppColorsDS.textPrimary;
    return SizedBox(
      height: height,
      child: FittedBox(
        alignment: Alignment.centerLeft,
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BrandMarkFallback(size: height * 0.92),
            SizedBox(width: height * 0.22),
            Text(
              'Trustlya',
              style: AppTypography.h3.copyWith(
                color: textColor,
                fontSize: height * 0.42,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
