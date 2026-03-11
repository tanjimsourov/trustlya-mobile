import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../domain/entities/tokenization_activity_item.dart';
import '../cubit/tokenization_activity_cubit.dart';
import '../cubit/tokenization_activity_state.dart';

class TokenizationActivityPage extends StatelessWidget {
  const TokenizationActivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TokenizationActivityCubit>(
      create: (_) => getIt<TokenizationActivityCubit>()..loadActivity(),
      child: BlocBuilder<TokenizationActivityCubit, TokenizationActivityState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading tokenization activity'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () =>
                    context.read<TokenizationActivityCubit>().loadActivity(),
              ),
            );
          }

          final activity = state.data ?? <TokenizationActivityItem>[];
          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      eyebrow: 'Activity feed',
                      title: 'Tokenization operations log',
                      subtitle:
                          'Review recent onboarding, distribution, and servicing events across tokenized asset programs.',
                    ),
                    const SectionSpacing(),
                    if (activity.isEmpty)
                      const Center(
                          child: StatusBadge(
                              label: 'No recent activity',
                              tone: AppTone.neutral))
                    else
                      SectionCard(
                        title: 'Recent events',
                        subtitle:
                            'Latest tokenization actions surfaced for operations and compliance teams.',
                        child: Column(
                          children: activity
                              .map(
                                (item) => TimelineTile(
                                  title: item.title,
                                  subtitle: item.description,
                                  trailing: AppFormatters.dateShort(item.date),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
