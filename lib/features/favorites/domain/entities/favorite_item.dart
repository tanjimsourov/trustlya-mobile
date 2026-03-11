import 'package:flutter/material.dart';

/// Represents a user favourite. Favourites can span multiple
/// modules (trading items, casino games, carbon projects, payment
/// methods, etc). Each entry contains the target's id, display
/// name, optional subtitle, category type, icon, and a navigation
/// route with arguments to open the resource.
class FavoriteItem {
  final String id;
  final String title;
  final String? subtitle;
  final String type;
  final IconData icon;
  final String route;
  final dynamic arguments;

  const FavoriteItem({
    required this.id,
    required this.title,
    this.subtitle,
    required this.type,
    required this.icon,
    required this.route,
    this.arguments,
  });
}
