import 'package:flutter/material.dart';

import '../../../../app/routes.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Quick actions hub. Provides a grid of high‑level actions that
/// span multiple modules, allowing the user to quickly navigate to
/// frequent tasks.
class QuickActionsPage extends StatelessWidget {
  const QuickActionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        label: 'Deposit',
        icon: Icons.arrow_downward,
        color: AppColorsDS.success,
        onTap: () =>
            Navigator.pushNamed(context, Routes.deposit, arguments: 'BTC'),
      ),
      _QuickAction(
        label: 'Withdraw',
        icon: Icons.arrow_upward,
        color: AppColorsDS.danger,
        onTap: () =>
            Navigator.pushNamed(context, Routes.withdraw, arguments: 'BTC'),
      ),
      _QuickAction(
        label: 'Trade Items',
        icon: Icons.swap_horiz,
        color: AppColorsDS.primary,
        onTap: () => Navigator.pushNamed(context, Routes.tradeBuilder),
      ),
      _QuickAction(
        label: 'Play Game',
        icon: Icons.casino,
        color: AppColorsDS.warning,
        onTap: () => Navigator.pushNamed(context, Routes.lobby),
      ),
      _QuickAction(
        label: 'Buy Carbon',
        icon: Icons.eco,
        color: AppColorsDS.secondary,
        onTap: () => Navigator.pushNamed(context, Routes.carbonProjects),
      ),
      _QuickAction(
        label: 'Verify ID',
        icon: Icons.verified_user,
        color: AppColorsDS.info,
        onTap: () => Navigator.pushNamed(context, Routes.kycStart),
      ),
    ];
    return AppScaffold(
      appBar: AppBar(title: const Text('Quick Actions')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return GestureDetector(
              onTap: action.onTap,
              child: AppCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: action.color.withOpacity(0.15),
                      child: Icon(action.icon, color: action.color, size: 30),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(action.label,
                        style: AppTypography.subtitle1
                            .copyWith(color: AppColorsDS.textPrimary)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction(
      {required this.label,
      required this.icon,
      required this.color,
      required this.onTap});
}
