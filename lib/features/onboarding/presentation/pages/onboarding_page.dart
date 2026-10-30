import 'package:flutter/material.dart';

import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/brand_logo.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/layout.dart';

class _OnboardingSlide {
  final String title;
  final String description;
  final IconData icon;
  final List<String> bullets;

  const _OnboardingSlide({
    required this.title,
    required this.description,
    required this.icon,
    required this.bullets,
  });
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingSlide> _slides = const [
    _OnboardingSlide(
      title: 'Tokenization infrastructure',
      description:
          'Launch and administer digital asset programs with issuer onboarding, compliance configuration, lifecycle visibility, and investor operations.',
      icon: Icons.account_tree_outlined,
      bullets: [
        'Issuer setup and metadata capture',
        'Compliance and transfer controls',
        'Lifecycle and cap table visibility',
      ],
    ),
    _OnboardingSlide(
      title: 'Post-trade operations',
      description:
          'Monitor settlement queues, exceptions, treasury exposure, and reconciliation tasks from a single post-trade workspace.',
      icon: Icons.fact_check_outlined,
      bullets: [
        'Settlement queues and detail views',
        'Break management and SLA monitoring',
        'Treasury and finality tracking',
      ],
    ),
    _OnboardingSlide(
      title: 'Institutional wallet operations',
      description:
          'Manage balances, rails, linked methods, and controlled transfer workflows through an operational wallet layer.',
      icon: Icons.account_balance_wallet_outlined,
      bullets: [
        'Balance and custody visibility',
        'Transfer and conversion controls',
        'Fiat rails and linked payout methods',
      ],
    ),
    _OnboardingSlide(
      title: 'Carbon marketplace workflows',
      description:
          'Source verified carbon inventory, manage holdings, retire credits, and produce auditable impact records within the same platform.',
      icon: Icons.eco_outlined,
      bullets: [
        'Verified project sourcing',
        'Holdings and retirement workflows',
        'Impact and audit reporting',
      ],
    ),
  ];

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.register);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: ResponsivePageWrapper(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 920;
            final compactHeight = constraints.maxHeight < 760;
            final compactHero = stacked || compactHeight;
            final sidePanel = Container(
              width: double.infinity,
              padding: EdgeInsets.all(
                compactHero ? AppSpacing.lg : AppSpacing.xl,
              ),
              decoration: BoxDecoration(
                color: AppColorsDS.primaryVariant,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BrandLockup(
                    height: compactHero ? 40 : 64,
                    light: true,
                  ),
                  SizedBox(height: compactHero ? AppSpacing.sm : AppSpacing.md),
                  Text(
                    compactHero
                        ? 'Global digital asset infrastructure for issuance, post-trade, wallet, and carbon workflows.'
                        : 'Global digital asset infrastructure for issuance, post-trade operations, wallet control, and carbon workflows.',
                    maxLines: compactHero ? 3 : null,
                    overflow: compactHero
                        ? TextOverflow.ellipsis
                        : TextOverflow.visible,
                    style: (compactHero
                            ? AppTypography.body2
                            : AppTypography.body1)
                        .copyWith(color: AppColorsDS.white.withOpacity(0.9)),
                  ),
                  SizedBox(height: compactHero ? AppSpacing.md : AppSpacing.xl),
                  if (compactHero)
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: const [
                        _PanelBadge(
                          title: 'Platform pillars',
                          value: '4',
                        ),
                        _PanelBadge(
                          title: 'Institutional scope',
                          value: 'Issuer to retirement',
                        ),
                      ],
                    )
                  else ...[
                    const Spacer(),
                    const _PanelMetric(
                      title: 'Platform pillars',
                      value: '4',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _PanelMetric(
                      title: 'Institutional focus',
                      value: 'Issuer to retirement',
                    ),
                  ],
                ],
              ),
            );

            final contentPanel = Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushReplacementNamed(Routes.login),
                    child: const Text('Sign in'),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _slides.length,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    itemBuilder: (context, index) {
                      final slide = _slides[index];
                      return AppCard(
                        child: Padding(
                          padding: EdgeInsets.all(
                            compactHeight ? AppSpacing.lg : AppSpacing.xl,
                          ),
                          child: LayoutBuilder(
                            builder: (context, cardConstraints) {
                              return SingleChildScrollView(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: cardConstraints.maxHeight,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        (stacked || compactHeight)
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: (stacked || compactHeight)
                                            ? 60
                                            : 72,
                                        height: (stacked || compactHeight)
                                            ? 60
                                            : 72,
                                        decoration: const BoxDecoration(
                                          color: AppColorsDS.primarySoft,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Icon(
                                          slide.icon,
                                          size: (stacked || compactHeight)
                                              ? 30
                                              : 34,
                                          color: AppColorsDS.primaryVariant,
                                        ),
                                      ),
                                      SizedBox(
                                        height: (stacked || compactHeight)
                                            ? AppSpacing.lg
                                            : AppSpacing.xl,
                                      ),
                                      Text(
                                        slide.title,
                                        style: (stacked || compactHeight)
                                            ? AppTypography.h3
                                            : AppTypography.h2,
                                      ),
                                      const SizedBox(height: AppSpacing.md),
                                      Text(
                                        slide.description,
                                        style: (stacked || compactHeight)
                                            ? AppTypography.body2.copyWith(
                                                color: AppColorsDS.textPrimary,
                                              )
                                            : AppTypography.body1,
                                      ),
                                      SizedBox(
                                        height: (stacked || compactHeight)
                                            ? AppSpacing.lg
                                            : AppSpacing.xl,
                                      ),
                                      ...slide.bullets.map(
                                        (bullet) => Padding(
                                          padding: EdgeInsets.only(
                                            bottom: (stacked || compactHeight)
                                                ? AppSpacing.sm
                                                : AppSpacing.md,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                margin: const EdgeInsets.only(
                                                    top: 6),
                                                decoration: const BoxDecoration(
                                                  color: AppColorsDS.secondary,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(
                                                  width: AppSpacing.md),
                                              Expanded(
                                                child: Text(
                                                  bullet,
                                                  style: AppTypography.body2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: compactHeight ? AppSpacing.md : AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_slides.length, (index) {
                    final active = index == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            active ? AppColorsDS.primary : AppColorsDS.border,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    );
                  }),
                ),
                SizedBox(height: compactHeight ? AppSpacing.md : AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: GhostButton(
                        label: _currentPage == _slides.length - 1
                            ? 'Explore platform'
                            : 'Skip',
                        onPressed: () => Navigator.of(context)
                            .pushReplacementNamed(Routes.login),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: PrimaryButton(
                        label: _currentPage == _slides.length - 1
                            ? 'Create account'
                            : 'Continue',
                        onPressed: _next,
                      ),
                    ),
                  ],
                ),
              ],
            );

            if (stacked) {
              return Column(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 188),
                    child: sidePanel,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(child: contentPanel),
                ],
              );
            }

            return Row(
              children: [
                Expanded(flex: 5, child: sidePanel),
                const SizedBox(width: AppSpacing.lg),
                Expanded(flex: 7, child: contentPanel),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PanelMetric extends StatelessWidget {
  final String title;
  final String value;

  const _PanelMetric({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.caption
              .copyWith(color: AppColorsDS.white.withOpacity(0.7)),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.h4.copyWith(color: AppColorsDS.white),
        ),
      ],
    );
  }
}

class _PanelBadge extends StatelessWidget {
  final String title;
  final String value;

  const _PanelBadge({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColorsDS.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColorsDS.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTypography.caption
                .copyWith(color: AppColorsDS.white.withOpacity(0.72)),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.h6.copyWith(color: AppColorsDS.white),
          ),
        ],
      ),
    );
  }
}
