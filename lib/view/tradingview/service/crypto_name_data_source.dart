class CryptoNameDataSource {
  static String binanceSourceEuro(String cryptoName) {
    // TradingView 符号需大写，且 USDT 交易对覆盖面更广
    return 'BINANCE:${cryptoName.toUpperCase()}USDT';
  }

  static String cryptoNameAndSource(String name) {
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
<title>Load file or HTML string example</title>
</head>
<body>
<div class="tradingview-widget-container">
<div id="tradingview_4418d">
</div>
<script type="text/javascript" src="https://s3.tradingview.com/tv.js">
</script>
<script type="text/javascript">
new TradingView.widget({
  "width": "100%",
  "height": 1180,
  "symbol": "$name",
  "interval": "D",
  "timezone": "Etc/UTC",
  "theme": "dark",
  "style": "1",
  "locale": "en",
  "toolbar_bg": "#121536",
  "backgroundColor": "rgba(18, 21, 54, 1)",
  "enable_publishing": false,
  "save_image": false,
  "hide_side_toolbar": true,
  "hide_top_toolbar": true,
  "container_id": "tradingview_4418d"
  });
</script>
</div>
</body>
</html>''';
  }
}
