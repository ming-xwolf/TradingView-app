import 'package:dio/dio.dart';
import 'package:tradingview_app/view/home/model/commodity.dart';
import 'package:tradingview_app/view/home/service/commodity/icommodity_data_source.dart';

class CommodityDataSourceWithDio extends ICommodityDataSource {
  CommodityDataSourceWithDio({required this.dio}) {
    url = 'https://api.example.com/commodities'; // 实际应用中替换为真实的商品API
    header = {
      'Accept': 'application/json',
    };
  }

  late String url;
  late Map<String, String> header;
  final Dio dio;

  @override
  Future<List<Commodity>> fetchData() async {
    try {
      // 模拟商品数据，实际应用中应该调用真实的商品API
      final mockCommodityData = [
        {
          'symbol': 'GC',
          'name': '黄金',
          'category': '贵金属',
          'unit': '美元/盎司',
          'current_price': 2045.50,
          'change': 12.30,
          'change_percent': 0.60,
          'high_24h': 2050.80,
          'low_24h': 2035.20,
          'volume_24h': 150000,
          'open_interest': 450000,
          'last_updated': DateTime.now().toIso8601String(),
        },
        {
          'symbol': 'SI',
          'name': '白银',
          'category': '贵金属',
          'unit': '美元/盎司',
          'current_price': 24.85,
          'change': -0.15,
          'change_percent': -0.60,
          'high_24h': 25.20,
          'low_24h': 24.70,
          'volume_24h': 80000,
          'open_interest': 120000,
          'last_updated': DateTime.now().toIso8601String(),
        },
        {
          'symbol': 'CL',
          'name': '原油',
          'category': '能源',
          'unit': '美元/桶',
          'current_price': 78.45,
          'change': 1.20,
          'change_percent': 1.55,
          'high_24h': 79.10,
          'low_24h': 77.80,
          'volume_24h': 200000,
          'open_interest': 300000,
          'last_updated': DateTime.now().toIso8601String(),
        },
        {
          'symbol': 'NG',
          'name': '天然气',
          'category': '能源',
          'unit': '美元/MMBtu',
          'current_price': 3.25,
          'change': -0.08,
          'change_percent': -2.40,
          'high_24h': 3.35,
          'low_24h': 3.20,
          'volume_24h': 100000,
          'open_interest': 150000,
          'last_updated': DateTime.now().toIso8601String(),
        },
        {
          'symbol': 'ZC',
          'name': '玉米',
          'category': '农产品',
          'unit': '美元/蒲式耳',
          'current_price': 4.85,
          'change': 0.12,
          'change_percent': 2.54,
          'high_24h': 4.90,
          'low_24h': 4.75,
          'volume_24h': 75000,
          'open_interest': 200000,
          'last_updated': DateTime.now().toIso8601String(),
        },
        {
          'symbol': 'ZS',
          'name': '大豆',
          'category': '农产品',
          'unit': '美元/蒲式耳',
          'current_price': 13.45,
          'change': -0.25,
          'change_percent': -1.82,
          'high_24h': 13.70,
          'low_24h': 13.40,
          'volume_24h': 60000,
          'open_interest': 180000,
          'last_updated': DateTime.now().toIso8601String(),
        },
      ];

      return mockCommodityData.map((e) => Commodity.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch commodity data: $e');
    }
  }

  @override
  Future<Commodity?> fetchCommodityBySymbol(String symbol) async {
    final allCommodities = await fetchData();
    try {
      return allCommodities.firstWhere((commodity) => commodity.symbol == symbol);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Commodity>> fetchCommoditiesByCategory(String category) async {
    final allCommodities = await fetchData();
    return allCommodities.where((commodity) => commodity.category == category).toList();
  }
}
