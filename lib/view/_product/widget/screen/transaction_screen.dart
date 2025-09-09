import 'package:flutter/material.dart';
import 'package:tradingview_app/core/constants/color/color_constant.dart';
import 'package:tradingview_app/core/extension/context_extension.dart';
import 'package:tradingview_app/product/init/locale/project_keys.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({
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
              '交易功能',
              style: TextStyle(
                color: ProjectColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildTransactionCard('买入', 'BTC', '112,706.96', ProjectColors.jungleGreen),
            SizedBox(height: 12),
            _buildTransactionCard('卖出', 'BTC', '112,706.96', ProjectColors.cabaret),
            SizedBox(height: 20),
            Text(
              '最近交易',
              style: TextStyle(
                color: ProjectColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            _buildTransactionHistory('买入', '0.001 BTC', '112.70', '2024-01-15 14:30'),
            _buildTransactionHistory('卖出', '0.005 BTC', '112.50', '2024-01-15 10:15'),
            _buildTransactionHistory('买入', '0.002 BTC', '111.80', '2024-01-14 16:45'),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(String action, String symbol, String price, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProjectColors.marinique,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                action,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                action == '买入' ? Icons.trending_up : Icons.trending_down,
                color: color,
                size: 24,
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$symbol 价格',
                style: TextStyle(
                  color: ProjectColors.manatee,
                  fontSize: 14,
                ),
              ),
              Text(
                '\$$price',
                style: TextStyle(
                  color: ProjectColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // 这里可以添加交易逻辑
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: ProjectColors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                action,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHistory(String type, String amount, String price, String time) {
    Color typeColor = type == '买入' ? ProjectColors.jungleGreen : ProjectColors.cabaret;
    
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ProjectColors.marinique,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: typeColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: TextStyle(
                      color: ProjectColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      color: ProjectColors.manatee,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: ProjectColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$$price',
                style: TextStyle(
                  color: ProjectColors.manatee,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
