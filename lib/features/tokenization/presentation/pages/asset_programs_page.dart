import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/dependency_injection.dart';
import '../../../../app/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;
import '../../../../shared/widgets/filter_row.dart';
import '../../../../shared/widgets/inputs.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../domain/entities/tokenized_asset_program.dart';
import '../cubit/asset_programs_cubit.dart';
import '../cubit/asset_programs_state.dart';

class AssetProgramsPage extends StatefulWidget {
  const AssetProgramsPage({Key? key}) : super(key: key);

  @override
  State<AssetProgramsPage> createState() => _AssetProgramsPageState();
}

class _AssetProgramsPageState extends State<AssetProgramsPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = const [
    'All',
    'Active',
    'Planning',
    'Completed',
    'Paused'
  ];
  int _selectedIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AssetProgramsCubit>(
      create: (_) => getIt<AssetProgramsCubit>()..loadPrograms(),
      child: BlocBuilder<AssetProgramsCubit, AssetProgramsState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const AppScaffold(
                body: LoadingWidget(label: 'Loading programs'));
          }

          if (state.status == Status.error) {
            return AppScaffold(
              body: shared.ErrorWidgetView(
                message: state.message,
                onRetry: () =>
                    context.read<AssetProgramsCubit>().loadPrograms(),
              ),
            );
          }

          final programs = state.data ?? <TokenizedAssetProgram>[];
          final query = _searchController.text.trim().toLowerCase();
          final statusFilter =
              _selectedIndex == 0 ? null : _filters[_selectedIndex];

          final filtered = programs.where((program) {
            final matchesQuery = query.isEmpty ||
                program.name.toLowerCase().contains(query) ||
                program.description.toLowerCase().contains(query);
            final matchesStatus = statusFilter == null ||
                _statusLabel(program.status).toLowerCase() ==
                    statusFilter.toLowerCase();
            return matchesQuery && matchesStatus;
          }).toList();

          return AppScaffold(
            body: SingleChildScrollView(
              child: ResponsivePageWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      eyebrow: 'Tokenization programs',
                      title: 'Issuer program roster',
                      subtitle:
                          'Review all tokenized asset mandates, allocation posture, issuance status, and downstream workflow entry points.',
                    ),
                    const SectionSpacing(),
                    FilterToolbar(
                      leading: SearchField(
                        controller: _searchController,
                        hintText: 'Search programs',
                        onChanged: (_) => setState(() {}),
                      ),
                      center: FilterRow(
                        options: _filters,
                        selectedIndex: _selectedIndex,
                        onSelected: (index) =>
                            setState(() => _selectedIndex = index),
                      ),
                    ),
                    const SectionSpacing(),
                    if (filtered.isEmpty)
                      const EmptyWidget(
                        title: 'No programs match this view',
                        message:
                            'Adjust the search or status filters to see program records.',
                      )
                    else
                      Column(
                        children: filtered
                            .map(
                              (program) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppSpacing.md),
                                child: _ProgramCard(program: program),
                              ),
                            )
                            .toList(),
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

  static String _statusLabel(ProgramStatus status) {
    switch (status) {
      case ProgramStatus.active:
        return 'Active';
      case ProgramStatus.planning:
        return 'Planning';
      case ProgramStatus.completed:
        return 'Completed';
      case ProgramStatus.paused:
        return 'Paused';
    }
  }
}

class _ProgramCard extends StatelessWidget {
  final TokenizedAssetProgram program;

  const _ProgramCard({Key? key, required this.program}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = program.totalTokens == 0
        ? 0.0
        : program.allocatedTokens / program.totalTokens;
    return AppCard(
      onTap: () => Navigator.of(context).pushNamed(
        Routes.tokenizationProgramDetail,
        arguments: program.id,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(program.name, style: AppTypography.h4),
                    const SizedBox(height: AppSpacing.xs),
                    Text(program.description, style: AppTypography.body2),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              StatusBadge(
                  label: _statusLabel(program.status),
                  tone: _statusTone(program.status)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 720;
              final metrics = [
                InfoPair(
                    label: 'Issued',
                    value: AppFormatters.dateShort(program.issuanceDate)),
                InfoPair(
                  label: 'Allocated',
                  value:
                      '${AppFormatters.compactNumber(program.allocatedTokens)} / ${AppFormatters.compactNumber(program.totalTokens)}',
                ),
                InfoPair(
                    label: 'Placement',
                    value: '${(progress * 100).toStringAsFixed(0)}%'),
              ];

              if (stacked) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...metrics.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.mdSm),
                        child: item,
                      ),
                    ),
                  ],
                );
              }

              return Row(
                children: metrics
                    .map(
                      (item) => Expanded(
                        child: item,
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColorsDS.surfaceMuted,
            color: AppColorsDS.primary,
          ),
        ],
      ),
    );
  }

  static String _statusLabel(ProgramStatus status) {
    switch (status) {
      case ProgramStatus.active:
        return 'Active';
      case ProgramStatus.planning:
        return 'Planning';
      case ProgramStatus.completed:
        return 'Completed';
      case ProgramStatus.paused:
        return 'Paused';
    }
  }

  static AppTone _statusTone(ProgramStatus status) {
    switch (status) {
      case ProgramStatus.active:
        return AppTone.success;
      case ProgramStatus.planning:
        return AppTone.warning;
      case ProgramStatus.completed:
        return AppTone.primary;
      case ProgramStatus.paused:
        return AppTone.danger;
    }
  }
}
