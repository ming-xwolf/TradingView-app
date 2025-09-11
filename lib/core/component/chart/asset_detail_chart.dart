import 'package:flutter/material.dart';
import 'package:tradingview_app/core/constants/color/color_constant.dart';
import 'package:tradingview_app/view/home/model/asset_category.dart';
import 'package:tradingview_app/view/tradingview/service/trading_view_html.dart';

class AssetDetailChart extends StatefulWidget {
  const AssetDetailChart({
    required this.asset,
    required this.timeframe,
    super.key,
  });

  final AssetItem asset;
  final String timeframe;

  @override
  State<AssetDetailChart> createState() => _AssetDetailChartState();
}

class _AssetDetailChartState extends State<AssetDetailChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ProjectColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ProjectColors.borderColor,
          width: 0.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: const TradingViewWidgetHtml(),
      ),
    );
  }

  String _getTradingViewSymbol() {
    switch (widget.asset.category) {
      case AssetCategory.forex:
        return 'FX:${widget.asset.symbol.toUpperCase()}';
      case AssetCategory.stock:
        // 根据股票代码返回相应的交易所
        if (widget.asset.symbol.startsWith('000') || 
            widget.asset.symbol.startsWith('002') ||
            widget.asset.symbol.startsWith('300')) {
          return 'SZSE:${widget.asset.symbol}';
        } else if (widget.asset.symbol.startsWith('60')) {
          return 'SSE:${widget.asset.symbol}';
        } else {
          return 'NASDAQ:${widget.asset.symbol}';
        }
      case AssetCategory.commodity:
        return 'COMEX:${widget.asset.symbol.toUpperCase()}1!';
      default:
        return 'BINANCE:${widget.asset.symbol.toUpperCase()}USDT';
    }
  }
}
