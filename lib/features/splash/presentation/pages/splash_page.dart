import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/brand_logo.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/layout.dart';
import '../cubit/splash_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, BaseState<bool>>(
      listener: (context, state) {
        if (state.status == Status.success) {
          final loggedIn = state.data ?? false;
          Navigator.of(context).pushReplacementNamed(
              loggedIn ? Routes.shell : Routes.onboarding);
        }
      },
      child: AppScaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColorsDS.background, AppColorsDS.backgroundAlt],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: ResponsivePageWrapper(
              maxWidth: 520,
              child: AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const BrandMark(size: 84),
                      const SizedBox(height: AppSpacing.lg),
                      const BrandLockup(
                        height: 84,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Digital asset infrastructure for tokenization, post-trade operations, wallet control, and carbon workflows.',
                        style: AppTypography.body1
                            .copyWith(color: AppColorsDS.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 2.4),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Preparing workspace',
                        style: AppTypography.caption
                            .copyWith(color: AppColorsDS.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
