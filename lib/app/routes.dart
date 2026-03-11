import 'package:flutter/material.dart';
// Import pages for each feature
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/verify_otp_page.dart';

import '../features/home/presentation/pages/dashboard_page.dart';
import '../features/home/presentation/pages/trending_assets_page.dart';
import '../features/home/presentation/pages/news_page.dart';
import '../features/home/presentation/pages/search_page.dart';

import '../features/trading/presentation/pages/market_list_page.dart';
import '../features/trading/presentation/pages/asset_detail_page.dart';
import '../features/trading/presentation/pages/trade_page.dart';
import '../features/trading/presentation/pages/order_history_page.dart';

import '../features/wallet/presentation/pages/wallet_overview_page.dart';
import '../features/wallet/presentation/pages/send_page.dart';
import '../features/wallet/presentation/pages/receive_page.dart';
import '../features/wallet/presentation/pages/transaction_history_page.dart';
import '../features/wallet/presentation/pages/asset_detail_page.dart' as wallet;
import '../features/wallet/presentation/pages/deposit_page.dart';
import '../features/wallet/presentation/pages/withdraw_page.dart';
import '../features/wallet/presentation/pages/transfer_confirmation_page.dart';
import '../features/wallet/presentation/pages/swap_page.dart';
import '../features/wallet/presentation/pages/fiat_ramp_page.dart';
import '../features/wallet/presentation/pages/linked_methods_page.dart';

import '../features/casino/presentation/pages/lobby_page.dart';
import '../features/casino/presentation/pages/slots_game_page.dart';
import '../features/casino/presentation/pages/roulette_game_page.dart';
import '../features/casino/presentation/pages/blackjack_game_page.dart';
import '../features/casino/presentation/pages/game_detail_page.dart';
import '../features/casino/presentation/pages/bet_setup_page.dart';
import '../features/casino/presentation/pages/bonus_rewards_page.dart';
import '../features/casino/presentation/pages/vip_loyalty_page.dart';
import '../features/casino/presentation/pages/bet_history_page.dart';
import '../features/casino/presentation/pages/responsible_gaming_page.dart';
import '../features/casino/presentation/cubit/casino_lobby_cubit.dart';
import '../features/casino/presentation/cubit/game_detail_cubit.dart';
import '../features/casino/presentation/cubit/slots_game_cubit.dart';
import '../features/casino/presentation/cubit/roulette_game_cubit.dart';
import '../features/casino/presentation/cubit/blackjack_game_cubit.dart';
import '../features/casino/presentation/cubit/bonus_cubit.dart';
import '../features/casino/presentation/cubit/vip_cubit.dart';
import '../features/casino/presentation/cubit/bet_history_cubit.dart';
import '../features/casino/presentation/cubit/responsible_gaming_cubit.dart';
import '../features/casino/presentation/pages/game_detail_page.dart';
import '../features/casino/presentation/pages/poker_game_page.dart';
import '../features/casino/presentation/pages/casino_history_page.dart';

// Carbon module pages. Aliased imports are used where names clash with other modules.
import '../features/carbon/presentation/pages/dashboard_page.dart'
    as carbon_pages;
import '../features/carbon/presentation/pages/projects_page.dart';
import '../features/carbon/presentation/pages/project_detail_page.dart';
import '../features/carbon/presentation/pages/buy_credits_page.dart';
import '../features/carbon/presentation/pages/holdings_page.dart';
import '../features/carbon/presentation/pages/retire_credits_page.dart';
import '../features/carbon/presentation/pages/retirement_confirmation_page.dart';
import '../features/carbon/presentation/pages/impact_analytics_page.dart';
import '../features/carbon/presentation/pages/achievements_page.dart';
import '../features/carbon/presentation/pages/carbon_history_page.dart';

// Tokenisation pages
import '../features/tokenization/presentation/pages/tokenization_overview_page.dart';
import '../features/tokenization/presentation/pages/asset_programs_page.dart';
import '../features/tokenization/presentation/pages/program_detail_page.dart';
import '../features/tokenization/presentation/pages/issuance_workflow_page.dart';
import '../features/tokenization/presentation/pages/investor_queue_page.dart';
import '../features/tokenization/presentation/pages/cap_table_page.dart';
import '../features/tokenization/presentation/pages/lifecycle_events_page.dart';
import '../features/tokenization/presentation/pages/compliance_readiness_page.dart';
import '../features/tokenization/presentation/pages/issuance_analytics_page.dart';
import '../features/tokenization/presentation/pages/tokenization_activity_page.dart';

// Post‑trade operations pages
import '../features/post_trade/presentation/pages/post_trade_dashboard_page.dart';
import '../features/post_trade/presentation/pages/settlement_queue_page.dart';
import '../features/post_trade/presentation/pages/settlement_detail_page.dart';
import '../features/post_trade/presentation/pages/reconciliation_center_page.dart';
import '../features/post_trade/presentation/pages/exceptions_page.dart';
import '../features/post_trade/presentation/pages/treasury_position_page.dart';
import '../features/post_trade/presentation/pages/counterparty_exposure_page.dart';
import '../features/post_trade/presentation/pages/finality_tracker_page.dart';
import '../features/post_trade/presentation/pages/reporting_audit_page.dart';
import '../features/post_trade/presentation/pages/operations_sla_page.dart';

// Enterprise hub page
import '../features/enterprise/presentation/pages/enterprise_hub_page.dart';

// Carbon cubit imports for routing
import '../features/carbon/presentation/cubit/marketplace_dashboard_cubit.dart';
import '../features/carbon/presentation/cubit/projects_cubit.dart';
import '../features/carbon/presentation/cubit/project_detail_cubit.dart';
import '../features/carbon/presentation/cubit/holdings_cubit.dart';
import '../features/carbon/presentation/cubit/retire_credits_cubit.dart';
import '../features/carbon/presentation/cubit/carbon_history_cubit.dart';
import '../features/carbon/presentation/cubit/impact_analytics_cubit.dart';
import '../features/carbon/presentation/cubit/achievements_cubit.dart';
import '../features/carbon/domain/entities/carbon_transaction.dart';

import '../features/profile/presentation/pages/profile_overview_page.dart';
import '../features/profile/presentation/pages/edit_profile_page.dart';
import '../features/profile/presentation/pages/security_center_page.dart';
import '../features/profile/presentation/pages/preferences_page.dart';

// Payment methods
import '../features/payment_methods/presentation/pages/payment_methods_page.dart';
import '../features/payment_methods/presentation/pages/add_payment_method_page.dart';

// Change password and two factor setup
import '../features/profile/presentation/pages/change_password_page.dart';
import '../features/profile/presentation/pages/two_factor_setup_page.dart';

// Help & support
import '../features/help/presentation/pages/help_support_page.dart';

import '../features/kyc/presentation/pages/kyc_start_page.dart';
import '../features/kyc/presentation/pages/identity_upload_page.dart';
import '../features/kyc/presentation/pages/document_upload_page.dart';
import '../features/kyc/presentation/pages/kyc_status_page.dart';

import '../features/notifications/presentation/pages/notifications_list_page.dart';
import '../features/notifications/presentation/pages/notification_detail_page.dart';
import '../features/notifications/presentation/pages/notification_settings_page.dart';
import '../features/notifications/presentation/pages/push_preferences_page.dart';

import '../features/settings/presentation/pages/general_settings_page.dart';
import '../features/settings/presentation/pages/privacy_settings_page.dart';
import '../features/settings/presentation/pages/theme_selection_page.dart';
import '../features/settings/presentation/pages/language_settings_page.dart';

// Shared feature pages imports
import '../features/search/presentation/pages/search_page.dart'
    as global_search_page;
import '../features/activity_center/presentation/pages/activity_center_page.dart';
import '../features/market_insights/presentation/pages/market_insights_page.dart';
import '../features/rewards/presentation/pages/rewards_page.dart';
import '../features/referral/presentation/pages/referral_page.dart';
import '../features/quick_actions/presentation/pages/quick_actions_page.dart';
import '../features/favorites/presentation/pages/favorites_page.dart';
import '../features/promotions/presentation/pages/promotions_page.dart';
import '../features/discover/presentation/pages/discover_page.dart';
import '../features/suggestions/presentation/pages/smart_suggestions_page.dart';

// Design system showcase
import '../features/design_system/presentation/pages/design_system_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dependency_injection.dart';

// State definitions for passing arguments to trade review
import '../features/item_trading/presentation/cubit/trade_builder_state.dart';

// Item trading pages
import '../features/item_trading/presentation/pages/trading_dashboard_page.dart';
import '../features/item_trading/presentation/pages/inventory_page.dart';
import '../features/item_trading/presentation/pages/item_detail_page.dart';
import '../features/item_trading/presentation/pages/market_page.dart';
import '../features/item_trading/presentation/pages/trade_builder_page.dart';
import '../features/item_trading/presentation/pages/trade_review_page.dart';
import '../features/item_trading/presentation/pages/trade_history_page.dart';
import '../features/item_trading/presentation/pages/portfolio_analytics_page.dart';
import '../features/item_trading/presentation/pages/watchlist_page.dart';
import '../features/item_trading/presentation/pages/trader_profile_page.dart';

// New pages
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/app_shell/presentation/pages/app_shell_page.dart';
import '../features/settings/presentation/pages/settings_overview_page.dart';
import '../features/splash/presentation/cubit/splash_cubit.dart';

/// Contains route definitions and the onGenerateRoute function.
class Routes {
  Routes._();

  // Initial route of the application. Start with the splash screen.
  static const String initial = splash;

  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot_password';
  static const String verifyOtp = '/verify_otp';

  // Core app routes
  /// Splash screen displayed at app launch.
  static const String splash = '/';

  /// Onboarding flow introducing core modules.
  static const String onboarding = '/onboarding';

  /// Container shell housing the main navigation for logged in users.
  static const String shell = '/shell';

  // Home routes
  static const String dashboard = '/dashboard';
  static const String trendingAssets = '/trending_assets';
  static const String news = '/news';
  static const String search = '/search';

  // Trading routes
  static const String marketList = '/market_list';
  static const String assetDetail = '/asset_detail';
  static const String trade = '/trade';
  static const String orderHistory = '/order_history';

  // Wallet routes
  static const String walletOverview = '/wallet_overview';
  // Deprecated send route (retained for backwards compatibility)
  static const String send = '/send';
  // General receive route maintained for backwards compatibility. For the
  // updated receive/deposit UI use [walletReceive].
  static const String receive = '/receive';
  // Shows a QR code and address for receiving a specific asset. This
  // modern receive page replaces the legacy [receive] route.
  static const String walletReceive = '/wallet_receive';
  // Initiates a deposit flow for a particular asset. The same as
  // [walletReceive] but includes network selection and status.
  static const String deposit = '/deposit';
  // Initiates a withdrawal flow for a particular asset.
  static const String withdraw = '/withdraw';
  // Allows converting between two assets (e.g. BTC → ETH).
  static const String swapAssets = '/swap_assets';
  // Confirmation screen shown after a transfer is submitted (deposit,
  // withdrawal or swap). Displays summary and result state.
  static const String transferConfirmation = '/transfer_confirmation';
  // Displays details for a single asset in the wallet.
  static const String walletAssetDetail = '/wallet_asset_detail';
  // View the user's wallet transaction history with filters.
  static const String transactionHistory = '/transaction_history';
  // Fiat on/off ramp listing available providers.
  static const String fiatRamp = '/fiat_ramp';
  // View and manage linked payout/bank methods. Use this to add
  // or remove payout methods used for withdrawals.
  static const String linkedMethods = '/linked_methods';

  // Shared feature routes
  /// Global search across all modules (items, games, assets, projects, transactions).
  static const String globalSearch = '/global_search';

  /// Unified activity centre showing events from trading, wallet, casino and carbon modules.
  static const String activityCenter = '/activity_center';

  /// Market insights and trends across assets and items.
  static const String marketInsights = '/market_insights';

  /// Rewards and missions page aggregating missions across modules.
  static const String rewards = '/rewards';

  /// Referral and invite screen where users can invite friends.
  static const String referral = '/referral';

  /// Quick actions hub for high level cross‑module actions.
  static const String quickActions = '/quick_actions';

  /// Favourites page listing saved items, games, projects and methods.
  static const String favourites = '/favourites';

  /// Promotions and offers page listing active promotions across modules.
  static const String promotions = '/promotions';

  /// Discover page for curated explore content across modules.
  static const String discover = '/discover';

  /// Smart suggestions page providing contextual recommendations.
  static const String smartSuggestions = '/smart_suggestions';

  // Casino routes
  static const String lobby = '/casino_lobby';
  static const String slotsGame = '/slots_game';

  /// Routes to the roulette game screen.
  static const String rouletteGame = '/roulette_game';

  /// Routes to the blackjack game screen.
  static const String blackjackGame = '/blackjack_game';

  /// Detailed game page showing metadata and play CTA.
  static const String gameDetail = '/casino_game_detail';

  /// Bet setup screen for configuring wager amount and lines.
  static const String betSetup = '/bet_setup';

  /// Bonus & rewards listing page.
  static const String bonusRewards = '/bonus_rewards';

  /// VIP & loyalty tier overview.
  static const String vipLoyalty = '/vip_loyalty';

  /// Betting history listing page.
  static const String betHistory = '/bet_history';

  /// Responsible gaming information and settings.
  static const String responsibleGaming = '/responsible_gaming';
  // Legacy poker and casino history constants retained for backwards compatibility.
  static const String pokerGame = '/poker_game';
  static const String casinoHistory = '/casino_history';

  // Carbon routes
  static const String carbonMarketplace = '/carbon_marketplace';
  static const String creditDetail = '/credit_detail';
  static const String buyCredits = '/buy_credits';
  static const String sellCredits = '/sell_credits';
  // New carbon marketplace routes
  /// Carbon dashboard summarising credits held, impact and featured projects.
  static const String carbonDashboard = '/carbon_dashboard';

  /// Listing of available carbon projects with filtering and search.
  static const String carbonProjects = '/carbon_projects';

  /// Details page for a single carbon project.
  static const String carbonProjectDetail = '/carbon_project_detail';

  /// Screen for purchasing credits from a project.
  static const String carbonBuy = '/carbon_buy';

  /// View of the user’s carbon credit holdings.
  static const String carbonHoldings = '/carbon_holdings';

  /// Screen to retire credits from holdings.
  static const String carbonRetire = '/carbon_retire';

  /// Success screen shown after retiring credits.
  static const String carbonRetireConfirm = '/carbon_retire_confirm';

  /// Impact analytics dashboard showing offset charts and breakdowns.
  static const String carbonImpact = '/carbon_impact';

  /// Achievements and badges screen showcasing milestones.
  static const String carbonAchievements = '/carbon_achievements';

  /// Carbon transaction history listing purchases and retirements.
  static const String carbonHistory = '/carbon_history';

  // Profile routes
  static const String profileView = '/profile_view';
  static const String editProfile = '/edit_profile';
  static const String securitySettings = '/security_settings';
  static const String preferences = '/preferences';

  // New account & security routes
  /// Page for changing the user's password.
  static const String changePassword = '/change_password';

  /// Page for setting up two factor authentication.
  static const String twoFactorSetup = '/two_factor_setup';

  // Payment methods
  /// Lists the user's saved payment methods.
  static const String paymentMethods = '/payment_methods';

  /// Form to add a new payment method.
  static const String addPaymentMethod = '/add_payment_method';

  // Support
  /// Help & support centre with FAQs and ticket contact.
  static const String helpSupport = '/help_support';

  // KYC routes
  static const String kycStart = '/kyc_start';
  static const String identityUpload = '/identity_upload';
  static const String documentUpload = '/document_upload';
  static const String kycStatus = '/kyc_status';

  // Notifications routes
  static const String notificationsList = '/notifications_list';
  static const String notificationDetail = '/notification_detail';
  static const String notificationSettings = '/notification_settings';
  static const String pushPreferences = '/push_preferences';

  // Settings routes
  static const String generalSettings = '/general_settings';
  static const String privacySettings = '/privacy_settings';
  static const String themeSelection = '/theme_selection';
  static const String languageSettings = '/language_settings';

  // Additional overview routes
  /// Settings overview listing account and preferences sections.
  static const String settingsOverview = '/settings_overview';

  /// Notifications centre accessed from the app shell. Points to the
  /// notifications list page.
  static const String notifications = '/notifications';

  // --------------------------------------------------------------------------
  // Game item trading routes
  // These routes power the game item trading module. They are separate from
  // the cryptocurrency trading routes defined above and provide a premium
  // marketplace experience for trading in‑game items. Each screen is
  // represented by its own route constant to ensure clear navigation.

  /// Dashboard for the game item trading module. Shows total inventory value,
  /// gain/loss summary, trending items, alerts and recent trades.
  static const String itemTradingDashboard = '/item_trading_dashboard';
  static const String tradingDashboard = itemTradingDashboard;

  /// Displays the user’s inventory of game items with filtering, sorting
  /// and grid/list toggles.
  static const String inventory = '/inventory';

  /// Details page for a single game item. Shows artwork, metadata,
  /// current price, a mini chart and actions to trade or watch the item.
  static const String itemDetail = '/item_detail';

  /// Market browse page listing all available items with discovery and
  /// filtering options.
  static const String market = '/market';

  /// Step one of the trading workflow. Allows users to build a trade by
  /// selecting offered and requested items and comparing values.
  static const String tradeBuilder = '/trade_builder';

  /// Step two of the trading workflow. Presents a summary of the selected
  /// items, values, fees and allows the user to confirm the trade.
  static const String tradeReview = '/trade_review';

  /// Displays the user’s past trades segmented by status (pending,
  /// completed, cancelled).
  static const String tradeHistory = '/trade_history';

  /// Shows portfolio analytics such as performance over time, rarity
  /// distribution and best performing items.
  static const String portfolioAnalytics = '/portfolio_analytics';

  /// Lists the user’s watchlist of tracked items with target price alerts.
  static const String watchlist = '/watchlist';

  /// Public profile view of another trader including trust score,
  /// completed trades, badges and inventory preview.
  static const String traderProfile = '/trader_profile';

  // --------------------------------------------------------------------------
  // Tokenisation routes
  // These routes power the enterprise tokenisation module. They provide
  // navigation to overviews, programmes, workflow and analytics screens.
  /// Tokenisation hub overview displaying high level metrics and actions.
  static const String tokenizationOverview = '/tokenization_overview';

  /// Listing of all tokenised asset programmes.
  static const String tokenizationPrograms = '/tokenization_programs';

  /// Detail page for a single asset programme. Accepts a programme id
  /// as a String argument via [RouteSettings.arguments].
  static const String tokenizationProgramDetail =
      '/tokenization_program_detail';

  /// Issuance workflow view for a programme. Accepts programme id.
  static const String tokenizationIssuanceWorkflow =
      '/tokenization_issuance_workflow';

  /// Investor onboarding queue listing pending cases.
  static const String tokenizationInvestorQueue =
      '/tokenization_investor_queue';

  /// Ownership or cap table view for a programme. Accepts programme id.
  static const String tokenizationCapTable = '/tokenization_cap_table';

  /// Lifecycle events timeline for a programme. Accepts programme id.
  static const String tokenizationLifecycleEvents =
      '/tokenization_lifecycle_events';

  /// Compliance readiness checklist for a programme. Accepts programme id.
  static const String tokenizationCompliance = '/tokenization_compliance';

  /// Issuance analytics dashboard for a programme. Accepts programme id.
  static const String tokenizationAnalytics = '/tokenization_analytics';

  /// Activity feed aggregating recent tokenisation actions.
  static const String tokenizationActivity = '/tokenization_activity';

  // ------------------------------------------------------------------
  // Post‑trade operations module
  /// Dashboard overview for post‑trade operations including high level metrics
  /// and entry points into settlement, reconciliation, exceptions and analytics.
  static const String postTradeDashboard = '/post_trade_dashboard';

  /// Queue of settlement instructions awaiting processing.
  static const String postTradeSettlementQueue = '/post_trade_settlement_queue';

  /// Detailed view of a single settlement instruction. Accepts an id via
  /// [RouteSettings.arguments].
  static const String postTradeSettlementDetail =
      '/post_trade_settlement_detail';

  /// Reconciliation center listing matched and unmatched trades/payments.
  static const String postTradeReconciliation = '/post_trade_reconciliation';

  /// Exceptions and breaks view with severity filtering.
  static const String postTradeExceptions = '/post_trade_exceptions';

  /// Treasury positioning with cash balances and movements.
  static const String postTradeTreasury = '/post_trade_treasury';

  /// Counterparty exposure dashboard.
  static const String postTradeExposure = '/post_trade_exposure';

  /// Transfer finality tracker showing settlement status timeline.
  static const String postTradeFinalityTracker = '/post_trade_finality_tracker';

  /// Reporting and audit trail page.
  static const String postTradeReportingAudit = '/post_trade_reporting_audit';

  /// Operations service level monitoring.
  static const String postTradeSlaMonitoring = '/post_trade_sla_monitoring';

  // ------------------------------------------------------------------
  // Enterprise discovery hub
  /// Enterprise solutions hub aggregating tokenisation and post‑trade modules.
  static const String enterpriseHub = '/enterprise_hub';

  // Design system route (for development and preview)
  static const String designSystem = '/design_system';

  /// Generates routes for the application. Each case returns a MaterialPageRoute
  /// configured with the corresponding page. Unknown routes fallback to a
  /// simple [Scaffold] displaying a not found message.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Splash & onboarding
      case splash:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<SplashCubit>(
            create: (_) => getIt<SplashCubit>(),
            child: const SplashPage(),
          ),
        );
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case shell:
        return MaterialPageRoute(builder: (_) => const AppShellPage());
      // Auth
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      case verifyOtp:
        return MaterialPageRoute(builder: (_) => const VerifyOtpPage());

      // Home
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case trendingAssets:
        return MaterialPageRoute(builder: (_) => const TrendingAssetsPage());
      case news:
        return MaterialPageRoute(builder: (_) => const NewsPage());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchPage());

      // Trading
      case marketList:
        return MaterialPageRoute(builder: (_) => const MarketListPage());
      case assetDetail:
        return MaterialPageRoute(builder: (_) => const AssetDetailPage());
      case trade:
        return MaterialPageRoute(builder: (_) => const TradePage());
      case orderHistory:
        return MaterialPageRoute(builder: (_) => const OrderHistoryPage());

      // Wallet
      case walletOverview:
        return MaterialPageRoute(builder: (_) => const WalletOverviewPage());
      case send:
        return MaterialPageRoute(builder: (_) => const SendPage());
      case receive:
        // Legacy receive route falls back to the generic receive page without symbol
        return MaterialPageRoute(
            builder: (_) => const ReceivePage(symbol: 'BTC'));
      case walletReceive:
        // New receive page accepts a symbol argument to display QR and address
        final symbol = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ReceivePage(symbol: symbol));
      case deposit:
        // Deposit page requires a symbol argument to load networks and address
        final symbol = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => DepositPage(symbol: symbol));
      case withdraw:
        // Withdraw page requires a symbol argument to load networks and balance
        final symbol = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => WithdrawPage(symbol: symbol));
      case swapAssets:
        return MaterialPageRoute(builder: (_) => const SwapPage());
      case transferConfirmation:
        final args = settings.arguments as TransferConfirmationArgs;
        return MaterialPageRoute(
            builder: (_) => TransferConfirmationPage(args: args));
      case walletAssetDetail:
        final symbol = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => wallet.AssetDetailPage(symbol: symbol));
      case transactionHistory:
        return MaterialPageRoute(
            builder: (_) => const TransactionHistoryPage());
      case fiatRamp:
        return MaterialPageRoute(builder: (_) => const FiatRampPage());
      case linkedMethods:
        return MaterialPageRoute(builder: (_) => const LinkedMethodsPage());

      // Shared features
      case globalSearch:
        // Global search uses its own BlocProvider internally
        return MaterialPageRoute(
            builder: (_) => const global_search_page.SearchPage());
      case activityCenter:
        return MaterialPageRoute(builder: (_) => const ActivityCenterPage());
      case marketInsights:
        return MaterialPageRoute(builder: (_) => const MarketInsightsPage());
      case rewards:
        return MaterialPageRoute(builder: (_) => const RewardsPage());
      case referral:
        return MaterialPageRoute(builder: (_) => const ReferralPage());
      case quickActions:
        return MaterialPageRoute(builder: (_) => const QuickActionsPage());
      case favourites:
        return MaterialPageRoute(builder: (_) => const FavoritesPage());
      case promotions:
        return MaterialPageRoute(builder: (_) => const PromotionsPage());
      case discover:
        return MaterialPageRoute(builder: (_) => const DiscoverPage());
      case smartSuggestions:
        return MaterialPageRoute(builder: (_) => const SmartSuggestionsPage());

      // Casino
      case lobby:
        // New lobby uses CasinoLobbyCubit to fetch aggregated data.
        return MaterialPageRoute(
          builder: (_) => BlocProvider<CasinoLobbyCubit>(
            create: (_) => getIt<CasinoLobbyCubit>()..load(),
            child: const LobbyPage(),
          ),
        );
      case gameDetail:
        final id = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider<GameDetailCubit>(
            create: (_) => getIt<GameDetailCubit>()..load(id),
            child: GameDetailPage(gameId: id),
          ),
        );
      case slotsGame:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<SlotsGameCubit>(
            create: (_) => getIt<SlotsGameCubit>(),
            child: const SlotsGamePage(),
          ),
        );
      case rouletteGame:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<RouletteGameCubit>(
            create: (_) => getIt<RouletteGameCubit>(),
            child: const RouletteGamePage(),
          ),
        );
      case blackjackGame:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<BlackjackGameCubit>(
            create: (_) => getIt<BlackjackGameCubit>(),
            child: const BlackjackGamePage(),
          ),
        );
      case betSetup:
        final args = settings.arguments as BetSetupArgs?;
        return MaterialPageRoute(builder: (_) => BetSetupPage(args: args));
      case bonusRewards:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<BonusCubit>(
            create: (_) => getIt<BonusCubit>()..load(),
            child: const BonusRewardsPage(),
          ),
        );
      case vipLoyalty:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<VipCubit>(
            create: (_) => getIt<VipCubit>()..load(),
            child: const VipLoyaltyPage(),
          ),
        );
      case betHistory:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<BetHistoryCubit>(
            create: (_) => getIt<BetHistoryCubit>()..load(),
            child: const BetHistoryPage(),
          ),
        );
      case responsibleGaming:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<ResponsibleGamingCubit>(
            create: (_) => getIt<ResponsibleGamingCubit>()..load(),
            child: const ResponsibleGamingPage(),
          ),
        );
      // Legacy pages
      case pokerGame:
        return MaterialPageRoute(builder: (_) => const PokerGamePage());
      case casinoHistory:
        return MaterialPageRoute(builder: (_) => const CasinoHistoryPage());

      // Carbon
      case carbonMarketplace:
        // Redirect legacy carbon marketplace to the new dashboard
        return MaterialPageRoute(
          builder: (_) => BlocProvider<MarketplaceDashboardCubit>(
            create: (_) => getIt<MarketplaceDashboardCubit>()..load(),
            child: carbon_pages.CarbonDashboardPage(),
          ),
        );
      case creditDetail:
        // Redirect legacy credit detail to the new project detail
        final id = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => BlocProvider<ProjectDetailCubit>(
            create: (_) => getIt<ProjectDetailCubit>()..load(id),
            child: ProjectDetailPage(projectId: id),
          ),
        );
      case buyCredits:
        // Redirect legacy buy credits page to the new purchase screen
        final id = settings.arguments as String? ?? '';
        return MaterialPageRoute(builder: (_) => BuyCreditsPage(projectId: id));
      case sellCredits:
        // Redirect legacy sell to the retire page
        return MaterialPageRoute(
          builder: (_) => BlocProvider<RetireCreditsCubit>(
            create: (_) => getIt<RetireCreditsCubit>()..loadHoldings(),
            child: const RetireCreditsPage(),
          ),
        );

      // New carbon routes
      case carbonDashboard:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<MarketplaceDashboardCubit>(
            create: (_) => getIt<MarketplaceDashboardCubit>()..load(),
            child: carbon_pages.CarbonDashboardPage(),
          ),
        );
      case carbonProjects:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<ProjectsCubit>(
            create: (_) => getIt<ProjectsCubit>()..load(),
            child: const ProjectsPage(),
          ),
        );
      case carbonProjectDetail:
        final id2 = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider<ProjectDetailCubit>(
            create: (_) => getIt<ProjectDetailCubit>()..load(id2),
            child: ProjectDetailPage(projectId: id2),
          ),
        );
      case carbonBuy:
        final id3 = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => BuyCreditsPage(projectId: id3));
      case carbonHoldings:
        return MaterialPageRoute(builder: (_) => const HoldingsPage());
      case carbonRetire:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<RetireCreditsCubit>(
            create: (_) => getIt<RetireCreditsCubit>()..loadHoldings(),
            child: const RetireCreditsPage(),
          ),
        );
      case carbonRetireConfirm:
        final tx = settings.arguments as CarbonTransaction;
        return MaterialPageRoute(
            builder: (_) => RetirementConfirmationPage(transaction: tx));
      case carbonImpact:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<ImpactAnalyticsCubit>(
            create: (_) => getIt<ImpactAnalyticsCubit>()..load(),
            child: const ImpactAnalyticsPage(),
          ),
        );
      case carbonAchievements:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AchievementsCubit>(
            create: (_) => getIt<AchievementsCubit>()..load(),
            child: const AchievementsPage(),
          ),
        );
      case carbonHistory:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<CarbonHistoryCubit>(
            create: (_) => getIt<CarbonHistoryCubit>()..load(),
            child: const CarbonHistoryPage(),
          ),
        );

      // Profile
      case profileView:
        return MaterialPageRoute(builder: (_) => const ProfileOverviewPage());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfilePage());
      case securitySettings:
        // Navigate to the security centre page (expanded security settings)
        return MaterialPageRoute(builder: (_) => const SecurityCenterPage());
      case changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordPage());
      case twoFactorSetup:
        return MaterialPageRoute(builder: (_) => const TwoFactorSetupPage());

      // Payment methods
      case paymentMethods:
        return MaterialPageRoute(builder: (_) => const PaymentMethodsPage());
      case addPaymentMethod:
        return MaterialPageRoute(builder: (_) => const AddPaymentMethodPage());

      // Support
      case helpSupport:
        return MaterialPageRoute(builder: (_) => const HelpSupportPage());
      case preferences:
        return MaterialPageRoute(builder: (_) => const PreferencesPage());

      // KYC
      case kycStart:
        return MaterialPageRoute(builder: (_) => const KycStartPage());
      case identityUpload:
        return MaterialPageRoute(builder: (_) => const IdentityUploadPage());
      case documentUpload:
        return MaterialPageRoute(builder: (_) => const DocumentUploadPage());
      case kycStatus:
        return MaterialPageRoute(builder: (_) => const KycStatusPage());

      // Notifications
      case notificationsList:
        return MaterialPageRoute(builder: (_) => const NotificationsListPage());
      case notificationDetail:
        return MaterialPageRoute(
            builder: (_) => const NotificationDetailPage());
      case notificationSettings:
        return MaterialPageRoute(
            builder: (_) => const NotificationSettingsPage());
      case pushPreferences:
        return MaterialPageRoute(builder: (_) => const PushPreferencesPage());

      // Settings
      case generalSettings:
        return MaterialPageRoute(builder: (_) => const GeneralSettingsPage());
      case privacySettings:
        return MaterialPageRoute(builder: (_) => const PrivacySettingsPage());
      case themeSelection:
        return MaterialPageRoute(builder: (_) => const ThemeSelectionPage());
      case languageSettings:
        return MaterialPageRoute(builder: (_) => const LanguageSettingsPage());

      // Overview & misc
      case settingsOverview:
        return MaterialPageRoute(builder: (_) => const SettingsOverviewPage());
      case notifications:
        // Reuse the notifications list page for the notifications centre
        return MaterialPageRoute(builder: (_) => const NotificationsListPage());

      // Design system
      case designSystem:
        return MaterialPageRoute(builder: (_) => const DesignSystemPage());

      // Item trading module
      case itemTradingDashboard:
        return MaterialPageRoute(builder: (_) => const TradingDashboardPage());
      case inventory:
        return MaterialPageRoute(builder: (_) => const InventoryPage());
      case itemDetail:
        final id = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ItemDetailPage(itemId: id));
      case market:
        return MaterialPageRoute(builder: (_) => const MarketPage());
      case tradeBuilder:
        return MaterialPageRoute(builder: (_) => const TradeBuilderPage());
      case tradeReview:
        final tradeState = settings.arguments as TradeBuilderState;
        return MaterialPageRoute(
            builder: (_) => TradeReviewPage(tradeState: tradeState));
      case tradeHistory:
        return MaterialPageRoute(builder: (_) => const TradeHistoryPage());
      case portfolioAnalytics:
        return MaterialPageRoute(
            builder: (_) => const PortfolioAnalyticsPage());
      case watchlist:
        return MaterialPageRoute(builder: (_) => const WatchlistPage());
      case traderProfile:
        final traderId = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => TraderProfilePage(traderId: traderId));

      // ------------------------------------------------------------------
      // Tokenisation module
      case tokenizationOverview:
        return MaterialPageRoute(
            builder: (_) => const TokenizationOverviewPage());
      case tokenizationPrograms:
        return MaterialPageRoute(builder: (_) => const AssetProgramsPage());
      case tokenizationProgramDetail:
        // Propagate the programme id via route settings so the page can
        // access it through ModalRoute.of(context)?.settings.arguments.
        return MaterialPageRoute(
            builder: (_) => const ProgramDetailPage(), settings: settings);
      case tokenizationIssuanceWorkflow:
        return MaterialPageRoute(
            builder: (_) => const IssuanceWorkflowPage(), settings: settings);
      case tokenizationInvestorQueue:
        return MaterialPageRoute(builder: (_) => const InvestorQueuePage());
      case tokenizationCapTable:
        return MaterialPageRoute(
            builder: (_) => const CapTablePage(), settings: settings);
      case tokenizationLifecycleEvents:
        return MaterialPageRoute(
            builder: (_) => const LifecycleEventsPage(), settings: settings);
      case tokenizationCompliance:
        return MaterialPageRoute(
            builder: (_) => const ComplianceReadinessPage(),
            settings: settings);
      case tokenizationAnalytics:
        return MaterialPageRoute(
            builder: (_) => const IssuanceAnalyticsPage(), settings: settings);
      case tokenizationActivity:
        return MaterialPageRoute(
            builder: (_) => const TokenizationActivityPage());

      // ------------------------------------------------------------------
      // Post‑trade operations module
      case postTradeDashboard:
        return MaterialPageRoute(
            builder: (_) => const PostTradeDashboardPage());
      case postTradeSettlementQueue:
        return MaterialPageRoute(builder: (_) => const SettlementQueuePage());
      case postTradeSettlementDetail:
        // The settlement id is passed via [RouteSettings.arguments] so the
        // page can fetch the appropriate data. Use [settings] to pass
        // through the arguments unchanged.
        return MaterialPageRoute(
            builder: (_) => const SettlementDetailPage(), settings: settings);
      case postTradeReconciliation:
        return MaterialPageRoute(
            builder: (_) => const ReconciliationCenterPage());
      case postTradeExceptions:
        return MaterialPageRoute(builder: (_) => const ExceptionsPage());
      case postTradeTreasury:
        return MaterialPageRoute(builder: (_) => const TreasuryPositionPage());
      case postTradeExposure:
        return MaterialPageRoute(
            builder: (_) => const CounterpartyExposurePage());
      case postTradeFinalityTracker:
        return MaterialPageRoute(builder: (_) => const FinalityTrackerPage());
      case postTradeReportingAudit:
        return MaterialPageRoute(builder: (_) => const ReportingAuditPage());
      case postTradeSlaMonitoring:
        return MaterialPageRoute(builder: (_) => const OperationsSlaPage());

      // ------------------------------------------------------------------
      // Enterprise hub
      case enterpriseHub:
        return MaterialPageRoute(builder: (_) => const EnterpriseHubPage());

      default:
        // Unknown route fallback
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Page Not Found')),
            body: const Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
