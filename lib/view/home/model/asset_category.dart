import 'package:tradingview_app/view/home/model/crypto.dart';

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
}

