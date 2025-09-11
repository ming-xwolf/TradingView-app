import 'package:tradingview_app/view/home/model/stock.dart';

abstract class IStockDataSource {
  const IStockDataSource();
  Future<List<Stock>> fetchData();
  Future<Stock?> fetchStockBySymbol(String symbol);
  Future<List<Stock>> fetchStocksByExchange(String exchange);
}
