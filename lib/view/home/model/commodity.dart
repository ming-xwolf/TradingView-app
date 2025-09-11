class Commodity {
  Commodity({
    this.symbol,
    this.name,
    this.category,
    this.unit,
    this.currentPrice,
    this.change,
    this.changePercent,
    this.high24h,
    this.low24h,
    this.volume24h,
    this.openInterest,
    this.lastUpdated,
  });

  Commodity.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol']?.toString();
    name = json['name']?.toString();
    category = json['category']?.toString();
    unit = json['unit']?.toString();
    currentPrice = json['current_price'] as num?;
    change = json['change'] as num?;
    changePercent = json['change_percent'] as num?;
    high24h = json['high_24h'] as num?;
    low24h = json['low_24h'] as num?;
    volume24h = json['volume_24h'] as num?;
    openInterest = json['open_interest'] as num?;
    lastUpdated = json['last_updated']?.toString();
  }

  String? symbol;
  String? name;
  String? category;
  String? unit;
  num? currentPrice;
  num? change;
  num? changePercent;
  num? high24h;
  num? low24h;
  num? volume24h;
  num? openInterest;
  String? lastUpdated;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['name'] = name;
    data['category'] = category;
    data['unit'] = unit;
    data['current_price'] = currentPrice;
    data['change'] = change;
    data['change_percent'] = changePercent;
    data['high_24h'] = high24h;
    data['low_24h'] = low24h;
    data['volume_24h'] = volume24h;
    data['open_interest'] = openInterest;
    data['last_updated'] = lastUpdated;
    return data;
  }
}
