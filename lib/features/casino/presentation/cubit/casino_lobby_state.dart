import '../../../../shared/cubit/base_state.dart';
export '../../../../shared/cubit/base_state.dart';
import '../../domain/entities/lobby_data.dart';

/// State for the casino lobby page. Holds [CasinoLobbyData] when
/// successfully loaded.
class CasinoLobbyState extends BaseState<CasinoLobbyData?> {
  const CasinoLobbyState(
      {Status status = Status.initial, CasinoLobbyData? data, String? message})
      : super(status: status, data: data, message: message);

  CasinoLobbyState copyWith(
      {Status? status, CasinoLobbyData? data, String? message}) {
    return CasinoLobbyState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}
