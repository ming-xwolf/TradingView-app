import 'package:tradingview_app/view/home/model/stock.dart';
import 'package:tradingview_app/view/home/service/stock/istock_data_source.dart';

class StockRepository {
  StockRepository(this.stockDataSource);
  final IStockDataSource stockDataSource;

  Future<List<Stock>> getStockList() {
    return stockDataSource.fetchData();
  }

  Future<Stock?> getStockBySymbol(String symbol) {
    return stockDataSource.fetchStockBySymbol(symbol);
  }

  Future<List<Stock>> getStocksByExchange(String exchange) {
    return stockDataSource.fetchStocksByExchange(exchange);
  }
}
