import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/cards.dart';
import '../../domain/entities/notification_item.dart';
import '../../presentation/cubit/notifications_cubit.dart';
import '../../presentation/cubit/notifications_state.dart';
import '../../../../app/routes.dart';

/// Displays notifications grouped by date with customised styling. This
/// replaces the basic list with grouping and uses [AppListTile] for
/// consistent appearance. It automatically loads notifications when
/// constructed.
class NotificationsListPage extends StatelessWidget {
  const NotificationsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsCubit>(
      create: (_) => getIt<NotificationsCubit>()..loadNotifications(),
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          return AppScaffold(
            appBar: AppBar(title: const Text('Notifications')),
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, NotificationsState state) {
    switch (state.status) {
      case Status.loading:
        return const LoadingWidget();
      case Status.empty:
        return const EmptyWidget();
      case Status.error:
        return shared.ErrorWidgetView(message: state.message);
      case Status.success:
        final List<NotificationItem> notifications =
            state.data as List<NotificationItem>;
        // Group notifications by whether they occurred today or earlier
        final now = DateTime.now();
        final Map<String, List<NotificationItem>> groups = {
          'Today': [],
          'Earlier': []
        };
        for (final n in notifications) {
          final sameDay = n.date.year == now.year &&
              n.date.month == now.month &&
              n.date.day == now.day;
          groups[sameDay ? 'Today' : 'Earlier']!.add(n);
        }
        return ListView(
          children: [
            for (final entry in groups.entries)
              if (entry.value.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.md,
                      AppSpacing.lg, AppSpacing.md, AppSpacing.sm),
                  child: Text(entry.key,
                      style: AppTypography.subtitle1
                          .copyWith(color: AppColorsDS.textSecondary)),
                ),
                ...entry.value.map((n) => AppListTile(
                      leading: const Icon(Icons.notifications,
                          color: AppColorsDS.primary),
                      title: n.title,
                      subtitle: n.body,
                      trailing: Text(
                        '${n.date.hour.toString().padLeft(2, '0')}:${n.date.minute.toString().padLeft(2, '0')}',
                        style: AppTypography.caption
                            .copyWith(color: AppColorsDS.textSecondary),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            Routes.notificationDetail,
                            arguments: n.id);
                      },
                    )),
              ],
          ],
        );
      default:
        return Center(
          child: ElevatedButton(
            onPressed: () =>
                context.read<NotificationsCubit>().loadNotifications(),
            child: const Text('Load Notifications'),
          ),
        );
    }
  }
}
