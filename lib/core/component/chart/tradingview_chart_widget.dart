import 'package:flutter/material.dart';
import 'package:tradingview_app/core/service/tradingview_html_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TradingViewChartWidget extends StatefulWidget {
  const TradingViewChartWidget({
    required this.symbol,
    required this.timeframe,
    required this.category,
    this.height = 200,
    this.theme = 'dark',
    super.key,
  });

  final String symbol;
  final String timeframe;
  final String category;
  final double height;
  final String theme;

  @override
  State<TradingViewChartWidget> createState() => _TradingViewChartWidgetState();
}

class _TradingViewChartWidgetState extends State<TradingViewChartWidget> {
  WebViewController? controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..enableZoom(false)
      ..loadHtmlString(_generateChartHtml());
  }

  String _generateChartHtml() {
    final tradingViewSymbol = TradingViewHtmlService.getSymbolForAsset(
      widget.symbol,
      widget.category,
    );
    
    return TradingViewHtmlService.generateChartHtml(
      symbol: tradingViewSymbol,
      timeframe: widget.timeframe,
      theme: widget.theme,
    );
  }

  @override
  void didUpdateWidget(TradingViewChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.symbol != widget.symbol || 
        oldWidget.timeframe != widget.timeframe ||
        oldWidget.category != widget.category) {
      _initializeWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return Container(
        height: widget.height,
        color: const Color(0xFF0C0D12),
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF388EFF),
            strokeWidth: 2,
          ),
        ),
      );
    }
    
    return Container(
      height: widget.height,
      child: Stack(
        children: [
          WebViewWidget(controller: controller!),
          if (_isLoading)
            Container(
              height: widget.height,
              color: const Color(0xFF0C0D12),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF388EFF),
                  strokeWidth: 2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
