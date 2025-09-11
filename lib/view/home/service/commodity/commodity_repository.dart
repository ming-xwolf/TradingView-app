import 'package:tradingview_app/view/home/model/commodity.dart';
import 'package:tradingview_app/view/home/service/commodity/icommodity_data_source.dart';

class CommodityRepository {
  CommodityRepository(this.commodityDataSource);
  final ICommodityDataSource commodityDataSource;

  Future<List<Commodity>> getCommodityList() {
    return commodityDataSource.fetchData();
  }

  Future<Commodity?> getCommodityBySymbol(String symbol) {
    return commodityDataSource.fetchCommodityBySymbol(symbol);
  }

  Future<List<Commodity>> getCommoditiesByCategory(String category) {
    return commodityDataSource.fetchCommoditiesByCategory(category);
  }
}
