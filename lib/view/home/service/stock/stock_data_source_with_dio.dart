import 'package:dio/dio.dart';
import 'package:tradingview_app/view/home/model/stock.dart';
import 'package:tradingview_app/view/home/service/stock/istock_data_source.dart';

class StockDataSourceWithDio extends IStockDataSource {
  StockDataSourceWithDio({required this.dio}) {
    url = 'https://api.example.com/stocks'; // 实际应用中替换为真实的股票API
    header = {
      'Accept': 'application/json',
    };
  }

  late String url;
  late Map<String, String> header;
  final Dio dio;

  @override
  Future<List<Stock>> fetchData() async {
    try {
      // 模拟股票数据，实际应用中应该调用真实的股票API
      final mockStockData = [
        {
          'symbol': '000661',
          'name': '长春高新',
          'exchange': 'SZSE',
          'sector': '生物医药',
          'industry': '生物制药',
          'current_price': 124.33,
          'change': -3.16,
          'change_percent': -2.48,
          'high_52w': 180.50,
          'low_52w': 95.20,
          'volume': 1500000,
          'market_cap': 50000000000,
          'pe_ratio': 25.6,
          'last_updated': DateTime.now().toIso8601String(),
        },
        {
          'symbol': '600036',
          'name': '招商银行',
          'exchange': 'SSE',
          'sector': '金融',
          'industry': '银行',
          'current_price': 45.67,
          'change': 0.23,
          'change_percent': 0.51,
          'high_52w': 52.30,
          'low_52w': 38.90,
          'volume': 2500000,
          'market_cap': 120000000000,
          'pe_ratio': 8.5,
          'last_updated': DateTime.now().toIso8601String(),
        },
        {
          'symbol': 'AAPL',
          'name': 'Apple Inc.',
          'exchange': 'NASDAQ',
          'sector': '科技',
          'industry': '消费电子',
          'current_price': 175.43,
          'change': 2.15,
          'change_percent': 1.24,
          'high_52w': 198.23,
          'low_52w': 124.17,
          'volume': 45000000,
          'market_cap': 2800000000000,
          'pe_ratio': 28.9,
          'last_updated': DateTime.now().toIso8601String(),
        },
        {
          'symbol': 'TSLA',
          'name': 'Tesla Inc.',
          'exchange': 'NASDAQ',
          'sector': '汽车',
          'industry': '电动汽车',
          'current_price': 248.50,
          'change': -5.20,
          'change_percent': -2.05,
          'high_52w': 299.29,
          'low_52w': 138.80,
          'volume': 35000000,
          'market_cap': 790000000000,
          'pe_ratio': 65.2,
          'last_updated': DateTime.now().toIso8601String(),
        },
      ];

      return mockStockData.map((e) => Stock.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch stock data: $e');
    }
  }

  @override
  Future<Stock?> fetchStockBySymbol(String symbol) async {
    final allStocks = await fetchData();
    try {
      return allStocks.firstWhere((stock) => stock.symbol == symbol);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Stock>> fetchStocksByExchange(String exchange) async {
    final allStocks = await fetchData();
    return allStocks.where((stock) => stock.exchange == exchange).toList();
  }
}
