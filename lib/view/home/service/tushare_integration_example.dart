import 'package:dio/dio.dart';
import 'package:tradingview_app/view/home/model/asset_category.dart';
import 'package:tradingview_app/view/home/service/asset_data_manager.dart';
import 'package:tradingview_app/view/home/service/stock/tushare_stock_data_source.dart';

/// Tushare集成示例 - 展示如何在现有代码中使用Tushare数据源
class TushareIntegrationExample {
  
  /// 示例1: 在HomeView中集成Tushare股票数据
  static Future<List<AssetItem>> getTushareStocksForHome() async {
    try {
      final tushareDataSource = TushareStockDataSource(dio: Dio());
      final stocks = await tushareDataSource.fetchData();
      
      // 转换为AssetItem格式
      return stocks.map((stock) => AssetItem.fromStock(stock)).toList();
    } catch (e) {
      print('获取Tushare股票数据失败: $e');
      return [];
    }
  }
  
  /// 示例2: 获取特定交易所的股票
  static Future<List<AssetItem>> getStocksByExchange(String exchange) async {
    try {
      final tushareDataSource = TushareStockDataSource(dio: Dio());
      final stocks = await tushareDataSource.fetchStocksByExchange(exchange);
      
      return stocks.map((stock) => AssetItem.fromStock(stock)).toList();
    } catch (e) {
      print('获取$exchange股票数据失败: $e');
      return [];
    }
  }
  
  /// 示例3: 搜索特定股票
  static Future<AssetItem?> searchStock(String symbol) async {
    try {
      final tushareDataSource = TushareStockDataSource(dio: Dio());
      final stock = await tushareDataSource.fetchStockBySymbol(symbol);
      
      return stock != null ? AssetItem.fromStock(stock) : null;
    } catch (e) {
      print('搜索股票$symbol失败: $e');
      return null;
    }
  }
  
  /// 示例4: 在AddAssetPage中集成Tushare搜索
  static Future<List<AssetItem>> searchTushareStocks(String query) async {
    try {
      final tushareDataSource = TushareStockDataSource(dio: Dio());
      final allStocks = await tushareDataSource.fetchData();
      
      // 根据查询条件过滤股票
      final filteredStocks = allStocks.where((stock) {
        final symbol = stock.symbol?.toLowerCase() ?? '';
        final name = stock.name?.toLowerCase() ?? '';
        final industry = stock.industry?.toLowerCase() ?? '';
        final queryLower = query.toLowerCase();
        
        return symbol.contains(queryLower) || 
               name.contains(queryLower) || 
               industry.contains(queryLower);
      }).toList();
      
      return filteredStocks.map((stock) => AssetItem.fromStock(stock)).toList();
    } catch (e) {
      print('搜索Tushare股票失败: $e');
      return [];
    }
  }
  
  /// 示例5: 获取热门股票（按成交量排序）
  static Future<List<AssetItem>> getHotStocks({int limit = 20}) async {
    try {
      final tushareDataSource = TushareStockDataSource(dio: Dio());
      final stocks = await tushareDataSource.fetchData();
      
      // 按成交量排序
      stocks.sort((a, b) => (b.volume ?? 0).compareTo(a.volume ?? 0));
      
      // 取前N只股票
      final hotStocks = stocks.take(limit).toList();
      
      return hotStocks.map((stock) => AssetItem.fromStock(stock)).toList();
    } catch (e) {
      print('获取热门股票失败: $e');
      return [];
    }
  }
  
  /// 示例6: 获取行业股票
  static Future<List<AssetItem>> getStocksByIndustry(String industry) async {
    try {
      final tushareDataSource = TushareStockDataSource(dio: Dio());
      final allStocks = await tushareDataSource.fetchData();
      
      // 按行业过滤
      final industryStocks = allStocks.where((stock) {
        return stock.industry?.toLowerCase().contains(industry.toLowerCase()) ?? false;
      }).toList();
      
      return industryStocks.map((stock) => AssetItem.fromStock(stock)).toList();
    } catch (e) {
      print('获取$industry行业股票失败: $e');
      return [];
    }
  }
  
  /// 示例7: 获取涨跌幅排行榜
  static Future<List<AssetItem>> getTopGainers({int limit = 10}) async {
    try {
      final tushareDataSource = TushareStockDataSource(dio: Dio());
      final stocks = await tushareDataSource.fetchData();
      
      // 按涨跌幅排序（降序）
      stocks.sort((a, b) => (b.changePercent ?? 0).compareTo(a.changePercent ?? 0));
      
      // 取前N只股票
      final topGainers = stocks.take(limit).toList();
      
      return topGainers.map((stock) => AssetItem.fromStock(stock)).toList();
    } catch (e) {
      print('获取涨幅榜失败: $e');
      return [];
    }
  }
  
  /// 示例8: 获取跌幅排行榜
  static Future<List<AssetItem>> getTopLosers({int limit = 10}) async {
    try {
      final tushareDataSource = TushareStockDataSource(dio: Dio());
      final stocks = await tushareDataSource.fetchData();
      
      // 按涨跌幅排序（升序）
      stocks.sort((a, b) => (a.changePercent ?? 0).compareTo(b.changePercent ?? 0));
      
      // 取前N只股票
      final topLosers = stocks.take(limit).toList();
      
      return topLosers.map((stock) => AssetItem.fromStock(stock)).toList();
    } catch (e) {
      print('获取跌幅榜失败: $e');
      return [];
    }
  }
}
