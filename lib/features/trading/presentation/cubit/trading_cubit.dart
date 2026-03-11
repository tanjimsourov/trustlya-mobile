import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/market_asset.dart';
import '../../domain/entities/asset_detail.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/trading_repository.dart';
import 'trading_state.dart';

/// Cubit for trading operations.
class TradingCubit extends Cubit<TradingState> {
  final TradingRepository _repository;
  TradingCubit(this._repository) : super(const TradingState());

  Future<void> loadMarketAssets() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getMarketAssets();
    if (result is Success<List<MarketAsset>>) {
      final data = result.value;
      emit(state.copyWith(
          status: data.isEmpty ? Status.empty : Status.success, data: data));
    } else if (result is Error<List<MarketAsset>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> loadAssetDetail(String id) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getAssetDetail(id);
    if (result is Success<AssetDetail>) {
      emit(state.copyWith(status: Status.success, data: result.value));
    } else if (result is Error<AssetDetail>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> placeOrder(Order order) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.placeOrder(order);
    if (result is Success<void>) {
      emit(state.copyWith(status: Status.success));
    } else if (result is Error<void>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }

  Future<void> loadOrderHistory() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _repository.getOrderHistory();
    if (result is Success<List<Order>>) {
      final data = result.value;
      emit(state.copyWith(
          status: data.isEmpty ? Status.empty : Status.success, data: data));
    } else if (result is Error<List<Order>>) {
      emit(state.copyWith(status: Status.error, message: result.message));
    }
  }
}
