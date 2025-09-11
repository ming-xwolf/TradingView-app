import 'package:flutter/material.dart';
import 'package:tradingview_app/core/component/text/label_small_text_manatee.dart';
import 'package:tradingview_app/product/init/locale/project_keys.dart';

class PriceInfo extends StatelessWidget {
  const PriceInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('价格信息', style: TextStyle(color: Colors.white, fontSize: 18)),
            const Text('USD', style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
        Row(
          children: [
            const LabelSmallTextManatee(text: '= 0.00 USD '),
            const Text('+0.00%', style: TextStyle(color: Colors.green, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
