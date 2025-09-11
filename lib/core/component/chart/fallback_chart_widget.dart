import 'package:flutter/material.dart';
import 'package:tradingview_app/core/constants/color/color_constant.dart';

/// 备用图表组件 - 当TradingView无法加载时显示
class FallbackChartWidget extends StatelessWidget {
  const FallbackChartWidget({
    required this.symbol,
    required this.currentPrice,
    required this.change,
    required this.changePercent,
    this.height = 300,
    super.key,
  });

  final String symbol;
  final double currentPrice;
  final double change;
  final double changePercent;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProjectColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 股票信息
          Text(
            symbol,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          
          // 当前价格
          Text(
            '¥${currentPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          
          // 涨跌幅
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                change >= 0 ? Icons.trending_up : Icons.trending_down,
                color: change >= 0 ? Colors.green : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)} (${changePercent >= 0 ? '+' : ''}${changePercent.toStringAsFixed(2)}%)',
                style: TextStyle(
                  fontSize: 16,
                  color: change >= 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 提示信息
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: ProjectColors.manatee.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                Text(
                  'K线图表暂时不可用',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ProjectColors.manatee,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '正在使用AKShare数据源\n请稍后查看完整图表',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ProjectColors.manatee,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
