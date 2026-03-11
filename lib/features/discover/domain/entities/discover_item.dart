import 'package:flutter/material.dart';

/// Represents a curated discovery item shown in the explore page.
/// A discovery item can point to anything within the app – a
/// trending asset, a popular game, an interesting carbon project
/// or an educational article. Each item defines a type for
/// grouping, an icon for quick visual identification and a route
/// for navigation.
class DiscoverItem {
  final String id;
  final String title;
  final String description;
  final String type;
  final IconData icon;
  final String route;
  final dynamic arguments;

  const DiscoverItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.icon,
    required this.route,
    this.arguments,
  });
}
