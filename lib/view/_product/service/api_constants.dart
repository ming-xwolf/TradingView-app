import 'package:tradingview_app/view/_product/service/service_keys.dart';

class ApiConstants {
  const ApiConstants._();
  // 使用免费的CoinGecko API替代CoinMarketCap
  static const String url =
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false';
  static final Map<String, String> header = {
    'Accept': 'application/json',
  };
}
