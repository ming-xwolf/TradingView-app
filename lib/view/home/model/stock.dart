class Stock {
  Stock({
    this.symbol,
    this.name,
    this.exchange,
    this.sector,
    this.industry,
    this.currentPrice,
    this.change,
    this.changePercent,
    this.high52w,
    this.low52w,
    this.volume,
    this.marketCap,
    this.peRatio,
    this.lastUpdated,
  });

  Stock.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol']?.toString();
    name = json['name']?.toString();
    exchange = json['exchange']?.toString();
    sector = json['sector']?.toString();
    industry = json['industry']?.toString();
    currentPrice = json['current_price'] as num?;
    change = json['change'] as num?;
    changePercent = json['change_percent'] as num?;
    high52w = json['high_52w'] as num?;
    low52w = json['low_52w'] as num?;
    volume = json['volume'] as num?;
    marketCap = json['market_cap'] as num?;
    peRatio = json['pe_ratio'] as num?;
    lastUpdated = json['last_updated']?.toString();
  }

  String? symbol;
  String? name;
  String? exchange;
  String? sector;
  String? industry;
  num? currentPrice;
  num? change;
  num? changePercent;
  num? high52w;
  num? low52w;
  num? volume;
  num? marketCap;
  num? peRatio;
  String? lastUpdated;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['name'] = name;
    data['exchange'] = exchange;
    data['sector'] = sector;
    data['industry'] = industry;
    data['current_price'] = currentPrice;
    data['change'] = change;
    data['change_percent'] = changePercent;
    data['high_52w'] = high52w;
    data['low_52w'] = low52w;
    data['volume'] = volume;
    data['market_cap'] = marketCap;
    data['pe_ratio'] = peRatio;
    data['last_updated'] = lastUpdated;
    return data;
  }
}
