import 'package:tradingview_app/view/home/model/commodity.dart';

abstract class ICommodityDataSource {
  const ICommodityDataSource();
  Future<List<Commodity>> fetchData();
  Future<Commodity?> fetchCommodityBySymbol(String symbol);
  Future<List<Commodity>> fetchCommoditiesByCategory(String category);
}
