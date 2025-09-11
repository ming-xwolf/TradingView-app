import 'package:dio/dio.dart';
import 'package:tradingview_app/view/home/service/stock/tushare_stock_data_source.dart';
import 'package:tradingview_app/view/home/service/asset_data_manager.dart';

/// Tushare数据源使用示例
class TushareUsageExample {
  static Future<void> demonstrateUsage() async {
    final dio = Dio();
    final tushareDataSource = TushareStockDataSource(dio: dio);
    
    try {
      // 1. 获取所有股票数据
      print('=== 获取所有股票数据 ===');
      final allStocks = await tushareDataSource.fetchData();
      print('获取到 ${allStocks.length} 只股票');
      
      // 显示前5只股票
      for (int i = 0; i < 5 && i < allStocks.length; i++) {
        final stock = allStocks[i];
        print('${stock.symbol} - ${stock.name} - 价格: ${stock.currentPrice} - 涨跌幅: ${stock.changePercent}%');
      }
      
      // 2. 获取特定股票
      print('\n=== 获取特定股票 ===');
      final specificStock = await tushareDataSource.fetchStockBySymbol('000001');
      if (specificStock != null) {
        print('${specificStock.symbol} - ${specificStock.name} - 价格: ${specificStock.currentPrice}');
      } else {
        print('未找到股票 000001');
      }
      
      // 3. 按交易所获取股票
      print('\n=== 按交易所获取股票 ===');
      final sseStocks = await tushareDataSource.fetchStocksByExchange('SSE');
      print('上交所股票数量: ${sseStocks.length}');
      
      final szseStocks = await tushareDataSource.fetchStocksByExchange('SZSE');
      print('深交所股票数量: ${szseStocks.length}');
      
      // 4. 使用AssetDataManager
      print('\n=== 使用AssetDataManager ===');
      final assetManager = AssetDataManager(
        cryptoDataSource: null, // 这里需要实际的依赖注入
        forexDataSource: null,
        stockDataSource: tushareDataSource,
        commodityDataSource: null,
      );
      
      final tushareAssets = await assetManager.getTushareStocks();
      print('通过AssetDataManager获取到 ${tushareAssets.length} 个资产');
      
    } catch (e) {
      print('获取数据时出错: $e');
      print('请确保已正确配置Tushare Token');
    }
  }
  
  /// 配置说明
  static void printConfigurationInstructions() {
    print('''
=== Tushare配置说明 ===

1. 注册Tushare账号
   - 访问 https://tushare.pro/
   - 注册账号并获取API Token

2. 配置Token
   - 打开 lib/view/_product/service/service_keys.dart
   - 将 YOUR_TUSHARE_TOKEN_HERE 替换为你的实际Token
   
3. 使用数据源
   - 通过依赖注入获取 TushareStockDataSource
   - 或直接使用 AssetDataManager.getTushareStocks()

4. 支持的功能
   - 获取所有A股基本信息
   - 获取实时行情数据
   - 按交易所筛选股票
   - 按股票代码查询特定股票

5. 数据字段
   - 股票代码、名称、行业、地区
   - 实时价格、涨跌幅、成交量
   - 市盈率、市净率、市值等
    ''');
  }
}
