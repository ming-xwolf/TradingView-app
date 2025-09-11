import 'package:dio/dio.dart';
import 'package:tradingview_app/view/home/model/asset_category.dart';
import 'package:tradingview_app/view/home/model/crypto.dart';
import 'package:tradingview_app/view/home/model/forex.dart';
import 'package:tradingview_app/view/home/model/stock.dart';
import 'package:tradingview_app/view/home/model/commodity.dart';
import 'package:tradingview_app/view/home/service/crypto/icrypto_data_source.dart';
import 'package:tradingview_app/view/home/service/forex/iforex_data_source.dart';
import 'package:tradingview_app/view/home/service/stock/istock_data_source.dart';
import 'package:tradingview_app/view/home/service/stock/tushare_stock_data_source.dart';
import 'package:tradingview_app/view/home/service/commodity/icommodity_data_source.dart';

/// 资产管理器 - 统一管理所有资产类别的数据源
class AssetDataManager {
  final ICryptoDataSource _cryptoDataSource;
  final IForexDataSource _forexDataSource;
  final IStockDataSource _stockDataSource;
  final ICommodityDataSource _commodityDataSource;

  AssetDataManager({
    required ICryptoDataSource cryptoDataSource,
    required IForexDataSource forexDataSource,
    required IStockDataSource stockDataSource,
    required ICommodityDataSource commodityDataSource,
  }) : _cryptoDataSource = cryptoDataSource,
       _forexDataSource = forexDataSource,
       _stockDataSource = stockDataSource,
       _commodityDataSource = commodityDataSource;

  /// 获取指定类别的所有资产
  Future<List<AssetItem>> getAllAssetsByCategory(AssetCategory category) async {
    switch (category) {
      case AssetCategory.crypto:
        final cryptoList = await _cryptoDataSource.fetchData();
        return cryptoList.map((crypto) => AssetItem.fromCrypto(crypto)).toList();
      
      case AssetCategory.forex:
        final forexList = await _forexDataSource.fetchData();
        return forexList.map((forex) => AssetItem.fromForex(forex)).toList();
      
      case AssetCategory.stock:
        final stockList = await _stockDataSource.fetchData();
        return stockList.map((stock) => AssetItem.fromStock(stock)).toList();
      
      case AssetCategory.commodity:
        final commodityList = await _commodityDataSource.fetchData();
        return commodityList.map((commodity) => AssetItem.fromCommodity(commodity)).toList();
    }
  }

  /// 获取所有资产类别的数据
  Future<Map<AssetCategory, List<AssetItem>>> getAllAssets() async {
    final Map<AssetCategory, List<AssetItem>> allAssets = {};
    
    for (final category in AssetCategory.values) {
      allAssets[category] = await getAllAssetsByCategory(category);
    }
    
    return allAssets;
  }

  /// 根据符号搜索资产
  Future<AssetItem?> searchAssetBySymbol(String symbol, AssetCategory category) async {
    switch (category) {
      case AssetCategory.crypto:
        final cryptoList = await _cryptoDataSource.fetchData();
        final crypto = cryptoList.where((c) => c.symbol?.toUpperCase() == symbol.toUpperCase()).firstOrNull;
        return crypto != null ? AssetItem.fromCrypto(crypto) : null;
      
      case AssetCategory.forex:
        final forex = await _forexDataSource.fetchForexBySymbol(symbol);
        return forex != null ? AssetItem.fromForex(forex) : null;
      
      case AssetCategory.stock:
        final stock = await _stockDataSource.fetchStockBySymbol(symbol);
        return stock != null ? AssetItem.fromStock(stock) : null;
      
      case AssetCategory.commodity:
        final commodity = await _commodityDataSource.fetchCommodityBySymbol(symbol);
        return commodity != null ? AssetItem.fromCommodity(commodity) : null;
    }
  }

  /// 获取股票交易所的股票列表
  Future<List<AssetItem>> getStocksByExchange(String exchange) async {
    final stockList = await _stockDataSource.fetchStocksByExchange(exchange);
    return stockList.map((stock) => AssetItem.fromStock(stock)).toList();
  }

  /// 获取商品分类的商品列表
  Future<List<AssetItem>> getCommoditiesByCategory(String category) async {
    final commodityList = await _commodityDataSource.fetchCommoditiesByCategory(category);
    return commodityList.map((commodity) => AssetItem.fromCommodity(commodity)).toList();
  }

  /// 使用Tushare获取股票数据
  Future<List<AssetItem>> getTushareStocks() async {
    final tushareDataSource = TushareStockDataSource(dio: Dio());
    final stockList = await tushareDataSource.fetchData();
    return stockList.map((stock) => AssetItem.fromStock(stock)).toList();
  }

  /// 使用Tushare获取特定交易所的股票
  Future<List<AssetItem>> getTushareStocksByExchange(String exchange) async {
    final tushareDataSource = TushareStockDataSource(dio: Dio());
    final stockList = await tushareDataSource.fetchStocksByExchange(exchange);
    return stockList.map((stock) => AssetItem.fromStock(stock)).toList();
  }
}
