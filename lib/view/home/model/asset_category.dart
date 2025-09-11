import 'package:tradingview_app/view/home/model/crypto.dart';
import 'package:tradingview_app/view/home/model/forex.dart';
import 'package:tradingview_app/view/home/model/stock.dart';
import 'package:tradingview_app/view/home/model/commodity.dart';

enum AssetCategory {
  forex('外汇', 'forex'),
  crypto('加密货币', 'crypto'),
  stock('股票', 'stock'),
  commodity('商品', 'commodity');

  const AssetCategory(this.displayName, this.value);
  final String displayName;
  final String value;
}

class AssetItem {
  final String symbol;
  final String name;
  final String subtitle;
  final double currentPrice;
  final double change;
  final double changePercent;
  final String iconUrl;
  final AssetCategory category;
  final bool isPositive;

  AssetItem({
    required this.symbol,
    required this.name,
    required this.subtitle,
    required this.currentPrice,
    required this.change,
    required this.changePercent,
    required this.iconUrl,
    required this.category,
  }) : isPositive = change >= 0;

  factory AssetItem.fromCrypto(Crypto crypto) {
    final price = (crypto.quote?.uSD?.price ?? 0.0).toDouble();
    final changePercent = (crypto.quote?.uSD?.percentChange24h ?? 0.0).toDouble();
    final change = price * (changePercent / 100);
    
    return AssetItem(
      symbol: crypto.symbol?.toUpperCase() ?? '',
      name: '${crypto.symbol?.toUpperCase()}USD',
      subtitle: '${crypto.name} / 美元',
      currentPrice: price,
      change: change,
      changePercent: changePercent,
      iconUrl: crypto.image ?? '',
      category: AssetCategory.crypto,
    );
  }

  factory AssetItem.forex({
    required String symbol,
    required String name,
    required String subtitle,
    required double currentPrice,
    required double change,
    required double changePercent,
    required String iconUrl,
  }) {
    return AssetItem(
      symbol: symbol,
      name: name,
      subtitle: subtitle,
      currentPrice: currentPrice,
      change: change,
      changePercent: changePercent,
      iconUrl: iconUrl,
      category: AssetCategory.forex,
    );
  }

  factory AssetItem.stock({
    required String symbol,
    required String name,
    required String subtitle,
    required double currentPrice,
    required double change,
    required double changePercent,
    required String iconUrl,
  }) {
    return AssetItem(
      symbol: symbol,
      name: name,
      subtitle: subtitle,
      currentPrice: currentPrice,
      change: change,
      changePercent: changePercent,
      iconUrl: iconUrl,
      category: AssetCategory.stock,
    );
  }

  factory AssetItem.fromForex(Forex forex) {
    final price = (forex.currentPrice ?? 0.0).toDouble();
    final changePercent = (forex.changePercent ?? 0.0).toDouble();
    final change = (forex.change ?? 0.0).toDouble();
    
    return AssetItem(
      symbol: forex.symbol?.toUpperCase() ?? '',
      name: forex.name ?? '',
      subtitle: '${forex.baseCurrency}/${forex.quoteCurrency}',
      currentPrice: price,
      change: change,
      changePercent: changePercent,
      iconUrl: '', // 外汇通常没有图标
      category: AssetCategory.forex,
    );
  }

  factory AssetItem.fromStock(Stock stock) {
    final price = (stock.currentPrice ?? 0.0).toDouble();
    final changePercent = (stock.changePercent ?? 0.0).toDouble();
    final change = (stock.change ?? 0.0).toDouble();
    
    return AssetItem(
      symbol: stock.symbol?.toUpperCase() ?? '',
      name: stock.name ?? '',
      subtitle: '${stock.exchange} - ${stock.sector}',
      currentPrice: price,
      change: change,
      changePercent: changePercent,
      iconUrl: '', // 股票图标需要单独处理
      category: AssetCategory.stock,
    );
  }

  factory AssetItem.fromCommodity(Commodity commodity) {
    final price = (commodity.currentPrice ?? 0.0).toDouble();
    final changePercent = (commodity.changePercent ?? 0.0).toDouble();
    final change = (commodity.change ?? 0.0).toDouble();
    
    return AssetItem(
      symbol: commodity.symbol?.toUpperCase() ?? '',
      name: commodity.name ?? '',
      subtitle: '${commodity.category} - ${commodity.unit}',
      currentPrice: price,
      change: change,
      changePercent: changePercent,
      iconUrl: '', // 商品图标需要单独处理
      category: AssetCategory.commodity,
    );
  }
}

