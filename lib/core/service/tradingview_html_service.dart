class TradingViewHtmlService {
  static String generateChartHtml({
    required String symbol,
    required String timeframe,
    required String theme,
  }) {
    final interval = _getTradingViewInterval(timeframe);
    
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TradingView Chart</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            background-color: ${theme == 'dark' ? '#0c0d12' : '#ffffff'};
        }
        .tradingview-widget-container {
            width: 100%;
            height: 100%;
        }
        #tradingview_chart {
            width: 100%;
            height: 100%;
        }
    </style>
</head>
<body>
    <div class="tradingview-widget-container">
        <div id="tradingview_chart"></div>
    </div>
    
    <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
    <script type="text/javascript">
        new TradingView.widget({
            "width": "100%",
            "height": 300,
            "symbol": "$symbol",
            "interval": "$interval",
            "timezone": "Etc/UTC",
            "theme": "$theme",
            "style": "1",
            "locale": "en",
            "toolbar_bg": "${theme == 'dark' ? '#121536' : '#ffffff'}",
            "backgroundColor": "${theme == 'dark' ? 'rgba(12, 13, 18, 1)' : 'rgba(255, 255, 255, 1)'}",
            "enable_publishing": false,
            "save_image": false,
            "hide_side_toolbar": true,
            "hide_top_toolbar": true,
            "container_id": "tradingview_chart",
            "studies": [
                "Volume@tv-basicstudies"
            ],
            "show_popup_button": false,
            "popup_width": "1000",
            "popup_height": "650",
            "no_referral_id": true,
            "referral_id": "tradingview_app"
        });
    </script>
</body>
</html>''';
  }

  static String _getTradingViewInterval(String timeframe) {
    switch (timeframe) {
      case '1m':
        return '1';
      case '30m':
        return '30';
      case '1h':
        return '60';
      case 'D':
        return '1D';
      case 'W':
        return '1W';
      case 'M':
        return '1M';
      case '1日':
        return '1D';
      case '5日':
        return '5D';
      case '1月':
        return '1M';
      case '3月':
        return '3M';
      case '6月':
        return '6M';
      case '1年':
        return '1Y';
      case '5年':
        return '5Y';
      case '全部':
        return 'ALL';
      default:
        return '60'; // 默认1小时
    }
  }

  static String getSymbolForAsset(String symbol, String category) {
    switch (category) {
      case 'crypto':
        return 'BINANCE:${symbol.toUpperCase()}USDT';
      case 'forex':
        return 'FX:${symbol.toUpperCase()}';
      case 'stock':
        // 根据股票代码返回相应的交易所
        if (symbol.startsWith('000') || 
            symbol.startsWith('002') ||
            symbol.startsWith('300')) {
          return 'SZSE:$symbol';
        } else if (symbol.startsWith('60')) {
          return 'SSE:$symbol';
        } else {
          return 'NASDAQ:$symbol';
        }
      case 'commodity':
        return 'COMEX:${symbol.toUpperCase()}1!';
      default:
        return 'BINANCE:${symbol.toUpperCase()}USDT';
    }
  }
}
