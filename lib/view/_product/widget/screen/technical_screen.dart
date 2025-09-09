import 'package:flutter/material.dart';
import 'package:tradingview_app/core/constants/color/color_constant.dart';
import 'package:tradingview_app/core/extension/context_extension.dart';
import 'package:tradingview_app/product/init/locale/project_keys.dart';
import 'package:tradingview_app/view/home/model/crypto.dart';

class TechinalsScreen extends StatelessWidget {
  const TechinalsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ProjectColors.haiti,
      child: Padding(
        padding: context.labelPad,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '技术指标',
              style: TextStyle(
                color: ProjectColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildTechnicalIndicator('RSI (14)', '65.2', '中性'),
            SizedBox(height: 12),
            _buildTechnicalIndicator('MACD', '1,234.5', '看涨'),
            SizedBox(height: 12),
            _buildTechnicalIndicator('布林带', '上轨: 115,000', '震荡'),
            SizedBox(height: 12),
            _buildTechnicalIndicator('移动平均线', 'MA20: 110,500', '支撑'),
            SizedBox(height: 20),
            Text(
              '支撑阻力位',
              style: TextStyle(
                color: ProjectColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            _buildSupportResistance('阻力位 1', '115,000'),
            _buildSupportResistance('阻力位 2', '118,000'),
            _buildSupportResistance('支撑位 1', '108,000'),
            _buildSupportResistance('支撑位 2', '105,000'),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicalIndicator(String name, String value, String signal) {
    Color signalColor = ProjectColors.jungleGreen;
    if (signal == '看跌') {
      signalColor = ProjectColors.cabaret;
    } else if (signal == '中性') {
      signalColor = ProjectColors.manatee;
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ProjectColors.marinique,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              color: ProjectColors.white,
              fontSize: 16,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  color: ProjectColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: signalColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  signal,
                  style: TextStyle(
                    color: ProjectColors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSupportResistance(String level, String price) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            level,
            style: TextStyle(
              color: ProjectColors.manatee,
              fontSize: 14,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              color: ProjectColors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
