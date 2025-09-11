import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TradingViewWidgetHtml extends StatefulWidget {
  const TradingViewWidgetHtml({super.key});

  @override
  State<TradingViewWidgetHtml> createState() => _TradingViewWidgetHtmlState();
}

class _TradingViewWidgetHtmlState extends State<TradingViewWidgetHtml> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('progress');
          },
          onPageStarted: (String url) {
            debugPrint('started');
          },
          onPageFinished: (String url) {
            debugPrint('finished');
          },
        ),
      )
      ..enableZoom(true)
      ..loadHtmlString(_getDefaultTradingViewHtml());
  }

  String _getDefaultTradingViewHtml() {
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
<title>TradingView Chart</title>
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
  "symbol": "BINANCE:BTCUSDT",
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

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}
