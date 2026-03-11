import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../domain/entities/lifecycle_event.dart';
import '../cubit/lifecycle_events_cubit.dart';
import '../cubit/lifecycle_events_state.dart';

class LifecycleEventsPage extends StatelessWidget {
  const LifecycleEventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final programId = ModalRoute.of(context)?.settings.arguments as String?;
    return BlocProvider<LifecycleEventsCubit>(
      create: (_) => getIt<LifecycleEventsCubit>()..loadEvents(programId ?? ''),
      child: BlocBuilder<LifecycleEventsCubit, LifecycleEventsState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading lifecycle events'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () => context
                    .read<LifecycleEventsCubit>()
                    .loadEvents(programId ?? ''),
              ),
            );
          }

          final events = state.data ?? <LifecycleEvent>[];
          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      eyebrow: 'Lifecycle events',
                      title: 'Corporate actions and servicing',
                      subtitle:
                          'Track servicing milestones, distributions, and governance events tied to the selected issuance program.',
                    ),
                    const SectionSpacing(),
                    if (events.isEmpty)
                      const Center(
                          child: StatusBadge(
                              label: 'No lifecycle events',
                              tone: AppTone.neutral))
                    else
                      SectionCard(
                        title: 'Program timeline',
                        subtitle:
                            'Events are displayed in chronological order for operational review.',
                        child: Column(
                          children: events
                              .map(
                                (event) => TimelineTile(
                                  title: event.type,
                                  subtitle: event.description,
                                  trailing: AppFormatters.dateShort(event.date),
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
