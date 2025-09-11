import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tradingview_app/view/home/model/stock.dart';
import 'package:tradingview_app/view/home/service/stock/istock_data_source.dart';

class AkshareStockDataSource extends IStockDataSource {
  AkshareStockDataSource({required this.dio});

  final Dio dio;

  @override
  Future<List<Stock>> fetchData() async {
    try {
      print('Fetching Akshare stock data using stock_zh_a_spot_em...');
      
      // 使用 stock_zh_a_spot_em API 获取实时行情数据
      final response = await dio.get(
        'https://push2.eastmoney.com/api/qt/clist/get',
        queryParameters: {
          'pn': '1',
          'pz': '100', // 获取前100只股票
          'po': '1',
          'np': '1',
          'ut': 'bd1d9ddb0408970cf38c7f7fda6ba90b',
          'fltt': '2',
          'invt': '2',
          'fid': 'f3',
          'fs': 'm:0+t:6,m:0+t:80,m:0+t:2,m:0+t:23,m:0+t:3,m:0+t:1', // 包含所有A股市场
          'fields': 'f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f12,f13,f14,f15,f16,f17,f18,f20,f21,f23,f24,f25,f22,f11,f62,f128,f136,f115,f152',
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null && data['diff'] != null) {
          final diff = data['diff'];
          print('Akshare API response count: ${diff.length}');
          
          if (diff is List) {
            final List<dynamic> stocks = diff;
            final List<Stock> result = [];
            
            for (final item in stocks) {
              try {
                if (item is Map<String, dynamic>) {
                  final stock = _convertFromSpotData(item);
                  if (stock != null) {
                    result.add(stock);
                  }
                }
              } catch (e) {
                print('Error processing stock item: $e');
                continue;
              }
            }
            
            print('Successfully converted ${result.length} stocks');
            return result;
          }
        }
      }
      
      throw Exception('Failed to fetch stock data from Akshare API');
    } catch (e) {
      print('Failed to fetch Akshare stock data: $e');
      throw Exception('Failed to fetch Akshare stock data: $e');
    }
  }

  @override
  Future<Stock?> fetchStockBySymbol(String symbol) async {
    try {
      print('Searching for stock: $symbol');
      
      // 使用东方财富的个股信息API
      final response = await dio.get(
        'https://push2.eastmoney.com/api/qt/stock/get',
        queryParameters: {
          'ut': 'bd1d9ddb0408970cf38c7f7fda6ba90b',
          'invt': '2',
          'fltt': '2',
          'secid': _getSecId(symbol),
          'fields': 'f57,f58,f107,f137,f46,f44,f45,f47,f48,f60,f170,f15,f16,f18,f168,f169,f127,f116,f60,f45,f52,f50,f51,f161,f49,f530,f135,f136,f138,f141,f142,f144,f145,f147,f148,f140,f143,f146,f149,f55,f62,f162,f92,f173,f104,f105,f84,f85,f183,f184,f185,f186,f187,f188,f189,f190,f191,f192,f107,f111,f86,f177,f78,f110,f262,f263,f264,f267,f268,f250,f251,f252,f253,f254,f255,f256,f257,f258,f259,f260,f261,f171,f277,f278,f279,f288,f152',
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['data'] != null) {
          final stockData = data['data'];
          print('Found stock data for $symbol: ${stockData['f58']}');
          
          return Stock(
            symbol: symbol,
            name: stockData['f58']?.toString() ?? '',
            currentPrice: stockData['f43']?.toDouble() ?? 0.0,
            change: stockData['f169']?.toDouble() ?? 0.0,
            changePercent: stockData['f170']?.toDouble() ?? 0.0,
            volume: stockData['f47']?.toDouble() ?? 0.0,
            marketCap: stockData['f116']?.toDouble() ?? 0.0,
            peRatio: stockData['f114']?.toDouble() ?? 0.0,
            high52w: stockData['f45']?.toDouble() ?? 0.0,
            low52w: stockData['f46']?.toDouble() ?? 0.0,
            industry: stockData['f127']?.toString() ?? '',
            exchange: _getExchangeFromCode(symbol),
            lastUpdated: DateTime.now().toIso8601String(),
          );
        }
      }
      
      // 如果直接搜索失败，尝试从股票列表中搜索
      print('Direct search failed, trying from stock list...');
      final stocks = await fetchData();
      final foundStock = stocks.cast<Stock?>().firstWhere(
        (stock) => stock?.symbol == symbol,
        orElse: () => null,
      );
      
      if (foundStock != null) {
        return foundStock;
      }
      
      throw Exception('Stock $symbol not found in Akshare data source');
    } catch (e) {
      print('Failed to fetch stock by symbol: $e');
      throw Exception('Failed to fetch stock by symbol: $e');
    }
  }
  
  // 直接搜索特定股票
  Future<Stock?> _searchStockDirectly(String symbol) async {
    try {
      // 使用东方财富的个股搜索接口
      final response = await dio.get(
        'https://push2.eastmoney.com/api/qt/stock/get',
        queryParameters: {
          'secid': _getSecId(symbol),
          'fields': 'f2,f3,f4,f5,f6,f7,f8,f9,f10,f12,f13,f14,f15,f16,f17,f18,f20,f21,f23,f24,f25,f22,f11,f62,f128,f136,f115,f152',
          'ut': 'bd1d9ddb0408970cf38c7f7fda6ba90b',
          'invt': '2',
          'fltt': '2',
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null) {
          print('Direct search response for $symbol: $data');
          
          // 检查是否有有效的股票数据
          final code = data['f12']?.toString() ?? symbol;
          final name = data['f14']?.toString() ?? '';
          
          if (code.isNotEmpty) {
            // 构造股票信息
            final stockInfo = {
              'code': code,
              'name': name.isNotEmpty ? name : '未知股票',
              'industry': data['f127']?.toString() ?? data['f128']?.toString() ?? '',
              'f2': data['f2']?.toDouble() ?? 0.0,
              'f3': data['f3']?.toDouble() ?? 0.0,
              'f4': data['f4']?.toDouble() ?? 0.0,
            };
            
            // 构造实时行情数据
            final realtimeQuote = {
              'code': code,
              'close': data['f2']?.toDouble() ?? 0.0,
              'pct_chg': data['f3']?.toDouble() ?? 0.0,
              'change': data['f4']?.toDouble() ?? 0.0,
              'volume': data['f5']?.toDouble() ?? 0.0,
              'amount': data['f6']?.toDouble() ?? 0.0,
              'turnover': data['f7']?.toDouble() ?? 0.0,
              'pe': data['f9']?.toDouble() ?? 0.0,
              'pb': data['f23']?.toDouble() ?? 0.0,
              'total_share': data['f21']?.toDouble() ?? 0.0,
              'float_share': data['f22']?.toDouble() ?? 0.0,
              'high': data['f11']?.toDouble() ?? 0.0,
              'low': data['f10']?.toDouble() ?? 0.0,
              'open': data['f17']?.toDouble() ?? 0.0,
              'pre_close': data['f18']?.toDouble() ?? 0.0,
              'trade_time': DateTime.now().toIso8601String(),
            };
            
            print('Constructed stock info: $stockInfo');
            print('Constructed realtime quote: $realtimeQuote');
            
            return _convertToStock(stockInfo, realtimeQuote);
          } else {
            print('No valid stock code found in response');
          }
        } else {
          print('No data field in response');
        }
      } else {
        print('API returned status code: ${response.statusCode}');
      }
      
      return null;
    } catch (e) {
      print('Direct search failed for $symbol: $e');
      return null;
    }
  }
  
  // 从完整股票列表中搜索特定股票
  Future<Stock?> _searchStockInFullList(String symbol) async {
    try {
      // 获取完整股票列表
      final stockList = await _fetchStockList();
      
      // 搜索匹配的股票
      final stockInfo = stockList.firstWhere(
        (s) => s['code'] == symbol,
        orElse: () => <String, dynamic>{},
      );
      
      if (stockInfo.isNotEmpty) {
        print('Found stock $symbol in full list: ${stockInfo['name']}');
        
        // 尝试获取实时行情
        final realtimeQuote = await _fetchRealtimeQuotes([symbol]);
        final quote = realtimeQuote.isNotEmpty ? realtimeQuote.first : <String, dynamic>{};
        
        return _convertToStock(stockInfo, quote);
      } else {
        print('Stock $symbol not found in full list, trying SZSE specific search...');
        // 如果没找到，尝试专门搜索深交所股票
        return await _searchSZSEStock(symbol);
      }
    } catch (e) {
      print('Full list search failed for $symbol: $e');
      return null;
    }
  }
  
  // 专门搜索深交所股票
  Future<Stock?> _searchSZSEStock(String symbol) async {
    try {
      print('Searching SZSE stock: $symbol');
      
      // 使用深交所专门的API
      final response = await dio.get(
        'https://push2.eastmoney.com/api/qt/clist/get',
        queryParameters: {
          'pn': '1',
          'pz': '1000',
          'po': '1',
          'np': '1',
          'ut': 'bd1d9ddb0408970cf38c7f7fda6ba90b',
          'fltt': '2',
          'invt': '2',
          'fid': 'f3',
          'fs': 'm:0+t:3,m:0+t:1', // 只搜索深交所主板和创业板
          'fields': 'f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f12,f13,f14,f15,f16,f17,f18,f20,f21,f23,f24,f25,f22,f11,f62,f128,f136,f115,f152',
        },
      );
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        print('SZSE API full response: $responseData');
        
        if (responseData is Map<String, dynamic> && 
            responseData['data'] != null && 
            responseData['data']['diff'] != null) {
          
          final diff = responseData['data']['diff'];
          print('SZSE diff type: ${diff.runtimeType}');
          
          if (diff is List) {
            print('SZSE API response count: ${diff.length}');
            
            // 安全搜索匹配的股票
            for (int i = 0; i < diff.length; i++) {
              try {
                final item = diff[i];
                if (item is Map<String, dynamic>) {
                  final code = item['f12']?.toString() ?? '';
                  print('Checking SZSE stock $i: $code');
                  
                  if (code == symbol) {
                    print('Found SZSE stock $symbol: ${item['f14']}');
                    
                    // 构造股票信息
                    final stockData = {
                      'code': item['f12']?.toString() ?? symbol,
                      'name': item['f14']?.toString() ?? '',
                      'industry': item['f127']?.toString() ?? item['f128']?.toString() ?? '',
                      'f2': item['f2']?.toDouble() ?? 0.0,
                      'f3': item['f3']?.toDouble() ?? 0.0,
                      'f4': item['f4']?.toDouble() ?? 0.0,
                    };
                    
                    // 构造实时行情数据
                    final realtimeQuote = {
                      'code': item['f12']?.toString() ?? symbol,
                      'close': item['f2']?.toDouble() ?? 0.0,
                      'pct_chg': item['f3']?.toDouble() ?? 0.0,
                      'change': item['f4']?.toDouble() ?? 0.0,
                      'volume': item['f5']?.toDouble() ?? 0.0,
                      'amount': item['f6']?.toDouble() ?? 0.0,
                      'turnover': item['f7']?.toDouble() ?? 0.0,
                      'pe': item['f9']?.toDouble() ?? 0.0,
                      'pb': item['f23']?.toDouble() ?? 0.0,
                      'total_share': item['f21']?.toDouble() ?? 0.0,
                      'float_share': item['f22']?.toDouble() ?? 0.0,
                      'high': item['f11']?.toDouble() ?? 0.0,
                      'low': item['f10']?.toDouble() ?? 0.0,
                      'open': item['f17']?.toDouble() ?? 0.0,
                      'pre_close': item['f18']?.toDouble() ?? 0.0,
                      'trade_time': DateTime.now().toIso8601String(),
                    };
                    
                    return _convertToStock(stockData, realtimeQuote);
                  }
                }
              } catch (e) {
                print('Error processing SZSE stock item $i: $e');
                continue; // 继续处理下一个
              }
            }
            
            print('SZSE stock $symbol not found in response');
          } else {
            print('SZSE diff is not a List: ${diff.runtimeType}');
          }
        } else {
          print('SZSE API response format unexpected');
        }
      } else {
        print('SZSE API request failed with status: ${response.statusCode}');
      }
      
      return null;
    } catch (e) {
      print('SZSE search failed for $symbol: $e');
      return null;
    }
  }
  
  // 获取股票代码对应的secid
  String _getSecId(String code) {
    if (code.startsWith('6')) {
      return '1.$code'; // 上交所
    } else if (code.startsWith('0') || code.startsWith('3')) {
      return '0.$code'; // 深交所
    }
    return code;
  }

  // 从实时行情数据转换为Stock模型
  Stock? _convertFromSpotData(Map<String, dynamic> spotData) {
    try {
      final code = spotData['f12']?.toString() ?? '';
      final name = spotData['f14']?.toString() ?? '';
      
      if (code.isEmpty || name.isEmpty) {
        return null;
      }
      
      return Stock(
        symbol: code,
        name: name,
        currentPrice: spotData['f2']?.toDouble() ?? 0.0,
        change: spotData['f4']?.toDouble() ?? 0.0,
        changePercent: spotData['f3']?.toDouble() ?? 0.0,
        volume: spotData['f5']?.toDouble() ?? 0.0,
        marketCap: spotData['f20']?.toDouble() ?? 0.0,
        peRatio: spotData['f9']?.toDouble() ?? 0.0,
        high52w: spotData['f11']?.toDouble() ?? 0.0,
        low52w: spotData['f10']?.toDouble() ?? 0.0,
        industry: spotData['f127']?.toString() ?? spotData['f128']?.toString() ?? '',
        exchange: _getExchangeFromCode(code),
        lastUpdated: DateTime.now().toIso8601String(),
      );
    } catch (e) {
      print('Error converting spot data: $e');
      return null;
    }
  }

  // 根据股票代码确定交易所
  String _getExchangeFromCode(String code) {
    if (code.startsWith('6')) {
      return 'SSE'; // 上交所
    } else if (code.startsWith('0') || code.startsWith('3')) {
      return 'SZSE'; // 深交所
    } else if (code.startsWith('8') || code.startsWith('4')) {
      return 'BSE'; // 北交所
    }
    return 'UNKNOWN';
  }
  
  // 按名称搜索股票
  Future<List<Stock>> searchStocksByName(String name) async {
    try {
      // 使用东方财富的搜索接口
      final response = await dio.get(
        'https://searchapi.eastmoney.com/api/suggest/get',
        queryParameters: {
          'input': name,
          'type': '14', // 股票类型
          'markettype': 'mkt',
          'mktnum': '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100',
          'token': 'D43BF722-CF1A-4C27-AE61-67E0FAD3CE5E',
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['QuotationCodeTable'] != null) {
          final List<dynamic> results = data['QuotationCodeTable']['Data'];
          print('Search results for "$name": $results');
          
          final List<Stock> stocks = [];
          for (final item in results.take(10)) { // 限制返回10个结果
            final code = item['Code']?.toString() ?? '';
            final stockName = item['Name']?.toString() ?? '';
            
            if (code.isNotEmpty) {
              // 使用直接搜索获取详细信息
              final stock = await _searchStockDirectly(code);
              if (stock != null) {
                stocks.add(stock);
              }
            }
          }
          
          return stocks;
        }
      }
      
      return [];
    } catch (e) {
      print('Search by name failed for "$name": $e');
      return [];
    }
  }

  @override
  Future<List<Stock>> fetchStocksByExchange(String exchange) async {
    try {
      final stockList = await _fetchStockList();
      final filteredStocks = stockList.where((stock) {
        final code = stock['code']?.toString() ?? '';
        if (exchange.toUpperCase() == 'SSE') {
          return code.startsWith('6') || code.startsWith('9');
        } else if (exchange.toUpperCase() == 'SZSE') {
          return code.startsWith('0') || code.startsWith('3') || code.startsWith('2');
        }
        return false;
      }).toList();
      
      final stockCodes = filteredStocks.map((s) => s['code']).where((code) => code != null).cast<String>().toList();
      final realtimeQuotes = await _fetchRealtimeQuotes(stockCodes);
      
      final List<Stock> stocks = [];
      for (final stockInfo in filteredStocks) {
        final realtimeQuote = realtimeQuotes.firstWhere(
          (quote) => quote['code'] == stockInfo['code'],
          orElse: () => <String, dynamic>{},
        );
        
        stocks.add(_convertToStock(stockInfo, realtimeQuote));
      }
      
      return stocks;
    } catch (e) {
      throw Exception('Failed to fetch stocks by exchange: $e');
    }
  }

  // 获取股票列表
  Future<List<Map<String, dynamic>>> _fetchStockList() async {
    try {
      // 使用akshare的股票列表接口
      final response = await dio.get(
        'https://push2.eastmoney.com/api/qt/clist/get',
        queryParameters: {
          'pn': '1',
          'pz': '5000',
          'po': '1',
          'np': '1',
          'ut': 'bd1d9ddb0408970cf38c7f7fda6ba90b',
          'fltt': '2',
          'invt': '2',
          'fid': 'f3',
          'fs': 'm:0+t:6,m:0+t:80,m:1+t:2,m:1+t:23,m:0+t:3,m:0+t:1', // 添加深交所主板和创业板
          'fields': 'f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f12,f13,f14,f15,f16,f17,f18,f20,f21,f23,f24,f25,f22,f11,f62,f128,f136,f115,f152',
        },
      );
      
      if (response.statusCode == 200) {
        print('EastMoney API response: ${response.data}');
        final data = response.data['data'];
        if (data != null && data['diff'] != null) {
          final diff = data['diff'];
          print('Diff type: ${diff.runtimeType}');
          
          if (diff is List) {
            final List<dynamic> stocks = diff;
            return stocks.map((stock) {
              if (stock is Map<String, dynamic>) {
                final Map<String, dynamic> stockData = stock;
                return {
                  'code': stockData['f12']?.toString() ?? '', // f12: 股票代码
                  'name': stockData['f14']?.toString() ?? '', // f14: 股票名称
                  'ts_code': _convertToTsCode(stockData['f12']?.toString() ?? ''),
                  'area': _getAreaFromCode(stockData['f12']?.toString() ?? ''),
                  'industry': stockData['f15']?.toString() ?? '', // f15: 行业
                  'market': _getMarketFromCode(stockData['f12']?.toString() ?? ''),
                  'list_date': '19900101', // 默认值
                  'list_status': 'L',
                  'is_hs': stockData['f12']?.toString().startsWith('6') == true ? 'Y' : 'N',
                };
              } else {
                print('Stock item is not a Map: ${stock.runtimeType}');
                return <String, dynamic>{};
              }
            }).where((item) => item.isNotEmpty).toList();
          } else {
            print('Diff is not a List: ${diff.runtimeType}');
            throw Exception('Unexpected data format: diff is not a List');
          }
        } else {
          print('Data or diff is null. Data: $data');
          throw Exception('No data or diff found in response');
        }
      }
      
      throw Exception('Failed to fetch stock list from EastMoney API');
    } catch (e) {
      throw Exception('Failed to fetch stock list: $e');
    }
  }

  // 获取实时行情
  Future<List<Map<String, dynamic>>> _fetchRealtimeQuotes(List<String> codes) async {
    if (codes.isEmpty) return [];
    
    try {
      // 转换股票代码为东方财富格式
      final secids = codes.map((code) {
        if (code.startsWith('6')) {
          return '1.$code'; // 上交所
        } else if (code.startsWith('0') || code.startsWith('3')) {
          return '0.$code'; // 深交所
        }
        return code;
      }).join(',');
      
      print('Fetching realtime quotes for secids: $secids');
      
      final response = await dio.get(
        'https://push2.eastmoney.com/api/qt/ulist.np',
        queryParameters: {
          'secids': secids,
          'fields': 'f2,f3,f4,f5,f6,f7,f8,f9,f10,f12,f13,f14,f15,f16,f17,f18,f20,f21,f23,f24,f25,f22,f11,f62,f128,f136,f115,f152',
          'ut': 'bd1d9ddb0408970cf38c7f7fda6ba90b',
        },
      );
      
      if (response.statusCode == 200) {
        print('EastMoney realtime quotes response: ${response.data}');
        final data = response.data['data'];
        if (data != null && data['diff'] != null) {
          final diff = data['diff'];
          print('Realtime quotes diff type: ${diff.runtimeType}');
          
          if (diff is List) {
            final List<dynamic> quotes = diff;
            return quotes.map((quote) {
              if (quote is Map<String, dynamic>) {
                final Map<String, dynamic> quoteData = quote;
                return {
                  'code': quoteData['f12']?.toString() ?? '', // f12: 股票代码
                  'name': quoteData['f14']?.toString() ?? '', // f14: 股票名称
                  'close': quoteData['f2']?.toDouble() ?? 0.0, // f2: 最新价
                  'pct_chg': quoteData['f3']?.toDouble() ?? 0.0, // f3: 涨跌幅
                  'change': quoteData['f4']?.toDouble() ?? 0.0, // f4: 涨跌额
                  'volume': quoteData['f5']?.toDouble() ?? 0.0, // f5: 成交量
                  'amount': quoteData['f6']?.toDouble() ?? 0.0, // f6: 成交额
                  'turnover': quoteData['f7']?.toDouble() ?? 0.0, // f7: 换手率
                  'pe': quoteData['f9']?.toDouble() ?? 0.0, // f9: 市盈率
                  'pb': quoteData['f23']?.toDouble() ?? 0.0, // f23: 市净率
                  'total_share': quoteData['f21']?.toDouble() ?? 0.0, // f21: 总股本
                  'float_share': quoteData['f22']?.toDouble() ?? 0.0, // f22: 流通股本
                  'high': quoteData['f11']?.toDouble() ?? 0.0, // f11: 最高价
                  'low': quoteData['f10']?.toDouble() ?? 0.0, // f10: 最低价
                  'open': quoteData['f17']?.toDouble() ?? 0.0, // f17: 开盘价
                  'pre_close': quoteData['f18']?.toDouble() ?? 0.0, // f18: 昨收价
                  'trade_time': DateTime.now().toIso8601String(),
                };
              } else {
                print('Quote item is not a Map: ${quote.runtimeType}');
                return <String, dynamic>{};
              }
            }).where((item) => item.isNotEmpty).toList();
          } else {
            print('Realtime quotes diff is not a List: ${diff.runtimeType}');
            return []; // 返回空列表而不是抛出异常
          }
        } else {
          print('Realtime quotes data or diff is null. Data: $data');
          return []; // 返回空列表而不是抛出异常
        }
      }
      
      print('Failed to fetch realtime quotes from EastMoney API, status: ${response.statusCode}');
      return []; // 返回空列表而不是抛出异常
    } catch (e) {
      print('Failed to fetch realtime quotes: $e');
      return []; // 返回空列表而不是抛出异常
    }
  }

  // 将数据转换为Stock模型
  Stock _convertToStock(Map<String, dynamic> stockInfo, Map<String, dynamic> realtimeQuote) {
    // 优先使用实时行情数据，如果没有则使用默认值
    final currentPrice = (realtimeQuote['close'] ?? 0.0).toDouble();
    final changePercent = (realtimeQuote['pct_chg'] ?? 0.0).toDouble();
    final change = (realtimeQuote['change'] ?? 0.0).toDouble();
    
    // 如果实时行情数据为空，使用基本信息中的价格（如果有的话）
    final finalPrice = currentPrice > 0 ? currentPrice : (stockInfo['f2']?.toDouble() ?? 0.0);
    final finalChangePercent = changePercent != 0 ? changePercent : (stockInfo['f3']?.toDouble() ?? 0.0);
    final finalChange = change != 0 ? change : (stockInfo['f4']?.toDouble() ?? 0.0);
    
    return Stock(
      symbol: stockInfo['code'] ?? '',
      name: stockInfo['name'] ?? '',
      exchange: _getExchangeFromCode(stockInfo['code'] ?? ''),
      industry: stockInfo['industry'] ?? '',
      currentPrice: finalPrice,
      change: finalChange,
      changePercent: finalChangePercent,
      volume: (realtimeQuote['volume'] ?? 0.0).toDouble(),
      marketCap: (realtimeQuote['total_share'] ?? 0.0).toDouble() * finalPrice,
      peRatio: (realtimeQuote['pe'] ?? 0.0).toDouble(),
      high52w: (realtimeQuote['high'] ?? 0.0).toDouble(),
      low52w: (realtimeQuote['low'] ?? 0.0).toDouble(),
      lastUpdated: realtimeQuote['trade_time'] ?? DateTime.now().toIso8601String(),
    );
  }

  // 转换股票代码为Tushare格式
  String _convertToTsCode(String code) {
    if (code.startsWith('6')) {
      return '${code}.SH';
    } else if (code.startsWith('0') || code.startsWith('3') || code.startsWith('2')) {
      return '${code}.SZ';
    }
    return code;
  }

  // 根据代码获取地区
  String _getAreaFromCode(String code) {
    if (code.startsWith('6')) {
      return '上海';
    } else if (code.startsWith('0') || code.startsWith('3') || code.startsWith('2')) {
      return '深圳';
    }
    return '未知';
  }

  // 根据代码获取市场
  String _getMarketFromCode(String code) {
    if (code.startsWith('6')) {
      return '主板';
    } else if (code.startsWith('0')) {
      return '主板';
    } else if (code.startsWith('3')) {
      return '创业板';
    } else if (code.startsWith('2')) {
      return '中小板';
    }
    return '主板';
  }

  // 获取分时数据（分钟级K线）
  Future<List<CandlestickSpot>> fetchIntradayData(String symbol) async {
    try {
      print('Fetching intraday data for $symbol');
      
      // 使用东方财富历史分时数据API（trends2）
      final response = await dio.get(
        'https://push2his.eastmoney.com/api/qt/stock/trends2/get',
        queryParameters: {
          'secid': _getSecId(symbol),
          'ut': 'bd1d9ddb0408970cf38c7f7fda6ba90b',
          'fields1': 'f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13',
          'fields2': 'f51,f52,f53,f54,f55,f56,f57,f58',
          'iscr': '0', // 复权处理
          'ndays': '1', // 当日
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['data'] != null) {
          final trendsData = data['data'];
          final trends = trendsData['trends'];
          
          if (trends is List) {
            List<CandlestickSpot> spots = [];

            for (int i = 0; i < trends.length; i++) {
              final trend = trends[i];
              // 统一当作字符串解析："时间,价格,均价,成交量,成交额,...."
              final parts = trend.toString().split(',');
              if (parts.length >= 2) {
                final price = double.tryParse(parts[1]) ?? 0.0;
                spots.add(CandlestickSpot(
                  x: i.toDouble(),
                  open: price,
                  high: price,
                  low: price,
                  close: price,
                ));
              }
            }
            
            print('Fetched ${spots.length} intraday data points for $symbol');
            return spots;
          }
        }
      }
      
      print('No intraday data found for $symbol');
      return [];
    } catch (e) {
      print('Error fetching intraday data for $symbol: $e');
      return [];
    }
  }

  // 获取日线数据
  Future<List<CandlestickSpot>> fetchDailyData(String symbol, int days) async {
    try {
      print('Fetching daily data for $symbol, days: $days');
      
      // 使用东方财富的K线数据API
      final response = await dio.get(
        'https://push2.eastmoney.com/api/qt/stock/kline/get',
        queryParameters: {
          'secid': _getSecId(symbol),
          'ut': 'bd1d9ddb0408970cf38c7f7fda6ba90b',
          'fields1': 'f1,f2,f3,f4,f5,f6',
          'fields2': 'f51,f52,f53,f54,f55,f56,f57,f58',
          'klt': '101', // 日K线
          'fqt': '1',
          // 直接按数量获取
          'lmt': days.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['data'] != null) {
          final klineData = data['data'];
          final klines = klineData['klines'];
          
          if (klines is List) {
            List<CandlestickSpot> spots = [];

            for (int i = 0; i < klines.length; i++) {
              final kline = klines[i];
              final parts = kline.toString().split(',');
              if (parts.length >= 5) {
                final open = double.tryParse(parts[1]) ?? 0.0;
                final close = double.tryParse(parts[2]) ?? 0.0;
                final high = double.tryParse(parts[3]) ?? 0.0;
                final low = double.tryParse(parts[4]) ?? 0.0;

                spots.add(CandlestickSpot(
                  x: i.toDouble(),
                  open: open,
                  high: high,
                  low: low,
                  close: close,
                ));
              }
            }
            // 不足lmt时直接返回
            print('Fetched ${spots.length} daily data points for $symbol');
            return spots;
          }
        }
      }
      
      print('No daily data found for $symbol');
      return [];
    } catch (e) {
      print('Error fetching daily data for $symbol: $e');
      return [];
    }
  }

  // 获取周线数据
  Future<List<CandlestickSpot>> fetchWeeklyData(String symbol, int weeks) async {
    try {
      print('Fetching weekly data for $symbol, weeks: $weeks');
      
      final response = await dio.get(
        'https://push2.eastmoney.com/api/qt/stock/kline/get',
        queryParameters: {
          'secid': _getSecId(symbol),
          'ut': 'bd1d9ddb0408970cf38c7f7fda6ba90b',
          'fields1': 'f1,f2,f3,f4,f5,f6',
          'fields2': 'f51,f52,f53,f54,f55,f56,f57,f58',
          'klt': '102', // 周K线
          'fqt': '1',
          'lmt': weeks.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['data'] != null) {
          final klineData = data['data'];
          final klines = klineData['klines'];
          
          if (klines is List) {
            List<CandlestickSpot> spots = [];

            for (int i = 0; i < klines.length; i++) {
              final kline = klines[i];
              final parts = kline.toString().split(',');
              if (parts.length >= 5) {
                final open = double.tryParse(parts[1]) ?? 0.0;
                final close = double.tryParse(parts[2]) ?? 0.0;
                final high = double.tryParse(parts[3]) ?? 0.0;
                final low = double.tryParse(parts[4]) ?? 0.0;

                spots.add(CandlestickSpot(
                  x: i.toDouble(),
                  open: open,
                  high: high,
                  low: low,
                  close: close,
                ));
              }
            }
            print('Fetched ${spots.length} weekly data points for $symbol');
            return spots;
          }
        }
      }
      
      print('No weekly data found for $symbol');
      return [];
    } catch (e) {
      print('Error fetching weekly data for $symbol: $e');
      return [];
    }
  }

  // 获取月线数据
  Future<List<CandlestickSpot>> fetchMonthlyData(String symbol, int months) async {
    try {
      print('Fetching monthly data for $symbol, months: $months');
      
      final response = await dio.get(
        'https://push2.eastmoney.com/api/qt/stock/kline/get',
        queryParameters: {
          'secid': _getSecId(symbol),
          'ut': 'bd1d9ddb0408970cf38c7f7fda6ba90b',
          'fields1': 'f1,f2,f3,f4,f5,f6',
          'fields2': 'f51,f52,f53,f54,f55,f56,f57,f58',
          'klt': '103', // 月K线
          'fqt': '1',
          'lmt': months.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['data'] != null) {
          final klineData = data['data'];
          final klines = klineData['klines'];
          
          if (klines is List) {
            List<CandlestickSpot> spots = [];

            for (int i = 0; i < klines.length; i++) {
              final kline = klines[i];
              final parts = kline.toString().split(',');
              if (parts.length >= 5) {
                final open = double.tryParse(parts[1]) ?? 0.0;
                final close = double.tryParse(parts[2]) ?? 0.0;
                final high = double.tryParse(parts[3]) ?? 0.0;
                final low = double.tryParse(parts[4]) ?? 0.0;

                spots.add(CandlestickSpot(
                  x: i.toDouble(),
                  open: open,
                  high: high,
                  low: low,
                  close: close,
                ));
              }
            }
            print('Fetched ${spots.length} monthly data points for $symbol');
            return spots;
          }
        }
      }
      
      print('No monthly data found for $symbol');
      return [];
    } catch (e) {
      print('Error fetching monthly data for $symbol: $e');
      return [];
    }
  }

}
