import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/routes.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/favorite_item.dart';
import '../../domain/repositories/favorites_repository.dart';

abstract class FavoritesDataSource implements FavoritesRepository {}

class MockFavoritesDataSource implements FavoritesDataSource {
  final List<FavoriteItem> _favorites = [
    FavoriteItem(
      id: 'fav_item_ak47',
      title: 'AK-47 Redline',
      subtitle: 'Covert | MW',
      type: 'Item',
      icon: Icons.inventory_2,
      route: Routes.itemDetail,
      arguments: 'ak47',
    ),
    FavoriteItem(
      id: 'fav_game_roulette',
      title: 'Roulette',
      subtitle: 'Casino Game',
      type: 'Game',
      icon: Icons.casino,
      route: Routes.rouletteGame,
      arguments: null,
    ),
    FavoriteItem(
      id: 'fav_project_rainforest',
      title: 'Rainforest Project',
      subtitle: 'Carbon Offset',
      type: 'Project',
      icon: Icons.eco,
      route: Routes.carbonProjectDetail,
      arguments: 'rainforest',
    ),
    FavoriteItem(
      id: 'fav_method_visa',
      title: 'Visa **** 4242',
      subtitle: 'Payment Method',
      type: 'Method',
      icon: Icons.credit_card,
      route: Routes.paymentMethods,
      arguments: null,
    ),
  ];

  @override
  Future<Result<List<FavoriteItem>>> getFavorites() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Result.success(List<FavoriteItem>.from(_favorites));
  }

  @override
  Future<Result<void>> addFavorite(FavoriteItem item) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (_favorites.any((favorite) => favorite.id == item.id)) {
      return const Result.success(null);
    }
    _favorites.add(item);
    return const Result.success(null);
  }

  @override
  Future<Result<void>> removeFavorite(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _favorites.removeWhere((favorite) => favorite.id == id);
    return const Result.success(null);
  }
}

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl({FavoritesDataSource? dataSource})
      : _dataSource = dataSource ?? MockFavoritesDataSource();

  final FavoritesDataSource _dataSource;

  @override
  Future<Result<List<FavoriteItem>>> getFavorites() {
    return _dataSource.getFavorites();
  }

  @override
  Future<Result<void>> addFavorite(FavoriteItem item) {
    return _dataSource.addFavorite(item);
  }

  @override
  Future<Result<void>> removeFavorite(String id) {
    return _dataSource.removeFavorite(id);
  }
}
