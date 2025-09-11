import 'package:tradingview_app/view/home/model/forex.dart';
import 'package:tradingview_app/view/home/service/forex/iforex_data_source.dart';

class ForexRepository {
  ForexRepository(this.forexDataSource);
  final IForexDataSource forexDataSource;

  Future<List<Forex>> getForexList() {
    return forexDataSource.fetchData();
  }

  Future<Forex?> getForexBySymbol(String symbol) {
    return forexDataSource.fetchForexBySymbol(symbol);
  }
}
