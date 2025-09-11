import 'package:flutter/material.dart';
import 'package:tradingview_app/core/extension/context_extension.dart';
import 'package:tradingview_app/product/widget/divider/medium_full_width_divider.dart';
import 'package:tradingview_app/view/_product/widget/chart/trading_view_widget_chart.dart';
import 'package:tradingview_app/view/_product/widget/dropdownbutton/global_average_dropdown_button.dart';
import 'package:tradingview_app/view/_product/widget/screen/technical_screen.dart';
import 'package:tradingview_app/view/_product/widget/screen/transaction_screen.dart';

class TradingTabViews extends StatelessWidget {
  const TradingTabViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        children: [
          Column(
            children: [
              const TradingViewWidgetChart(),
              const SizedBox(height: 16),
              // 简化的价格信息
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('价格信息'),
                    const GlobalAverageDropdownButton(),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // 简化的底部信息
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('市场信息'),
              ),
            ],
          ),
          const TechinalsScreen(),
          const TransactionScreen()
        ],
      ),
    );
  }
}
