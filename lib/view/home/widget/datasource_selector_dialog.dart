import 'package:flutter/material.dart';
import 'package:tradingview_app/core/constants/color/color_constant.dart';
import 'package:tradingview_app/view/home/service/stock/stock_data_source_selector.dart';

class DataSourceSelectorDialog extends StatefulWidget {
  final StockDataSourceSelector stockDataSourceSelector;
  final VoidCallback? onDataSourceChanged;

  const DataSourceSelectorDialog({
    Key? key,
    required this.stockDataSourceSelector,
    this.onDataSourceChanged,
  }) : super(key: key);

  @override
  State<DataSourceSelectorDialog> createState() => _DataSourceSelectorDialogState();
}

class _DataSourceSelectorDialogState extends State<DataSourceSelectorDialog> {
  late StockDataSourceType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.stockDataSourceSelector.currentDataSourceType;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ProjectColors.ebonyClay,
      title: Text(
        '选择数据源',
        style: TextStyle(
          color: ProjectColors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '请选择股票数据的数据源',
            style: TextStyle(
              color: ProjectColors.manateeLight,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ...StockDataSourceType.values.map((type) {
            return RadioListTile<StockDataSourceType>(
              title: Text(
                _getDataSourceDisplayName(type),
                style: TextStyle(
                  color: ProjectColors.white,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                _getDataSourceDescription(type),
                style: TextStyle(
                  color: ProjectColors.manateeLight,
                  fontSize: 12,
                ),
              ),
              value: type,
              groupValue: _selectedType,
              activeColor: ProjectColors.pictonBlue,
              onChanged: (StockDataSourceType? value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
            );
          }).toList(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            '取消',
            style: TextStyle(
              color: ProjectColors.manateeLight,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            widget.stockDataSourceSelector.switchDataSource(_selectedType);
            widget.onDataSourceChanged?.call();
            Navigator.of(context).pop();
            
            // 显示切换成功的提示
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('已切换到 ${_getDataSourceDisplayName(_selectedType)} 数据源'),
                backgroundColor: ProjectColors.pictonBlue,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ProjectColors.pictonBlue,
            foregroundColor: ProjectColors.white,
          ),
          child: const Text('确定'),
        ),
      ],
    );
  }

  String _getDataSourceDisplayName(StockDataSourceType type) {
    switch (type) {
      case StockDataSourceType.tushare:
        return 'Tushare Pro';
      case StockDataSourceType.akshare:
        return 'Akshare (东方财富)';
      case StockDataSourceType.mock:
        return '模拟数据';
    }
  }

  String _getDataSourceDescription(StockDataSourceType type) {
    switch (type) {
      case StockDataSourceType.tushare:
        return '专业的金融数据服务，数据准确但有限制';
      case StockDataSourceType.akshare:
        return '免费的金融数据源，覆盖A股市场';
      case StockDataSourceType.mock:
        return '用于测试的模拟数据';
    }
  }
}
