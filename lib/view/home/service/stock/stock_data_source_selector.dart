import 'package:tradingview_app/view/home/model/stock.dart';
import 'package:tradingview_app/view/home/service/stock/istock_data_source.dart';
import 'package:tradingview_app/view/home/service/stock/stock_data_source_with_dio.dart';
import 'package:tradingview_app/view/home/service/stock/tushare_stock_data_source.dart';
import 'package:tradingview_app/view/home/service/stock/akshare_stock_data_source.dart';

enum StockDataSourceType {
  tushare,
  akshare,
  mock,
}

class StockDataSourceSelector extends IStockDataSource {
  StockDataSourceSelector({
    required this.tushareDataSource,
    required this.akshareDataSource,
    required this.mockDataSource,
    this.currentType = StockDataSourceType.akshare,
  });

  final TushareStockDataSource tushareDataSource;
  final AkshareStockDataSource akshareDataSource;
  final StockDataSourceWithDio mockDataSource;
  StockDataSourceType currentType;

  IStockDataSource get _currentDataSource {
    switch (currentType) {
      case StockDataSourceType.tushare:
        return tushareDataSource;
      case StockDataSourceType.akshare:
        return akshareDataSource;
      case StockDataSourceType.mock:
        return mockDataSource;
    }
  }

  @override
  Future<List<Stock>> fetchData() async {
    return await _currentDataSource.fetchData();
  }

  @override
  Future<Stock?> fetchStockBySymbol(String symbol) async {
    return await _currentDataSource.fetchStockBySymbol(symbol);
  }

  @override
  Future<List<Stock>> fetchStocksByExchange(String exchange) async {
    return await _currentDataSource.fetchStocksByExchange(exchange);
  }

  // 切换数据源类型
  void switchDataSource(StockDataSourceType type) {
    currentType = type;
    print('Switched to data source: $type');
  }
  
  // 获取当前数据源类型
  StockDataSourceType get currentDataSourceType => currentType;
  
  // 获取所有可用的数据源类型
  List<StockDataSourceType> get availableDataSourceTypes => StockDataSourceType.values;
}
