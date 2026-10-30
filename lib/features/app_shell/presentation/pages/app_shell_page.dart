import 'package:flutter/material.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/config/app_backend.dart';
import '../../../../core/config/backend_registry.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/brand_logo.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/motion.dart';
import '../../../carbon/presentation/pages/dashboard_page.dart' as carbon_pages;
import '../../../home/presentation/pages/dashboard_page.dart';
import '../../../post_trade/presentation/pages/post_trade_dashboard_page.dart';
import '../../../tokenization/presentation/pages/tokenization_overview_page.dart';
import '../../../wallet/presentation/pages/wallet_overview_page.dart';

class _ShellDestination {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;

  const _ShellDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.page,
  });
}

class AppShellPage extends StatefulWidget {
  const AppShellPage({Key? key}) : super(key: key);

  @override
  State<AppShellPage> createState() => _AppShellPageState();
}

class _AppShellPageState extends State<AppShellPage> {
  late final List<_ShellDestination> _destinations = [
    const _ShellDestination(
      label: 'Overview',
      icon: Icons.widgets_outlined,
      selectedIcon: Icons.widgets_rounded,
      page: DashboardPage(embedded: true),
    ),
    const _ShellDestination(
      label: 'Tokenization',
      icon: Icons.account_tree_outlined,
      selectedIcon: Icons.account_tree_rounded,
      page: TokenizationOverviewPage(embedded: true),
    ),
    const _ShellDestination(
      label: 'Post-Trade',
      icon: Icons.fact_check_outlined,
      selectedIcon: Icons.fact_check_rounded,
      page: PostTradeDashboardPage(embedded: true),
    ),
    const _ShellDestination(
      label: 'Wallet',
      icon: Icons.account_balance_wallet_outlined,
      selectedIcon: Icons.account_balance_wallet_rounded,
      page: WalletOverviewPage(embedded: true),
    ),
    const _ShellDestination(
      label: 'Carbon',
      icon: Icons.eco_outlined,
      selectedIcon: Icons.eco_rounded,
      page: carbon_pages.CarbonDashboardPage(embedded: true),
    ),
  ];

  int _index = 0;

  void _onTap(int index) {
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    final backendConfig = getIt<AppBackendConfig>();
    final backendRegistry = getIt<BackendRegistry>();
    final isDesktop = MediaQuery.of(context).size.width >= 960;
    final isCompact = MediaQuery.of(context).size.width < 720;
    final page = _destinations[_index];

    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BrandLockup(height: 36, useAsset: true),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Global digital asset infrastructure',
          style:
              AppTypography.caption.copyWith(color: AppColorsDS.textSecondary),
        ),
      ],
    );

    final statusChips = Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        const _TopBarChip(
          icon: Icons.verified_user_outlined,
          label: 'Custody controls active',
        ),
        const _TopBarChip(
          icon: Icons.rule_folder_outlined,
          label: 'Compliance ready',
        ),
        _TopBarChip(
          icon: backendRegistry.hasFallbacks
              ? Icons.sync_problem_outlined
              : backendConfig.usesApi
                  ? Icons.cloud_done_outlined
                  : Icons.hub_outlined,
          label: backendRegistry.summaryLabel,
        ),
      ],
    );

    final profileButton = InkWell(
      borderRadius: AppRadii.large,
      onTap: () => Navigator.of(context).pushNamed(Routes.profileView),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.mdSm, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColorsDS.surfaceElevated,
          borderRadius: AppRadii.large,
          border: Border.all(color: AppColorsDS.borderStrong),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColorsDS.accentBlueSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_outline,
                  size: 18, color: AppColorsDS.secondary),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Operations',
                    style: AppTypography.caption
                        .copyWith(color: AppColorsDS.textSecondary)),
                Text('Workspace',
                    style: AppTypography.subtitle2
                        .copyWith(color: AppColorsDS.textPrimary)),
              ],
            ),
          ],
        ),
      ),
    );

    final topBar = Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColorsDS.surface, AppColorsDS.surfaceMuted],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(bottom: BorderSide(color: AppColorsDS.divider)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F263B56),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: isCompact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleBlock,
                const SizedBox(height: AppSpacing.md),
                statusChips,
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Activity Center',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.of(context)
                          .pushNamed(Routes.activityCenter),
                      icon: const Icon(Icons.notifications_none_outlined),
                    ),
                    const Spacer(),
                    profileButton,
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: titleBlock),
                statusChips,
                const SizedBox(width: AppSpacing.md),
                IconButton(
                  tooltip: 'Activity Center',
                  onPressed: () =>
                      Navigator.of(context).pushNamed(Routes.activityCenter),
                  icon: const Icon(Icons.notifications_none_outlined),
                ),
                const SizedBox(width: AppSpacing.xs),
                profileButton,
              ],
            ),
    );

    if (isDesktop) {
      return AppScaffold(
        body: Column(
          children: [
            MotionReveal(
              duration: const Duration(milliseconds: 700),
              beginOffset: const Offset(0, 0.014),
              beginBlur: 8,
              child: topBar,
            ),
            Expanded(
              child: DesktopSideNavigationShell(
                navPane: _DesktopNavigationPane(
                  currentIndex: _index,
                  onTap: _onTap,
                  destinations: _destinations,
                ),
                body: MotionSwitcher(
                  switchKey: _index,
                  child: page.page,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return AppScaffold(
      body: Column(
        children: [
          MotionReveal(
            duration: const Duration(milliseconds: 700),
            beginOffset: const Offset(0, 0.014),
            beginBlur: 8,
            child: topBar,
          ),
          Expanded(
            child: MotionSwitcher(
              switchKey: _index,
              child: page.page,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _ShellBottomDock(
        currentIndex: _index,
        onTap: _onTap,
        destinations: _destinations,
      ),
    );
  }
}

class _ShellBottomDock extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<_ShellDestination> destinations;

  const _ShellBottomDock({
    required this.currentIndex,
    required this.onTap,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColorsDS.surface, AppColorsDS.surfaceMuted],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColorsDS.borderStrong.withOpacity(0.84),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0x18263B56).withOpacity(0.9),
                blurRadius: 28,
                offset: const Offset(0, 18),
              ),
              BoxShadow(
                color: AppColorsDS.primary.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: NavigationBarTheme(
            data: NavigationBarTheme.of(context).copyWith(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              height: 78,
              indicatorColor: Colors.transparent,
              labelTextStyle: MaterialStateProperty.resolveWith((states) {
                final selected = states.contains(MaterialState.selected);
                return AppTypography.caption.copyWith(
                  color: selected
                      ? AppColorsDS.primaryVariant
                      : AppColorsDS.textSecondary,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  letterSpacing: 0.12,
                );
              }),
              iconTheme: MaterialStateProperty.resolveWith((states) {
                final selected = states.contains(MaterialState.selected);
                return IconThemeData(
                  color: selected
                      ? AppColorsDS.primaryVariant
                      : AppColorsDS.textSecondary,
                  size: 22,
                );
              }),
            ),
            child: NavigationBar(
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              selectedIndex: currentIndex,
              onDestinationSelected: onTap,
              destinations: destinations
                  .map(
                    (item) => NavigationDestination(
                      icon: _BottomNavGlyph(icon: item.icon),
                      selectedIcon: _BottomNavGlyph(
                        icon: item.selectedIcon,
                        selected: true,
                      ),
                      label: item.label,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavGlyph extends StatelessWidget {
  final IconData icon;
  final bool selected;

  const _BottomNavGlyph({
    required this.icon,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.all(selected ? 10 : 0),
      decoration: BoxDecoration(
        gradient: selected
            ? const LinearGradient(
                colors: [
                  AppColorsDS.primaryVariant,
                  AppColorsDS.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: selected ? null : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected
              ? AppColorsDS.white.withOpacity(0.18)
              : Colors.transparent,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppColorsDS.secondary.withOpacity(0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: AppColorsDS.primary.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Icon(
        icon,
        size: 22,
        color: selected ? AppColorsDS.white : AppColorsDS.textSecondary,
      ),
    );
  }
}

class _DesktopNavigationPane extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<_ShellDestination> destinations;

  const _DesktopNavigationPane({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.destinations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Text(
              'Platform',
              style: AppTypography.overline
                  .copyWith(color: AppColorsDS.textSecondary),
            ),
          ),
          ...List.generate(destinations.length, (index) {
            final item = destinations[index];
            final selected = index == currentIndex;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: InkWell(
                borderRadius: AppRadii.medium,
                onTap: () => onTap(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.mdSm),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColorsDS.accentBlueSoft
                        : AppColorsDS.surfaceElevated.withOpacity(0.4),
                    borderRadius: AppRadii.medium,
                    border: Border.all(
                      color: selected
                          ? AppColorsDS.borderStrong
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selected ? item.selectedIcon : item.icon,
                        size: 20,
                        color: selected
                            ? AppColorsDS.primary
                            : AppColorsDS.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          item.label,
                          style: AppTypography.subtitle2.copyWith(
                            color: selected
                                ? AppColorsDS.primary
                                : AppColorsDS.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
          AppCard(
            borderColor: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Legacy modules', style: AppTypography.caption),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Legacy consumer modules remain isolated from the primary workspace.',
                  style: AppTypography.body2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBarChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TopBarChip({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.mdSm, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColorsDS.primarySoft,
        borderRadius: AppRadii.large,
        border: Border.all(color: AppColorsDS.borderStrong),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColorsDS.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(label,
              style: AppTypography.caption
                  .copyWith(color: AppColorsDS.textPrimary)),
        ],
      ),
    );
  }
}
