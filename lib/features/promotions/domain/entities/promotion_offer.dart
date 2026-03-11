import 'package:flutter/material.dart';

/// Represents an in‑app promotion or offer. Promotions may span
/// multiple modules (wallet, trading, casino, carbon, general) and
/// include a title, description, category tag, an icon to
/// visually distinguish the offer, and a route to navigate to
/// more information or claim the offer.
class PromotionOffer {
  final String id;
  final String title;
  final String description;
  final String category;
  final IconData icon;
  final String route;
  final dynamic arguments;

  const PromotionOffer({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.route,
    this.arguments,
  });
}
