import 'package:flutter/material.dart';
import 'package:tradingview_app/core/extension/context_extension.dart';
import 'package:tradingview_app/view/tradingview/service/trading_view_html.dart';

class TradingViewWidgetChart extends StatelessWidget {
  const TradingViewWidgetChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.tradingViewWidgetHeight,
      child: Padding(
        padding: context.smallTopPad,
        child: const TradingViewWidgetHtml(),
      ),
    );
  }
}
