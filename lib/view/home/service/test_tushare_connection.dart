import 'package:dio/dio.dart';
import 'package:tradingview_app/view/home/service/stock/tushare_stock_data_source.dart';

/// 测试Tushare连接和数据获取
class TestTushareConnection {
  static Future<void> testConnection() async {
    print('=== 测试Tushare连接 ===');
    
    final dio = Dio();
    final tushareDataSource = TushareStockDataSource(dio: dio);
    
    try {
      // 测试获取少量股票数据
      print('正在获取股票数据...');
      final stocks = await tushareDataSource.fetchData();
      
      print('✅ 连接成功！');
      print('获取到 ${stocks.length} 只股票');
      
      // 显示前3只股票的信息
      print('\n=== 前3只股票信息 ===');
      for (int i = 0; i < 3 && i < stocks.length; i++) {
        final stock = stocks[i];
        print('${i + 1}. ${stock.symbol} - ${stock.name}');
        print('   交易所: ${stock.exchange}');
        print('   行业: ${stock.industry}');
        print('   当前价格: ${stock.currentPrice}');
        print('   涨跌幅: ${stock.changePercent}%');
        print('   成交量: ${stock.volume}');
        print('   市盈率: ${stock.peRatio}');
        print('---');
      }
      
      // 测试按交易所筛选
      print('\n=== 测试按交易所筛选 ===');
      final sseStocks = await tushareDataSource.fetchStocksByExchange('SSE');
      print('上交所股票数量: ${sseStocks.length}');
      
      final szseStocks = await tushareDataSource.fetchStocksByExchange('SZSE');
      print('深交所股票数量: ${szseStocks.length}');
      
      // 测试特定股票查询
      print('\n=== 测试特定股票查询 ===');
      final specificStock = await tushareDataSource.fetchStockBySymbol('000001');
      if (specificStock != null) {
        print('找到股票: ${specificStock.symbol} - ${specificStock.name}');
        print('价格: ${specificStock.currentPrice}, 涨跌幅: ${specificStock.changePercent}%');
      } else {
        print('未找到股票 000001');
      }
      
      print('\n🎉 Tushare数据源配置成功！');
      
    } catch (e) {
      print('❌ 连接失败: $e');
      print('\n可能的原因:');
      print('1. Tushare API频率限制（免费版每小时只能调用1次）');
      print('2. Token权限不足');
      print('3. 网络连接问题');
      print('\n解决方案:');
      print('1. 等待1小时后重试');
      print('2. 升级Tushare会员获得更高调用频率');
      print('3. 应用已自动切换到模拟数据模式');
    }
  }
  
  static Future<void> testBasicInfo() async {
    print('\n=== 测试基础信息获取 ===');
    
    final dio = Dio();
    
    try {
      // 直接测试Tushare API调用
      final response = await dio.post(
        'http://api.tushare.pro',
        data: {
          'token': 'f11798770f32be905122f11c537f7e622f187a233d47c815b58d37b7',
          'api_name': 'stock_basic',
          'params': {
            'list_status': 'L',
            'fields': 'ts_code,symbol,name,area,industry,market'
          }
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      
      if (response.data['code'] == 0) {
        print('✅ API调用成功');
        final data = response.data['data']['items'] as List<dynamic>? ?? [];
        print('获取到 ${data.length} 条基础信息');
        
        if (data.isNotEmpty) {
          print('第一条数据: ${data.first}');
        }
      } else {
        print('❌ API返回错误: ${response.data['msg']}');
      }
      
    } catch (e) {
      print('❌ API调用失败: $e');
    }
  }
}
