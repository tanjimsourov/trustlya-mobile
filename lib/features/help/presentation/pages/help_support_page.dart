import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/cards.dart';
import '../../../../shared/widgets/chips.dart';
import '../../../../shared/widgets/inputs.dart';
import '../../../../shared/widgets/layout.dart';
import '../../../../shared/widgets/buttons.dart';

/// Help & support centre page. Provides FAQs categorised by topic,
/// contact options and a list of previous support tickets. This
/// implementation uses static data and local state for expansion.
class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I deposit funds?',
      'answer':
          'Go to the Wallet section, select Deposit and choose your preferred method.'
    },
    {
      'question': 'How can I withdraw my earnings?',
      'answer':
          'Navigate to Wallet > Withdraw, enter the amount and your bank details.'
    },
    {
      'question': 'Where can I view my account limits?',
      'answer':
          'Your account limits are available under Profile > Account Tier.'
    },
    {
      'question': 'How do I enable two factor authentication?',
      'answer':
          'Go to Settings > Security and toggle Two Factor Authentication.'
    },
    {
      'question': 'What is carbon offsetting?',
      'answer':
          'Carbon offsetting allows you to invest in projects that reduce or remove CO₂ to compensate for your emissions.'
    },
  ];
  final Map<int, bool> _expanded = {};
  final List<Map<String, String>> _tickets = [
    {'title': 'Cannot withdraw funds', 'status': 'Open'},
    {'title': 'Verification pending', 'status': 'Closed'},
    {'title': 'Game crash issue', 'status': 'Open'},
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              SearchField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {});
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              // Category chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final category in [
                      'All',
                      'Account',
                      'Trading',
                      'Wallet',
                      'Casino',
                      'Carbon',
                      'Security'
                    ])
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: AppChip(
                          label: category,
                          selected: _selectedCategory == category,
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // FAQs
              Text('Frequently Asked Questions', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              ..._faqs.asMap().entries.map((entry) {
                final idx = entry.key;
                final faq = entry.value;
                final matchesSearch = _searchController.text.isEmpty ||
                    faq['question']!
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase());
                if (!matchesSearch) return const SizedBox.shrink();
                final isExpanded = _expanded[idx] ?? false;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard(
                    onTap: () {
                      setState(() {
                        _expanded[idx] = !isExpanded;
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                faq['question']!,
                                style: AppTypography.subtitle1,
                              ),
                            ),
                            Icon(
                              isExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: AppColorsDS.textSecondary,
                            ),
                          ],
                        ),
                        if (isExpanded) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            faq['answer']!,
                            style: AppTypography.body2
                                .copyWith(color: AppColorsDS.textSecondary),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SectionSpacing(),
              // Contact section
              Text('Need further help?', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Our support team is here to assist you.',
                        style: AppTypography.body2),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            label: 'Chat with Us',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Chat feature not available in mock')),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: SecondaryButton(
                            label: 'Submit Ticket',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Ticket submission not available in mock')),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SectionSpacing(),
              // Tickets
              Text('My Tickets', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              if (_tickets.isEmpty)
                Text('No support tickets submitted.',
                    style: AppTypography.body2
                        .copyWith(color: AppColorsDS.textSecondary))
              else
                Column(
                  children: [
                    for (final ticket in _tickets)
                      AppListTile(
                        leading: Icon(
                          ticket['status'] == 'Open'
                              ? Icons.mark_email_unread
                              : Icons.check_circle_outline,
                          color: ticket['status'] == 'Open'
                              ? AppColorsDS.warning
                              : AppColorsDS.success,
                        ),
                        title: ticket['title']!,
                        subtitle: 'Status: ${ticket['status']}',
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Viewing ticket: ${ticket['title']} (mock)')),
                          );
                        },
                      ),
                  ],
                ),
              const SectionSpacing(),
              // Security notice
              Text('Security Notice', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'For your security, never share your password, one‑time codes or private keys with anyone. Our team will never ask for these.',
                style: AppTypography.body2
                    .copyWith(color: AppColorsDS.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
