import 'package:flutter/material.dart';

/// Represents a single search result. Search results can come from
/// multiple modules (wallet, trading, casino, carbon, etc.) and are
/// distinguished by their [type]. A result includes a [title], an
/// optional [subtitle], a [type] to indicate the source module and
/// a [route] to navigate when tapped. The [icon] is used to
/// visually differentiate different result types in the UI.
class SearchResult {
  final String id;
  final String title;
  final String? subtitle;
  final String type; // e.g. asset, item, game, project, transaction
  final IconData icon;
  final String route;
  final Object? arguments;

  const SearchResult({
    required this.id,
    required this.title,
    this.subtitle,
    required this.type,
    required this.icon,
    required this.route,
    this.arguments,
  });
}
