import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:tradingview_app/view/home/service/forex/forex_data_source_with_dio.dart';
import 'package:tradingview_app/view/home/service/stock/stock_data_source_with_dio.dart';
import 'package:tradingview_app/view/home/service/stock/tushare_stock_data_source.dart';
import 'package:tradingview_app/view/home/service/stock/akshare_stock_data_source.dart';
import 'package:tradingview_app/view/home/service/stock/stock_data_source_selector.dart';
import 'package:tradingview_app/view/home/service/commodity/commodity_data_source_with_dio.dart';
import 'package:tradingview_app/view/home/service/watchlist_service.dart';

class GetItSource {
  factory GetItSource() {
    return _singleton;
  }

  GetItSource._internal();
  static final GetItSource _singleton = GetItSource._internal();

  static final getIt = GetIt.instance;
  static final dio = Dio();

  static void setup() {
    // 注册外汇数据源
    getIt.registerSingleton<ForexDataSourceWithDio>(ForexDataSourceWithDio(dio: dio));
    
    // 注册股票数据源
    getIt.registerSingleton<TushareStockDataSource>(TushareStockDataSource(dio: dio));
    getIt.registerSingleton<AkshareStockDataSource>(AkshareStockDataSource(dio: dio));
    getIt.registerSingleton<StockDataSourceWithDio>(StockDataSourceWithDio(dio: dio));
    
    // 注册股票数据源选择器，默认使用akshare
    getIt.registerSingleton<StockDataSourceSelector>(
      StockDataSourceSelector(
        tushareDataSource: getIt<TushareStockDataSource>(),
        akshareDataSource: getIt<AkshareStockDataSource>(),
        mockDataSource: getIt<StockDataSourceWithDio>(),
            currentType: StockDataSourceType.akshare,
      ),
    );
    
    // 注册商品数据源
    getIt.registerSingleton<CommodityDataSourceWithDio>(CommodityDataSourceWithDio(dio: dio));
    
    // 注册自选列表服务
    getIt.registerSingleton<WatchlistService>(WatchlistService());
  }
}
