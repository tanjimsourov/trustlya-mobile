import 'package:get_it/get_it.dart';

import '../core/config/app_backend.dart';
import '../core/config/backend_registry.dart';
import '../core/network/api_client.dart';
import '../features/activity_center/data/repositories/activity_repository_impl.dart';
import '../features/activity_center/domain/repositories/activity_repository.dart';
import '../features/activity_center/presentation/cubit/activity_cubit.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/carbon/data/repositories/carbon_repository_impl.dart';
import '../features/carbon/domain/repositories/carbon_repository.dart';
import '../features/carbon/presentation/cubit/achievements_cubit.dart';
import '../features/carbon/presentation/cubit/carbon_cubit.dart';
import '../features/carbon/presentation/cubit/carbon_history_cubit.dart';
import '../features/carbon/presentation/cubit/holdings_cubit.dart';
import '../features/carbon/presentation/cubit/impact_analytics_cubit.dart';
import '../features/carbon/presentation/cubit/marketplace_dashboard_cubit.dart';
import '../features/carbon/presentation/cubit/project_detail_cubit.dart';
import '../features/carbon/presentation/cubit/projects_cubit.dart';
import '../features/carbon/presentation/cubit/retire_credits_cubit.dart';
import '../features/casino/data/repositories/casino_repository_impl.dart';
import '../features/casino/domain/repositories/casino_repository.dart';
import '../features/casino/presentation/cubit/bet_history_cubit.dart';
import '../features/casino/presentation/cubit/blackjack_game_cubit.dart';
import '../features/casino/presentation/cubit/bonus_cubit.dart';
import '../features/casino/presentation/cubit/casino_cubit.dart';
import '../features/casino/presentation/cubit/casino_lobby_cubit.dart';
import '../features/casino/presentation/cubit/game_detail_cubit.dart';
import '../features/casino/presentation/cubit/responsible_gaming_cubit.dart';
import '../features/casino/presentation/cubit/roulette_game_cubit.dart';
import '../features/casino/presentation/cubit/slots_game_cubit.dart';
import '../features/casino/presentation/cubit/vip_cubit.dart';
import '../features/discover/data/repositories/discover_repository_impl.dart';
import '../features/discover/domain/repositories/discover_repository.dart';
import '../features/discover/presentation/cubit/discover_cubit.dart';
import '../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../features/favorites/domain/repositories/favorites_repository.dart';
import '../features/favorites/presentation/cubit/favorites_cubit.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../features/home/presentation/cubit/dashboard_overview_cubit.dart';
import '../features/home/presentation/cubit/home_cubit.dart';
import '../features/item_trading/data/repositories/item_trading_repository_impl.dart';
import '../features/item_trading/domain/repositories/item_trading_repository.dart';
import '../features/item_trading/presentation/cubit/inventory_cubit.dart';
import '../features/item_trading/presentation/cubit/item_detail_cubit.dart';
import '../features/item_trading/presentation/cubit/market_cubit.dart';
import '../features/item_trading/presentation/cubit/portfolio_analytics_cubit.dart';
import '../features/item_trading/presentation/cubit/trade_builder_cubit.dart';
import '../features/item_trading/presentation/cubit/trade_history_cubit.dart';
import '../features/item_trading/presentation/cubit/trader_profile_cubit.dart';
import '../features/item_trading/presentation/cubit/trading_dashboard_cubit.dart';
import '../features/item_trading/presentation/cubit/watchlist_cubit.dart';
import '../features/kyc/data/repositories/kyc_repository_impl.dart';
import '../features/kyc/domain/repositories/kyc_repository.dart';
import '../features/kyc/presentation/cubit/kyc_cubit.dart';
import '../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../features/notifications/domain/repositories/notifications_repository.dart';
import '../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../features/payment_methods/data/repositories/payment_methods_repository_impl.dart';
import '../features/payment_methods/domain/repositories/payment_methods_repository.dart';
import '../features/payment_methods/presentation/cubit/payment_methods_cubit.dart';
import '../features/post_trade/data/repositories/post_trade_repository_impl.dart';
import '../features/post_trade/domain/repositories/post_trade_repository.dart';
import '../features/post_trade/presentation/cubit/counterparty_exposure_cubit.dart';
import '../features/post_trade/presentation/cubit/exceptions_cubit.dart';
import '../features/post_trade/presentation/cubit/finality_tracker_cubit.dart';
import '../features/post_trade/presentation/cubit/operations_sla_cubit.dart';
import '../features/post_trade/presentation/cubit/post_trade_dashboard_cubit.dart';
import '../features/post_trade/presentation/cubit/reconciliation_cubit.dart';
import '../features/post_trade/presentation/cubit/reporting_audit_cubit.dart';
import '../features/post_trade/presentation/cubit/settlement_detail_cubit.dart';
import '../features/post_trade/presentation/cubit/settlement_queue_cubit.dart';
import '../features/post_trade/presentation/cubit/treasury_position_cubit.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/domain/repositories/profile_repository.dart';
import '../features/profile/presentation/cubit/profile_cubit.dart';
import '../features/promotions/data/repositories/promotions_repository_impl.dart';
import '../features/promotions/domain/repositories/promotions_repository.dart';
import '../features/promotions/presentation/cubit/promotions_cubit.dart';
import '../features/settings/data/repositories/settings_repository_impl.dart';
import '../features/settings/domain/repositories/settings_repository.dart';
import '../features/settings/presentation/cubit/settings_cubit.dart';
import '../features/splash/presentation/cubit/splash_cubit.dart';
import '../features/suggestions/data/repositories/suggestions_repository_impl.dart';
import '../features/suggestions/domain/repositories/suggestions_repository.dart';
import '../features/suggestions/presentation/cubit/suggestions_cubit.dart';
import '../features/tokenization/data/repositories/tokenization_repository_impl.dart';
import '../features/tokenization/domain/repositories/tokenization_repository.dart';
import '../features/tokenization/presentation/cubit/asset_programs_cubit.dart';
import '../features/tokenization/presentation/cubit/cap_table_cubit.dart';
import '../features/tokenization/presentation/cubit/compliance_readiness_cubit.dart';
import '../features/tokenization/presentation/cubit/investor_queue_cubit.dart';
import '../features/tokenization/presentation/cubit/issuance_analytics_cubit.dart';
import '../features/tokenization/presentation/cubit/issuance_workflow_cubit.dart';
import '../features/tokenization/presentation/cubit/lifecycle_events_cubit.dart';
import '../features/tokenization/presentation/cubit/program_detail_cubit.dart';
import '../features/tokenization/presentation/cubit/tokenization_activity_cubit.dart';
import '../features/tokenization/presentation/cubit/tokenization_overview_cubit.dart';
import '../features/trading/data/repositories/trading_repository_impl.dart';
import '../features/trading/domain/repositories/trading_repository.dart';
import '../features/trading/presentation/cubit/trading_cubit.dart';
import '../features/wallet/data/repositories/wallet_repository_impl.dart';
import '../features/wallet/domain/repositories/wallet_repository.dart';
import '../features/wallet/presentation/cubit/asset_detail_cubit.dart';
import '../features/wallet/presentation/cubit/deposit_cubit.dart';
import '../features/wallet/presentation/cubit/fiat_ramp_cubit.dart';
import '../features/wallet/presentation/cubit/linked_methods_cubit.dart';
import '../features/wallet/presentation/cubit/swap_cubit.dart';
import '../features/wallet/presentation/cubit/transaction_history_cubit.dart';
import '../features/wallet/presentation/cubit/wallet_cubit.dart';
import '../features/wallet/presentation/cubit/wallet_overview_cubit.dart';
import '../features/wallet/presentation/cubit/withdraw_cubit.dart';

final GetIt getIt = GetIt.instance;

void init({AppBackendConfig? backendConfig}) {
  if (getIt.isRegistered<AppBackendConfig>()) {
    return;
  }

  final resolvedBackend = backendConfig ?? AppBackendConfig.fromEnvironment();
  getIt.registerSingleton<AppBackendConfig>(resolvedBackend);
  getIt.registerSingleton<BackendRegistry>(BackendRegistry());
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt()));

  getIt.registerLazySingleton<AuthDataSource>(() => _resolveBackendComponent(
        feature: BackendFeature.auth,
        mock: () => MockAuthDataSource(),
      ));
  getIt.registerLazySingleton<HomeDataSource>(() => _resolveBackendComponent(
        feature: BackendFeature.home,
        mock: () => MockHomeDataSource(),
      ));
  getIt
      .registerLazySingleton<ActivityDataSource>(() => _resolveBackendComponent(
            feature: BackendFeature.activity,
            mock: () => MockActivityDataSource(),
          ));
  getIt.registerLazySingleton<TradingDataSource>(() => _resolveBackendComponent(
        feature: BackendFeature.trading,
        mock: () => MockTradingDataSource(),
      ));
  getIt.registerLazySingleton<WalletDataSource>(() => _resolveBackendComponent(
        feature: BackendFeature.wallet,
        mock: () => MockWalletDataSource(),
      ));
  getIt.registerLazySingleton<CarbonDataSource>(() => _resolveBackendComponent(
        feature: BackendFeature.carbon,
        mock: () => MockCarbonDataSource(),
      ));
  getIt.registerLazySingleton<ProfileDataSource>(() => _resolveBackendComponent(
        feature: BackendFeature.profile,
        mock: () => MockProfileDataSource(),
      ));
  getIt.registerLazySingleton<KycDataSource>(() => _resolveBackendComponent(
        feature: BackendFeature.kyc,
        mock: () => MockKycDataSource(),
      ));
  getIt.registerLazySingleton<NotificationsDataSource>(
      () => _resolveBackendComponent(
            feature: BackendFeature.notifications,
            mock: () => MockNotificationsDataSource(),
          ));
  getIt
      .registerLazySingleton<SettingsDataSource>(() => _resolveBackendComponent(
            feature: BackendFeature.settings,
            mock: () => MockSettingsDataSource(),
          ));
  getIt.registerLazySingleton<FavoritesDataSource>(
      () => _resolveBackendComponent(
            feature: BackendFeature.favorites,
            mock: () => MockFavoritesDataSource(),
          ));
  getIt.registerLazySingleton<PromotionsDataSource>(
      () => _resolveBackendComponent(
            feature: BackendFeature.promotions,
            mock: () => MockPromotionsDataSource(),
          ));
  getIt
      .registerLazySingleton<DiscoverDataSource>(() => _resolveBackendComponent(
            feature: BackendFeature.discover,
            mock: () => MockDiscoverDataSource(),
          ));
  getIt.registerLazySingleton<SuggestionsDataSource>(
      () => _resolveBackendComponent(
            feature: BackendFeature.suggestions,
            mock: () => MockSuggestionsDataSource(),
          ));
  getIt.registerLazySingleton<PaymentMethodsDataSource>(
      () => _resolveBackendComponent(
            feature: BackendFeature.paymentMethods,
            mock: () => MockPaymentMethodsDataSource(),
          ));
  getIt.registerLazySingleton<TokenizationDataSource>(
      () => _resolveBackendComponent(
            feature: BackendFeature.tokenization,
            mock: () => MockTokenizationDataSource(),
          ));
  getIt.registerLazySingleton<PostTradeDataSource>(
      () => _resolveBackendComponent(
            feature: BackendFeature.postTrade,
            mock: () => MockPostTradeDataSource(),
          ));

  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(dataSource: getIt()));
  getIt.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(dataSource: getIt()));
  getIt.registerLazySingleton<ActivityRepository>(
      () => ActivityRepositoryImpl(dataSource: getIt()));
  getIt.registerLazySingleton<TradingRepository>(
      () => TradingRepositoryImpl(dataSource: getIt()));
  getIt.registerLazySingleton<WalletRepository>(
      () => WalletRepositoryImpl(dataSource: getIt()));
  getIt.registerLazySingleton<CasinoRepository>(() => _resolveBackendComponent(
        feature: BackendFeature.casino,
        mock: () => CasinoRepositoryImpl(),
      ));
  getIt.registerLazySingleton<CarbonRepository>(
      () => CarbonRepositoryImpl(dataSource: getIt()));
  getIt.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(dataSource: getIt()));
  getIt.registerLazySingleton<KycRepository>(
      () => KycRepositoryImpl(dataSource: getIt()));
  getIt.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepositoryImpl(dataSource: getIt()));
  getIt.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(dataSource: getIt()));
  getIt.registerLazySingleton<FavoritesRepository>(
      () => FavoritesRepositoryImpl(dataSource: getIt()));
  getIt.registerLazySingleton<PromotionsRepository>(
      () => PromotionsRepositoryImpl(dataSource: getIt()));
  getIt.registerLazySingleton<DiscoverRepository>(
      () => DiscoverRepositoryImpl(dataSource: getIt()));
  getIt.registerLazySingleton<SuggestionsRepository>(
      () => SuggestionsRepositoryImpl(dataSource: getIt()));
  getIt.registerLazySingleton<PaymentMethodsRepository>(
      () => PaymentMethodsRepositoryImpl(dataSource: getIt()));
  getIt.registerLazySingleton<ItemTradingRepository>(
      () => _resolveBackendComponent(
            feature: BackendFeature.itemTrading,
            mock: () => ItemTradingRepositoryImpl(),
          ));
  getIt.registerLazySingleton<TokenizationRepository>(
      () => TokenizationRepositoryImpl(dataSource: getIt()));
  getIt.registerLazySingleton<PostTradeRepository>(
      () => PostTradeRepositoryImpl(dataSource: getIt()));

  getIt.registerFactory(() => AuthCubit(getIt()));
  getIt.registerFactory(() => HomeCubit(getIt()));
  getIt.registerFactory(() => ActivityCubit(getIt()));
  getIt.registerFactory(() => TradingCubit(getIt()));
  getIt.registerFactory(() => WalletCubit(getIt()));
  getIt.registerFactory(() => CasinoCubit(getIt()));
  getIt.registerFactory(() => CarbonCubit(getIt()));
  getIt.registerFactory(() => ProfileCubit(getIt()));
  getIt.registerFactory(() => KycCubit(getIt()));
  getIt.registerFactory(() => NotificationsCubit(getIt()));
  getIt.registerFactory(() => SettingsCubit(getIt()));
  getIt.registerFactory(() => PaymentMethodsCubit(getIt()));

  getIt.registerFactory(() => TradingDashboardCubit(getIt()));
  getIt.registerFactory(() => InventoryCubit(getIt()));
  getIt.registerFactory(() => ItemDetailCubit(getIt()));
  getIt.registerFactory(() => MarketCubit(getIt()));
  getIt.registerFactory(() => TradeBuilderCubit());
  getIt.registerFactory(() => TradeHistoryCubit(getIt()));
  getIt.registerFactory(() => PortfolioAnalyticsCubit(getIt()));
  getIt.registerFactory(() => WatchlistCubit(getIt()));
  getIt.registerFactory(() => TraderProfileCubit(getIt()));

  getIt.registerFactory(() => TokenizationOverviewCubit(getIt()));
  getIt.registerFactory(() => AssetProgramsCubit(getIt()));
  getIt.registerFactory(() => ProgramDetailCubit(getIt()));
  getIt.registerFactory(() => IssuanceWorkflowCubit(getIt()));
  getIt.registerFactory(() => InvestorQueueCubit(getIt()));
  getIt.registerFactory(() => CapTableCubit(getIt()));
  getIt.registerFactory(() => LifecycleEventsCubit(getIt()));
  getIt.registerFactory(() => ComplianceReadinessCubit(getIt()));
  getIt.registerFactory(() => IssuanceAnalyticsCubit(getIt()));
  getIt.registerFactory(() => TokenizationActivityCubit(getIt()));

  getIt.registerFactory(() => PostTradeDashboardCubit(getIt()));
  getIt.registerFactory(() => SettlementQueueCubit(getIt()));
  getIt.registerFactory(() => SettlementDetailCubit(getIt()));
  getIt.registerFactory(() => ReconciliationCubit(getIt()));
  getIt.registerFactory(() => ExceptionsCubit(getIt()));
  getIt.registerFactory(() => TreasuryPositionCubit(getIt()));
  getIt.registerFactory(() => CounterpartyExposureCubit(getIt()));
  getIt.registerFactory(() => FinalityTrackerCubit(getIt()));
  getIt.registerFactory(() => ReportingAuditCubit(getIt()));
  getIt.registerFactory(() => OperationsSlaCubit(getIt()));

  getIt.registerFactory(() => SplashCubit());
  getIt.registerFactory(() => DashboardOverviewCubit(getIt(), getIt()));

  getIt.registerFactory(() => CasinoLobbyCubit(getIt()));
  getIt.registerFactory(() => GameDetailCubit(getIt()));
  getIt.registerFactory(() => SlotsGameCubit(getIt()));
  getIt.registerFactory(() => RouletteGameCubit(getIt()));
  getIt.registerFactory(() => BlackjackGameCubit(getIt()));
  getIt.registerFactory(() => BonusCubit(getIt()));
  getIt.registerFactory(() => VipCubit(getIt()));
  getIt.registerFactory(() => BetHistoryCubit(getIt()));
  getIt.registerFactory(() => ResponsibleGamingCubit(getIt()));

  getIt.registerFactory(() => MarketplaceDashboardCubit(getIt()));
  getIt.registerFactory(() => ProjectsCubit(getIt()));
  getIt.registerFactory(() => ProjectDetailCubit(getIt()));
  getIt.registerFactory(() => HoldingsCubit(getIt()));
  getIt.registerFactory(() => RetireCreditsCubit(getIt()));
  getIt.registerFactory(() => CarbonHistoryCubit(getIt()));
  getIt.registerFactory(() => ImpactAnalyticsCubit(getIt()));
  getIt.registerFactory(() => AchievementsCubit(getIt()));

  getIt.registerFactory(() => WalletOverviewCubit(getIt()));
  getIt.registerFactory(() => AssetDetailCubit(getIt()));
  getIt.registerFactory(() => DepositCubit(getIt()));
  getIt.registerFactory(() => WithdrawCubit(getIt()));
  getIt.registerFactory(() => SwapCubit(getIt()));
  getIt.registerFactory(() => TransactionHistoryCubit(getIt()));
  getIt.registerFactory(() => FiatRampCubit(getIt()));
  getIt.registerFactory(() => LinkedMethodsCubit(getIt()));

  getIt.registerFactory(() => FavoritesCubit(getIt()));
  getIt.registerFactory(() => PromotionsCubit(getIt()));
  getIt.registerFactory(() => DiscoverCubit(getIt()));
  getIt.registerFactory(() => SuggestionsCubit(getIt()));
}

T _resolveBackendComponent<T>({
  required BackendFeature feature,
  required T Function() mock,
  T Function(ApiClient client)? api,
}) {
  final registry = getIt<BackendRegistry>();
  final backend = getIt<AppBackendConfig>();
  if (backend.usesApi && api != null && getIt<ApiClient>().isConfigured) {
    registry.register(feature, source: BackendSource.api);
    return api(getIt<ApiClient>());
  }
  if (backend.usesApi) {
    if (!backend.allowMockFallback) {
      throw StateError(
        'No live backend is registered for ${feature.name}. '
        'Set TRUSTLYA_ALLOW_MOCK_FALLBACK=true to permit mock fallback.',
      );
    }
    registry.register(
      feature,
      source: BackendSource.mockFallback,
      note: api == null ? 'No API adapter registered' : 'API base URL missing',
    );
    return mock();
  }
  registry.register(feature, source: BackendSource.mock);
  return mock();
}
