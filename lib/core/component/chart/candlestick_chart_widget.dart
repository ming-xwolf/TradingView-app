import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dio/dio.dart';
import 'package:tradingview_app/core/constants/color/color_constant.dart';
import 'package:tradingview_app/view/home/service/stock/akshare_stock_data_source.dart';
import 'package:tradingview_app/view/home/model/stock.dart';

class CandlestickChartWidget extends StatefulWidget {
  final String symbol;
  final double height;

  const CandlestickChartWidget({
    Key? key,
    required this.symbol,
    this.height = 300,
  }) : super(key: key);

  @override
  State<CandlestickChartWidget> createState() => _CandlestickChartWidgetState();
}

class _CandlestickChartWidgetState extends State<CandlestickChartWidget> {
  late AkshareStockDataSource _dataSource;
  Stock? _stock;
  List<CandlestickSpot> _candlestickSpots = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedPeriod = '分时';

  // 默认展示的K线根数（便于阅读）
  static const int _defaultDailyBars = 90;   // 约4-5个月
  static const int _defaultWeeklyBars = 60;  // 约一年多
  static const int _defaultMonthlyBars = 60; // 约5年

  @override
  void initState() {
    super.initState();
    _dataSource = AkshareStockDataSource(dio: Dio());
    _loadStockData();
  }

  Future<void> _loadStockData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final stock = await _dataSource.fetchStockBySymbol(widget.symbol);
      if (stock != null) {
        setState(() {
          _stock = stock;
          _isLoading = false;
        });
        // 加载K线数据
        await _loadCandlestickData();
      } else {
        setState(() {
          _errorMessage = '未找到股票数据';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '加载失败: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCandlestickData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // 根据选择的时间周期获取不同的数据
      List<CandlestickSpot> spots = [];
      
      switch (_selectedPeriod) {
        case '分时':
          spots = await _fetchIntradayData();
          break;
        case 'D':
          // 取最近若干根日K
          spots = await _fetchDailyData(_defaultDailyBars);
          break;
        case 'W':
          // 取最近若干根周K
          spots = await _fetchWeeklyData(_defaultWeeklyBars);
          break;
        case 'M':
          // 取最近若干根月K
          spots = await _fetchMonthlyData(_defaultMonthlyBars);
          break;
        default:
          spots = await _fetchIntradayData();
      }

      setState(() {
        _candlestickSpots = spots;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '加载K线数据失败: $e';
        _isLoading = false;
      });
    }
  }

  // 获取分时数据（分钟级）
  Future<List<CandlestickSpot>> _fetchIntradayData() async {
    try {
      // 检查是否在A股交易时间内
      if (!_isTradingTime()) {
        print('Outside A-share trading hours, using cached data or showing message');
        // 可以在这里显示非交易时间提示
      }
      return await _dataSource.fetchIntradayData(widget.symbol);
    } catch (e) {
      print('Error fetching intraday data: $e');
      return [];
    }
  }

  // 检查是否在A股交易时间内
  bool _isTradingTime() {
    final now = DateTime.now();
    final weekday = now.weekday; // 1=Monday, 7=Sunday
    
    // A股交易时间：周一至周五，上午9:30-11:30，下午13:00-15:00
    if (weekday < 6) { // 周一到周五
      final hour = now.hour;
      final minute = now.minute;
      final timeInMinutes = hour * 60 + minute;
      
      // 上午交易时间：9:30-11:30
      final morningStart = 9 * 60 + 30; // 9:30
      final morningEnd = 11 * 60 + 30; // 11:30
      
      // 下午交易时间：13:00-15:00
      final afternoonStart = 13 * 60; // 13:00
      final afternoonEnd = 15 * 60; // 15:00
      
      return (timeInMinutes >= morningStart && timeInMinutes <= morningEnd) ||
             (timeInMinutes >= afternoonStart && timeInMinutes <= afternoonEnd);
    }
    
    return false; // 周末不交易
  }

  // 获取日线数据
  Future<List<CandlestickSpot>> _fetchDailyData(int days) async {
    try {
      return await _dataSource.fetchDailyData(widget.symbol, days);
    } catch (e) {
      print('Error fetching daily data: $e');
      return [];
    }
  }

  // 获取周线数据
  Future<List<CandlestickSpot>> _fetchWeeklyData(int weeks) async {
    try {
      return await _dataSource.fetchWeeklyData(widget.symbol, weeks);
    } catch (e) {
      print('Error fetching weekly data: $e');
      return [];
    }
  }

  // 获取月线数据
  Future<List<CandlestickSpot>> _fetchMonthlyData(int months) async {
    try {
      return await _dataSource.fetchMonthlyData(widget.symbol, months);
    } catch (e) {
      print('Error fetching monthly data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: widget.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(ProjectColors.pictonBlue),
              ),
              SizedBox(height: 16),
              Text(
                '加载K线数据中...',
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

    if (_errorMessage != null) {
      return Container(
        height: widget.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadStockData,
                child: Text('重试'),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: widget.height,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // 股票信息头部
          _buildStockHeader(),
          SizedBox(height: 16),
          // 时间周期选择
          _buildPeriodSelector(),
          SizedBox(height: 16),
          // K线图
          Expanded(
            child: _buildCandlestickChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildStockHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ProjectColors.pictonBlue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              _stock?.name?.substring(0, 1) ?? '?',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _stock?.name ?? '未知股票',
                style: TextStyle(
                  color: ProjectColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${widget.symbol}',
                style: TextStyle(
                  color: ProjectColors.manatee,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '¥${_stock?.currentPrice?.toStringAsFixed(2) ?? '0.00'}',
              style: TextStyle(
                color: ProjectColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
              Text(
                '${_stock?.change ?? 0.0} (${_stock?.changePercent?.toStringAsFixed(2) ?? '0.00'}%)',
                style: TextStyle(
                  color: (_stock?.change ?? 0.0) >= 0 ? Colors.red : Colors.green, // 中国A股：红涨绿跌
                  fontSize: 12,
                ),
              ),
          ],
        ),
        SizedBox(width: 8),
        // 添加交易状态指示器
        _buildTradingStatusIndicator(),
      ],
    );
  }

  // 构建交易状态指示器
  Widget _buildTradingStatusIndicator() {
    final isTrading = _isTradingTime();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isTrading ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isTrading ? '交易中' : '休市',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    // A股常用：分时、D（日K）、W（周K）、M（月K）
    final periods = ['分时', 'D', 'W', 'M'];
    
    return Row(
      children: periods.map((period) {
        final isSelected = _selectedPeriod == period;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedPeriod = period;
              });
              // 重新加载数据
              _loadCandlestickData();
            },
            child: Container(
              height: 32,
              margin: EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isSelected ? ProjectColors.pictonBlue : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? ProjectColors.pictonBlue : ProjectColors.manatee,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  period,
                  style: TextStyle(
                    color: isSelected ? Colors.white : ProjectColors.manatee,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCandlestickChart() {
    if (_candlestickSpots.isEmpty) {
      return _buildNoDataMessage();
    }

    // 分时图走单独的线图渲染（即时价格线+均价线）
    if (_selectedPeriod == '分时') {
      return _buildIntradayLineChart();
    }

    // 计算价格范围
    final prices = _candlestickSpots.map((e) => [e.high, e.low]).expand((e) => e).toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final priceRange = maxPrice - minPrice;
    
    // 确保价格范围不为0
    final actualPriceRange = priceRange > 0 ? priceRange : 10.0;
    final padding = actualPriceRange * 0.1; // 10% padding

    return CandlestickChart(
      CandlestickChartData(
        candlestickSpots: _candlestickSpots,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: actualPriceRange / 5, // 5条水平线，确保不为0
          verticalInterval: 2, // 每2个点一条垂直线
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: ProjectColors.manatee.withOpacity(0.2),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: ProjectColors.manatee.withOpacity(0.2),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 4,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value.toInt() % 4 == 0) {
                  return Text(
                    '${value.toInt()}',
                    style: TextStyle(
                      color: ProjectColors.manatee,
                      fontSize: 10,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: actualPriceRange / 4,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(1),
                  style: TextStyle(
                    color: ProjectColors.manatee,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: ProjectColors.manatee.withOpacity(0.2),
            width: 1,
          ),
        ),
        minX: 0,
        maxX: _candlestickSpots.length.toDouble() - 1,
        minY: minPrice - padding,
        maxY: maxPrice + padding,
          candlestickPainter: DefaultCandlestickPainter(),
      ),
    );
  }

  // 分时线图：蓝/白价格线 + 黄均价线
  Widget _buildIntradayLineChart() {
    // 仅使用收盘价作为每分钟价格
    final priceSpots = _candlestickSpots
        .map((e) => FlSpot(e.x, e.close))
        .toList(growable: false);

    // 简单均价（逐点累计均值）
    final List<FlSpot> avgSpots = [];
    double sum = 0;
    for (int i = 0; i < _candlestickSpots.length; i++) {
      sum += _candlestickSpots[i].close;
      final avg = sum / (i + 1);
      avgSpots.add(FlSpot(i.toDouble(), avg));
    }

    final closes = _candlestickSpots.map((e) => e.close).toList();
    final minPrice = closes.reduce((a, b) => a < b ? a : b);
    final maxPrice = closes.reduce((a, b) => a > b ? a : b);
    final range = (maxPrice - minPrice).abs();
    final padding = (range > 0 ? range : 10.0) * 0.1;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: _candlestickSpots.length.toDouble() - 1,
        minY: minPrice - padding,
        maxY: maxPrice + padding,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) => FlLine(
            color: ProjectColors.manatee.withOpacity(0.2),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: ProjectColors.manatee.withOpacity(0.2),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 30, // 每30分钟一标
              reservedSize: 24,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(color: ProjectColors.manatee, fontSize: 10),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (range > 0 ? range : 10.0) / 4,
              reservedSize: 36,
              getTitlesWidget: (value, meta) => Text(
                value.toStringAsFixed(2),
                style: TextStyle(color: ProjectColors.manatee, fontSize: 10),
              ),
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: ProjectColors.manatee.withOpacity(0.2),
            width: 1,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: priceSpots,
            isCurved: true,
            color: ProjectColors.white,
            barWidth: 2,
            dotData: FlDotData(show: false),
          ),
          LineChartBarData(
            spots: avgSpots,
            isCurved: true,
            color: Colors.yellow,
            barWidth: 1,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart,
            color: ProjectColors.manatee,
            size: 48,
          ),
          SizedBox(height: 16),
          Text(
            '暂无K线数据',
            style: TextStyle(
              color: ProjectColors.manatee,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '请稍后重试',
            style: TextStyle(
              color: ProjectColors.manatee,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}