import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_shadows.dart';
import 'motion.dart';

/// Shared scaffold wrapper used across product screens.
class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const AppScaffold({
    Key? key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsDS.background,
      appBar: appBar,
      body: Stack(
        children: [
          const Positioned.fill(child: _ScaffoldBackdrop()),
          SafeArea(child: body),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

class _ScaffoldBackdrop extends StatelessWidget {
  const _ScaffoldBackdrop();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColorsDS.heroStart,
              AppColorsDS.background,
              AppColorsDS.backgroundAlt,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            _BackdropOrb(
              alignment: const Alignment(1.08, -1.04),
              size: 280,
              color: AppColorsDS.heroGlow,
            ),
            _BackdropOrb(
              alignment: const Alignment(-1.12, -0.52),
              size: 220,
              color: AppColorsDS.accentBlueSoft.withOpacity(0.8),
            ),
            _BackdropOrb(
              alignment: const Alignment(1.02, 1.02),
              size: 260,
              color: AppColorsDS.primarySoft.withOpacity(0.72),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackdropOrb extends StatelessWidget {
  final Alignment alignment;
  final double size;
  final Color color;

  const _BackdropOrb({
    required this.alignment,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: AppShadows.high,
        ),
      ),
    );
  }
}

/// Constrains content width while preserving responsive padding.
class ResponsivePageWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double maxWidth;

  const ResponsivePageWrapper({
    Key? key,
    required this.child,
    this.padding,
    this.maxWidth = 1320,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal =
            constraints.maxWidth < 720 ? AppSpacing.md : AppSpacing.lg;
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: padding ??
                  EdgeInsets.fromLTRB(
                    horizontal,
                    constraints.maxWidth < 720 ? AppSpacing.md : AppSpacing.lg,
                    horizontal,
                    AppSpacing.xxl,
                  ),
              child: MotionReveal(
                beginOffset: Offset.zero,
                beginScale: 0.992,
                beginBlur: 12,
                duration: const Duration(milliseconds: 720),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}

class SectionSpacing extends StatelessWidget {
  final double height;

  const SectionSpacing({Key? key, this.height = AppSpacing.xl})
      : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

/// Responsive grid helper for metric cards and panels.
class AdaptiveGrid extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final double minCellWidth;
  final double spacing;
  final double childAspectRatio;

  const AdaptiveGrid({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    this.minCellWidth = 240,
    this.spacing = AppSpacing.md,
    this.childAspectRatio = 1.45,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount =
            (constraints.maxWidth / minCellWidth).floor().clamp(1, 4);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) => MotionReveal(
            delay: Duration(milliseconds: 70 * index),
            duration: const Duration(milliseconds: 740),
            beginOffset: const Offset(0, 0.03),
            beginScale: 0.988,
            beginBlur: 10,
            child: itemBuilder(context, index),
          ),
        );
      },
    );
  }
}

/// Shell for larger layouts with a left-side navigation pane.
class DesktopSideNavigationShell extends StatelessWidget {
  final Widget navPane;
  final Widget body;

  const DesktopSideNavigationShell({
    Key? key,
    required this.navPane,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 296,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColorsDS.surface, AppColorsDS.surfaceMuted],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border(right: BorderSide(color: AppColorsDS.divider)),
          ),
          child: navPane,
        ),
        Expanded(child: body),
      ],
    );
  }
}

class MobileBottomNavShell extends StatefulWidget {
  final List<BottomNavigationBarItem> items;
  final List<Widget> pages;
  final int initialIndex;

  const MobileBottomNavShell({
    Key? key,
    required this.items,
    required this.pages,
    this.initialIndex = 0,
  })  : assert(items.length == pages.length),
        super(key: key);

  @override
  State<MobileBottomNavShell> createState() => _MobileBottomNavShellState();
}

class _MobileBottomNavShellState extends State<MobileBottomNavShell> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: MotionSwitcher(
        switchKey: _index,
        child: widget.pages[_index],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: widget.items
            .map(
              (item) => NavigationDestination(
                icon: item.icon,
                label: item.label ?? '',
              ),
            )
            .toList(),
      ),
    );
  }
}
