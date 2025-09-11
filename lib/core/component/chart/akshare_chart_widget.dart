import 'package:flutter/material.dart';
import 'package:tradingview_app/core/constants/color/color_constant.dart';
import 'package:tradingview_app/view/home/service/stock/akshare_stock_data_source.dart';
import 'package:dio/dio.dart';

/// 基于AKShare数据的简单K线图表组件
class AkshareChartWidget extends StatefulWidget {
  const AkshareChartWidget({
    required this.symbol,
    this.height = 300,
    super.key,
  });

  final String symbol;
  final double height;

  @override
  State<AkshareChartWidget> createState() => _AkshareChartWidgetState();
}

class _AkshareChartWidgetState extends State<AkshareChartWidget> {
  late final AkshareStockDataSource _dataSource;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _dataSource = AkshareStockDataSource(dio: Dio());
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // 获取股票数据
      final stock = await _dataSource.fetchStockBySymbol(widget.symbol);
      
      if (stock != null) {
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = '无法获取股票数据';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = '加载失败: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: widget.height,
        color: ProjectColors.cardBackground,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Color(0xFF388EFF),
                strokeWidth: 2,
              ),
              const SizedBox(height: 16),
              Text(
                '正在加载K线数据...',
                style: TextStyle(
                  color: ProjectColors.manatee,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Container(
        height: widget.height,
        color: ProjectColors.cardBackground,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: ProjectColors.cabaret,
                size: 48,
              ),
              const SizedBox(height: 16),
                Text(
                  _errorMessage,
                  style: TextStyle(
                    color: ProjectColors.manatee,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadChartData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ProjectColors.jungleGreen,
                  foregroundColor: Colors.white,
                ),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: widget.height,
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
            widget.symbol,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          
          // 提示信息
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: ProjectColors.jungleGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ProjectColors.jungleGreen.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.trending_up,
                  color: ProjectColors.jungleGreen,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  'AKShare数据源已连接',
                  style: TextStyle(
                    color: ProjectColors.jungleGreen,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'K线图表功能开发中\n当前显示基础股票信息',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ProjectColors.manatee,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // 刷新按钮
          ElevatedButton.icon(
            onPressed: _loadChartData,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('刷新数据'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ProjectColors.jungleGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
