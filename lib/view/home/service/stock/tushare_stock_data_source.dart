import 'package:dio/dio.dart';
import 'package:tradingview_app/view/_product/service/tushare_constants.dart';
import 'package:tradingview_app/view/home/model/stock.dart';
import 'package:tradingview_app/view/home/model/tushare_stock.dart';
import 'package:tradingview_app/view/home/service/stock/istock_data_source.dart';

class TushareStockDataSource extends IStockDataSource {
  TushareStockDataSource({required this.dio});

  final Dio dio;

  @override
  Future<List<Stock>> fetchData() async {
    try {
      // 获取股票基本信息
      final stockBasicResponse = await _fetchStockBasic();
      final stockBasics = stockBasicResponse.map((e) => TushareStock.fromJson(e)).toList();
      
      // 获取前100只股票的实时行情
      final top100Stocks = stockBasics.take(100).toList();
      final stockCodes = top100Stocks.map((s) => s.tsCode).where((code) => code != null).cast<String>().toList();
      
      final realtimeQuotes = await _fetchRealtimeQuotes(stockCodes);
      
      // 合并数据并转换为Stock模型
      final List<Stock> stocks = [];
      
      for (final stockBasic in top100Stocks) {
        final realtimeQuote = realtimeQuotes.firstWhere(
          (quote) => quote.code == stockBasic.tsCode,
          orElse: () => TushareRealtimeQuote(),
        );
        
        stocks.add(_convertToStock(stockBasic, realtimeQuote));
      }
      
      return stocks;
    } catch (e) {
      throw Exception('Failed to fetch Tushare stock data: $e');
    }
  }

  @override
  Future<Stock?> fetchStockBySymbol(String symbol) async {
    try {
      final stockBasics = await _fetchStockBasic();
      final stockBasic = stockBasics.firstWhere(
        (s) => s['symbol'] == symbol || s['ts_code'] == symbol,
        orElse: () => <String, dynamic>{},
      );
      
      if (stockBasic.isEmpty) {
        throw Exception('Stock $symbol not found in Tushare data source');
      }
      
      final tushareStock = TushareStock.fromJson(stockBasic);
      final realtimeQuotes = await _fetchRealtimeQuotes([tushareStock.tsCode!]);
      final realtimeQuote = realtimeQuotes.isNotEmpty ? realtimeQuotes.first : TushareRealtimeQuote();
      
      return _convertToStock(tushareStock, realtimeQuote);
    } catch (e) {
      throw Exception('Failed to fetch stock by symbol from Tushare: $e');
    }
  }

  @override
  Future<List<Stock>> fetchStocksByExchange(String exchange) async {
    try {
      final stockBasics = await _fetchStockBasic();
      final filteredBasics = stockBasics.where((s) {
        final market = s['market']?.toString();
        switch (exchange.toUpperCase()) {
          case 'SSE':
            return market == '主板' || market == '科创板';
          case 'SZSE':
            return market == '中小板' || market == '创业板';
          case 'BSE':
            return market == '北交所';
          default:
            return false;
        }
      }).toList();
      
      final tushareStocks = filteredBasics.map((e) => TushareStock.fromJson(e)).toList();
      final stockCodes = tushareStocks.map((s) => s.tsCode).where((code) => code != null).cast<String>().toList();
      
      final realtimeQuotes = await _fetchRealtimeQuotes(stockCodes);
      
      final List<Stock> stocks = [];
      for (final stockBasic in tushareStocks) {
        final realtimeQuote = realtimeQuotes.firstWhere(
          (quote) => quote.code == stockBasic.tsCode,
          orElse: () => TushareRealtimeQuote(),
        );
        
        stocks.add(_convertToStock(stockBasic, realtimeQuote));
      }
      
      return stocks;
    } catch (e) {
      throw Exception('Failed to fetch stocks by exchange: $e');
    }
  }

  // 获取股票基本信息
  Future<List<Map<String, dynamic>>> _fetchStockBasic() async {
    try {
      final response = await dio.post(
        TushareConstants.stockBasicUrl,
        data: {
          'token': TushareConstants.token,
          'api_name': 'stock_basic',
          'params': {
            'list_status': TushareConstants.listStatusL,
            'fields': 'ts_code,symbol,name,area,industry,market,list_date,list_status,is_hs'
          }
        },
        options: Options(headers: TushareConstants.headers),
      );
      
      if (response.data['code'] != 0) {
        throw Exception('Tushare API error: ${response.data['msg']}');
      }
      
      return List<Map<String, dynamic>>.from(response.data['data']['items'] ?? []);
    } catch (e) {
      throw Exception('Failed to fetch stock basic data: $e');
    }
  }

  // 获取实时行情
  Future<List<TushareRealtimeQuote>> _fetchRealtimeQuotes(List<String> codes) async {
    if (codes.isEmpty) return [];
    
    try {
      final response = await dio.post(
        TushareConstants.realTimeUrl,
        data: {
          'token': TushareConstants.token,
          'api_name': 'realtime_quotes',
          'params': {
            'ts_codes': codes.join(','),
            'fields': 'code,name,close,pct_chg,change,volume,amount,turnover,pe,pb,total_share,float_share,high,low,open,pre_close,trade_time'
          }
        },
        options: Options(headers: TushareConstants.headers),
      );
      
      if (response.data['code'] != 0) {
        throw Exception('Tushare API error: ${response.data['msg']}');
      }
      
      final items = response.data['data']['items'] as List<dynamic>? ?? [];
      return items.map((item) => TushareRealtimeQuote.fromJson(Map<String, dynamic>.from(item))).toList();
    } catch (e) {
      throw Exception('Failed to fetch realtime quotes: $e');
    }
  }

  // 将Tushare数据转换为Stock模型
  Stock _convertToStock(TushareStock stockBasic, TushareRealtimeQuote realtimeQuote) {
    final currentPrice = (realtimeQuote.close ?? 0.0).toDouble();
    final changePercent = (realtimeQuote.pctChg ?? 0.0).toDouble();
    final change = (realtimeQuote.change ?? 0.0).toDouble();
    
    return Stock(
      symbol: stockBasic.symbol ?? '',
      name: stockBasic.name ?? '',
      exchange: _getExchangeFromMarket(stockBasic.market),
      sector: stockBasic.area ?? '',
      industry: stockBasic.industry ?? '',
      currentPrice: currentPrice,
      change: change,
      changePercent: changePercent,
      high52w: (realtimeQuote.high ?? 0.0).toDouble(),
      low52w: (realtimeQuote.low ?? 0.0).toDouble(),
      volume: (realtimeQuote.volume ?? 0.0).toDouble(),
      marketCap: (realtimeQuote.totalShare ?? 0.0).toDouble() * currentPrice,
      peRatio: (realtimeQuote.pe ?? 0.0).toDouble(),
      lastUpdated: realtimeQuote.tradeTime ?? DateTime.now().toIso8601String(),
    );
  }

  // 根据市场类型获取交易所
  String _getExchangeFromMarket(String? market) {
    switch (market) {
      case '主板':
      case '科创板':
        return 'SSE';
      case '中小板':
      case '创业板':
        return 'SZSE';
      case '北交所':
        return 'BSE';
      default:
        return 'UNKNOWN';
    }
  }

}
