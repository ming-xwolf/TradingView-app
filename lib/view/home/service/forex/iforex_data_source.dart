import 'package:tradingview_app/view/home/model/forex.dart';

abstract class IForexDataSource {
  const IForexDataSource();
  Future<List<Forex>> fetchData();
  Future<Forex?> fetchForexBySymbol(String symbol);
}
