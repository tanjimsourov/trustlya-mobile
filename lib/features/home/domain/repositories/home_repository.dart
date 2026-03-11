import '../../../../core/utils/result.dart';
import '../entities/dashboard_data.dart';
import '../entities/home_item.dart';
import '../entities/news_item.dart';

/// Contract for home feature data.
abstract class HomeRepository {
  Future<Result<DashboardData>> getDashboardData();
  Future<Result<List<HomeItem>>> getTrendingAssets();
  Future<Result<List<NewsItem>>> getNews();
  Future<Result<List<HomeItem>>> search(String query);
}
