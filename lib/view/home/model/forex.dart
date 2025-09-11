class Forex {
  Forex({
    this.symbol,
    this.name,
    this.baseCurrency,
    this.quoteCurrency,
    this.currentPrice,
    this.change,
    this.changePercent,
    this.high24h,
    this.low24h,
    this.volume24h,
    this.lastUpdated,
  });

  Forex.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol']?.toString();
    name = json['name']?.toString();
    baseCurrency = json['base_currency']?.toString();
    quoteCurrency = json['quote_currency']?.toString();
    currentPrice = json['current_price'] as num?;
    change = json['change'] as num?;
    changePercent = json['change_percent'] as num?;
    high24h = json['high_24h'] as num?;
    low24h = json['low_24h'] as num?;
    volume24h = json['volume_24h'] as num?;
    lastUpdated = json['last_updated']?.toString();
  }

  String? symbol;
  String? name;
  String? baseCurrency;
  String? quoteCurrency;
  num? currentPrice;
  num? change;
  num? changePercent;
  num? high24h;
  num? low24h;
  num? volume24h;
  String? lastUpdated;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['name'] = name;
    data['base_currency'] = baseCurrency;
    data['quote_currency'] = quoteCurrency;
    data['current_price'] = currentPrice;
    data['change'] = change;
    data['change_percent'] = changePercent;
    data['high_24h'] = high24h;
    data['low_24h'] = low24h;
    data['volume_24h'] = volume24h;
    data['last_updated'] = lastUpdated;
    return data;
  }
}
