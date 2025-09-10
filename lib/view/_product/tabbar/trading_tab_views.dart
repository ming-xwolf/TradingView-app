import 'package:flutter/material.dart';
import 'package:tradingview_app/core/extension/context_extension.dart';
import 'package:tradingview_app/product/widget/divider/medium_full_width_divider.dart';
import 'package:tradingview_app/view/_product/widget/bottom/trading_view_crypto_info_bottom.dart';
import 'package:tradingview_app/view/_product/widget/chart/trading_view_widget_chart.dart';
import 'package:tradingview_app/view/_product/widget/dropdownbutton/global_average_dropdown_button.dart';
import 'package:tradingview_app/view/_product/widget/screen/technical_screen.dart';
import 'package:tradingview_app/view/_product/widget/screen/transaction_screen.dart';
import 'package:tradingview_app/view/_product/widget/text-for-price/price_info.dart';
import 'package:tradingview_app/view/home/model/crypto.dart';

class TradingTabViews extends StatelessWidget {
  const TradingTabViews({
    required this.crypto,
    super.key,
  });

  final Crypto crypto;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        children: [
          Column(
            children: [
              TradingViewWidgetChart(crypto: crypto),
              const SizedBox(height: 16),
              // 简化的价格信息
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PriceInfo(crypto: crypto),
                    const GlobalAverageDropdownButton(),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // 简化的底部信息
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TradingViewCryptoInfoInBottom(crypto: crypto),
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
