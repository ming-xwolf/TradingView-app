import 'package:tradingview_app/view/_product/service/service_keys.dart';

class TushareConstants {
  const TushareConstants._();
  
  // Tushare API 基础配置
  static const String baseUrl = 'http://api.tushare.pro';
  static const String token = ServiceKeys.tushareToken; // 需要在service_keys.dart中添加token
  
  // API 端点
  static const String stockBasicUrl = '$baseUrl/stock_basic';
  static const String dailyUrl = '$baseUrl/daily';
  static const String realTimeUrl = '$baseUrl/realtime_quotes';
  static const String indexDailyUrl = '$baseUrl/index_daily';
  
  // 请求头
  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // 交易所代码
  static const String sse = 'SSE'; // 上海证券交易所
  static const String szse = 'SZSE'; // 深圳证券交易所
  static const String bse = 'BSE'; // 北京证券交易所
  
  // 股票状态
  static const String listStatusL = 'L'; // 上市
  static const String listStatusD = 'D'; // 退市
  static const String listStatusP = 'P'; // 暂停上市
}
