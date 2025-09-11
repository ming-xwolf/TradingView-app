import 'package:dio/dio.dart';
import 'package:tradingview_app/view/home/model/forex.dart';
import 'package:tradingview_app/view/home/service/forex/iforex_data_source.dart';

class ForexDataSourceWithDio extends IForexDataSource {
  ForexDataSourceWithDio({required this.dio}) {
    url = 'https://api.exchangerate-api.com/v4/latest/USD';
    header = {
      'Accept': 'application/json',
    };
  }

  late String url;
  late Map<String, String> header;
  final Dio dio;

  @override
  Future<List<Forex>> fetchData() async {
    try {
      // 模拟外汇数据，实际应用中应该调用真实的外汇API
      final mockForexData = [
        {
          'symbol': 'EURUSD',
          'name': 'EUR/USD',
          'base_currency': 'EUR',
          'quote_currency': 'USD',
          'current_price': 1.1693,
          'change': -0.00142,
          'change_percent': -0.12,
          'high_24h': 1.1720,
          'low_24h': 1.1680,
          'volume_24h': 1500000000,
          'last_updated': DateTime.now().toIso8601String(),
        },
        {
          'symbol': 'GBPUSD',
          'name': 'GBP/USD',
          'base_currency': 'GBP',
          'quote_currency': 'USD',
          'current_price': 1.3518,
          'change': -0.00076,
          'change_percent': -0.06,
          'high_24h': 1.3550,
          'low_24h': 1.3500,
          'volume_24h': 800000000,
          'last_updated': DateTime.now().toIso8601String(),
        },
        {
          'symbol': 'USDJPY',
          'name': 'USD/JPY',
          'base_currency': 'USD',
          'quote_currency': 'JPY',
          'current_price': 147.45,
          'change': 0.048,
          'change_percent': 0.03,
          'high_24h': 147.80,
          'low_24h': 147.20,
          'volume_24h': 1200000000,
          'last_updated': DateTime.now().toIso8601String(),
        },
        {
          'symbol': 'USDCNY',
          'name': 'USD/CNY',
          'base_currency': 'USD',
          'quote_currency': 'CNY',
          'current_price': 7.1287,
          'change': 0.0083,
          'change_percent': 0.12,
          'high_24h': 7.1350,
          'low_24h': 7.1200,
          'volume_24h': 2000000000,
          'last_updated': DateTime.now().toIso8601String(),
        },
        {
          'symbol': 'AUDUSD',
          'name': 'AUD/USD',
          'base_currency': 'AUD',
          'quote_currency': 'USD',
          'current_price': 0.7425,
          'change': 0.0012,
          'change_percent': 0.16,
          'high_24h': 0.7450,
          'low_24h': 0.7400,
          'volume_24h': 600000000,
          'last_updated': DateTime.now().toIso8601String(),
        },
      ];

      return mockForexData.map((e) => Forex.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch forex data: $e');
    }
  }

  @override
  Future<Forex?> fetchForexBySymbol(String symbol) async {
    final allForex = await fetchData();
    try {
      return allForex.firstWhere((forex) => forex.symbol == symbol);
    } catch (e) {
      return null;
    }
  }
}
