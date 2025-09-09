class Crypto {
  Crypto({this.id, this.name, this.symbol, this.slug, this.image, this.quote});
  Crypto.fromJson(Map<String, dynamic> json) {
    // CoinGecko: id 为字符串
    id = json['id'] as String?;
    name = json['name']?.toString();
    symbol = json['symbol']?.toString();
    slug = json['id']?.toString();
    image = json['image']?.toString();
    // 使用 CoinGecko 字段构造 Quote/USD
    quote = json['current_price'] != null ? Quote.fromJson(json) : null;
  }
  String? id;
  String? name;
  String? symbol;
  String? slug;
  String? image;
  Quote? quote;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['symbol'] = symbol;
    data['slug'] = slug;
    data['image'] = image;
    if (quote != null) {
      data['quote'] = quote!.toJson();
    }
    return data;
  }
}

class Quote {
  Quote({this.uSD});
  Quote.fromJson(Map<String, dynamic> json) {
    uSD = USD.fromJson(json);
  }
  USD? uSD;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (uSD != null) {
      data['USD'] = uSD!.toJson();
    }
    return data;
  }
}

class USD {
  USD({
    this.price,
    this.volume24h,
    this.percentChange24h,
    this.marketCap,
    this.high24h,
    this.low24h,
  });
  USD.fromJson(Map<String, dynamic> json) {
    // CoinGecko 对应字段
    price = json['current_price'] as num?;
    volume24h = json['total_volume'] as num?;
    percentChange24h = json['price_change_percentage_24h'] as num?;
    marketCap = json['market_cap'] as num?;
    high24h = json['high_24h'] as num?;
    low24h = json['low_24h'] as num?;
  }
  num? price;
  num? volume24h;
  num? percentChange24h;
  num? marketCap;
  num? high24h;
  num? low24h;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['current_price'] = price;
    data['total_volume'] = volume24h;
    data['price_change_percentage_24h'] = percentChange24h;
    data['market_cap'] = marketCap;
    data['high_24h'] = high24h;
    data['low_24h'] = low24h;
    return data;
  }
}
