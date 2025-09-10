import 'package:flutter/material.dart';
import 'package:tradingview_app/core/extension/context_extension.dart';
import 'package:tradingview_app/product/widget/text-area/custom_multi_text_size.dart';
import 'package:tradingview_app/view/_product/widget/text-area/cap_view.dart';
import 'package:tradingview_app/view/_product/widget/text-area/circulation_view.dart';
import 'package:tradingview_app/view/_product/widget/text-area/day_high_view.dart';
import 'package:tradingview_app/view/_product/widget/text-area/day_low_view.dart';
import 'package:tradingview_app/view/_product/widget/text-area/day_vol_view.dart';
import 'package:tradingview_app/view/home/model/crypto.dart';

class TradingViewCryptoInfoInBottom extends StatelessWidget {
  const TradingViewCryptoInfoInBottom({
    required this.crypto,
    super.key,
  });

  final Crypto crypto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ProjectColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ProjectColors.borderColor,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 只显示关键数据，移除重复的成交量
          DayHighView(crypto: crypto),
          DayLowView(crypto: crypto),
          CapView(crypto: crypto),
        ],
      ),
    );
  }
}
