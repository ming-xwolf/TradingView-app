class TushareStock {
  TushareStock({
    this.tsCode,
    this.symbol,
    this.name,
    this.area,
    this.industry,
    this.market,
    this.listDate,
    this.listStatus,
    this.isHs,
  });

  TushareStock.fromJson(Map<String, dynamic> json) {
    tsCode = json['ts_code']?.toString();
    symbol = json['symbol']?.toString();
    name = json['name']?.toString();
    area = json['area']?.toString();
    industry = json['industry']?.toString();
    market = json['market']?.toString();
    listDate = json['list_date']?.toString();
    listStatus = json['list_status']?.toString();
    isHs = json['is_hs']?.toString();
  }

  String? tsCode; // 股票代码
  String? symbol; // 股票代码（不含后缀）
  String? name; // 股票名称
  String? area; // 地域
  String? industry; // 所属行业
  String? market; // 市场类型
  String? listDate; // 上市日期
  String? listStatus; // 上市状态
  String? isHs; // 是否沪深港通标的

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ts_code'] = tsCode;
    data['symbol'] = symbol;
    data['name'] = name;
    data['area'] = area;
    data['industry'] = industry;
    data['market'] = market;
    data['list_date'] = listDate;
    data['list_status'] = listStatus;
    data['is_hs'] = isHs;
    return data;
  }
}

class TushareDaily {
  TushareDaily({
    this.tsCode,
    this.tradeDate,
    this.open,
    this.high,
    this.low,
    this.close,
    this.preClose,
    this.change,
    this.pctChg,
    this.vol,
    this.amount,
  });

  TushareDaily.fromJson(Map<String, dynamic> json) {
    tsCode = json['ts_code']?.toString();
    tradeDate = json['trade_date']?.toString();
    open = json['open'] as num?;
    high = json['high'] as num?;
    low = json['low'] as num?;
    close = json['close'] as num?;
    preClose = json['pre_close'] as num?;
    change = json['change'] as num?;
    pctChg = json['pct_chg'] as num?;
    vol = json['vol'] as num?;
    amount = json['amount'] as num?;
  }

  String? tsCode; // 股票代码
  String? tradeDate; // 交易日期
  num? open; // 开盘价
  num? high; // 最高价
  num? low; // 最低价
  num? close; // 收盘价
  num? preClose; // 昨收价
  num? change; // 涨跌额
  num? pctChg; // 涨跌幅
  num? vol; // 成交量
  num? amount; // 成交额

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ts_code'] = tsCode;
    data['trade_date'] = tradeDate;
    data['open'] = open;
    data['high'] = high;
    data['low'] = low;
    data['close'] = close;
    data['pre_close'] = preClose;
    data['change'] = change;
    data['pct_chg'] = pctChg;
    data['vol'] = vol;
    data['amount'] = amount;
    return data;
  }
}

class TushareRealtimeQuote {
  TushareRealtimeQuote({
    this.code,
    this.name,
    this.close,
    this.pctChg,
    this.change,
    this.volume,
    this.amount,
    this.turnover,
    this.pe,
    this.pb,
    this.totalShare,
    this.floatShare,
    this.high,
    this.low,
    this.open,
    this.preClose,
    this.tradeTime,
  });

  TushareRealtimeQuote.fromJson(Map<String, dynamic> json) {
    code = json['code']?.toString();
    name = json['name']?.toString();
    close = json['close'] as num?;
    pctChg = json['pct_chg'] as num?;
    change = json['change'] as num?;
    volume = json['volume'] as num?;
    amount = json['amount'] as num?;
    turnover = json['turnover'] as num?;
    pe = json['pe'] as num?;
    pb = json['pb'] as num?;
    totalShare = json['total_share'] as num?;
    floatShare = json['float_share'] as num?;
    high = json['high'] as num?;
    low = json['low'] as num?;
    open = json['open'] as num?;
    preClose = json['pre_close'] as num?;
    tradeTime = json['trade_time']?.toString();
  }

  String? code; // 股票代码
  String? name; // 股票名称
  num? close; // 最新价
  num? pctChg; // 涨跌幅
  num? change; // 涨跌额
  num? volume; // 成交量
  num? amount; // 成交额
  num? turnover; // 换手率
  num? pe; // 市盈率
  num? pb; // 市净率
  num? totalShare; // 总股本
  num? floatShare; // 流通股本
  num? high; // 最高价
  num? low; // 最低价
  num? open; // 开盘价
  num? preClose; // 昨收价
  String? tradeTime; // 交易时间

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['close'] = close;
    data['pct_chg'] = pctChg;
    data['change'] = change;
    data['volume'] = volume;
    data['amount'] = amount;
    data['turnover'] = turnover;
    data['pe'] = pe;
    data['pb'] = pb;
    data['total_share'] = totalShare;
    data['float_share'] = floatShare;
    data['high'] = high;
    data['low'] = low;
    data['open'] = open;
    data['pre_close'] = preClose;
    data['trade_time'] = tradeTime;
    return data;
  }
}
