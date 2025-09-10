import 'package:flutter/material.dart';
import 'package:tradingview_app/core/service/tradingview_html_service.dart';
import 'package:tradingview_app/core/service/diary_service.dart';
import 'package:tradingview_app/view/home/model/kline_diary.dart';
import 'package:tradingview_app/view/home/widget/diary_input_dialog.dart';
import 'package:tradingview_app/view/home/widget/diary_detail_dialog.dart';
import 'package:tradingview_app/view/home/widget/kline_diary_markers.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 增强版TradingView图表组件 - 支持日记标记功能
class EnhancedTradingViewChartWidget extends StatefulWidget {
  final String symbol;
  final String timeframe;
  final String category;
  final double height;
  final String theme;
  final bool enableDiaryMarkers;

  const EnhancedTradingViewChartWidget({
    required this.symbol,
    required this.timeframe,
    required this.category,
    this.height = 200,
    this.theme = 'dark',
    this.enableDiaryMarkers = true,
    super.key,
  });

  @override
  State<EnhancedTradingViewChartWidget> createState() => _EnhancedTradingViewChartWidgetState();
}

class _EnhancedTradingViewChartWidgetState extends State<EnhancedTradingViewChartWidget> {
  WebViewController? controller;
  bool _isLoading = true;
  List<KlineDiary> _diaries = [];
  bool _isLoadingDiaries = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    _loadDiaries();
  }

  void _initializeWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..enableZoom(false)
      ..loadHtmlString(_generateChartHtml());
  }

  String _generateChartHtml() {
    final tradingViewSymbol = TradingViewHtmlService.getSymbolForAsset(
      widget.symbol,
      widget.category,
    );
    
    return TradingViewHtmlService.generateChartHtml(
      symbol: tradingViewSymbol,
      timeframe: widget.timeframe,
      theme: widget.theme,
    );
  }

  Future<void> _loadDiaries() async {
    if (!widget.enableDiaryMarkers) return;
    
    setState(() {
      _isLoadingDiaries = true;
    });

    try {
      final diaries = await DiaryService.instance.getDiariesByAsset(
        widget.symbol,
        widget.category,
      );
      
      setState(() {
        _diaries = diaries;
        _isLoadingDiaries = false;
      });
    } catch (e) {
      print('加载日记失败: $e');
      setState(() {
        _isLoadingDiaries = false;
      });
    }
  }

  @override
  void didUpdateWidget(EnhancedTradingViewChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.symbol != widget.symbol || 
        oldWidget.timeframe != widget.timeframe ||
        oldWidget.category != widget.category) {
      _initializeWebView();
      _loadDiaries();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return Container(
        height: widget.height,
        color: const Color(0xFF0C0D12),
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF388EFF),
            strokeWidth: 2,
          ),
        ),
      );
    }
    
    return Container(
      height: widget.height,
      child: Stack(
        children: [
          // TradingView图表
          WebViewWidget(controller: controller!),
          
          // 日记标记覆盖层
          if (widget.enableDiaryMarkers && !_isLoadingDiaries)
            _buildDiaryMarkersOverlay(),
          
          // 加载指示器
          if (_isLoading)
            Container(
              height: widget.height,
              color: const Color(0xFF0C0D12),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF388EFF),
                  strokeWidth: 2,
                ),
              ),
            ),
          
          // 长按检测层 - 放在最上层，但使用translucent行为
          if (widget.enableDiaryMarkers)
            _buildLongPressDetector(),
        ],
      ),
    );
  }

  Widget _buildDiaryMarkersOverlay() {
    // 根据时间间隔和资产类型计算时间范围
    final now = DateTime.now();
    final timeRange = _getTimeRangeForTimeframe();
    final startTime = now.subtract(timeRange);
    final endTime = now;
    
    // 根据资产类型计算价格范围
    final priceRange = _getPriceRangeForAsset();
    
    return Stack(
      children: [
        // 只添加可点击的标记区域，不重复绘制
        ..._diaries.map((diary) => _buildClickableMarker(diary, startTime, endTime, priceRange['min']!, priceRange['max']!)),
      ],
    );
  }

  Widget _buildClickableMarker(KlineDiary diary, DateTime startTime, DateTime endTime, double minPrice, double maxPrice) {
    // 计算标记位置
    final timeRange = endTime.difference(startTime).inMilliseconds;
    final diaryTimeOffset = diary.timestamp.difference(startTime).inMilliseconds;
    
    if (diaryTimeOffset < 0 || diaryTimeOffset > timeRange) {
      return const SizedBox.shrink();
    }
    
    final screenWidth = MediaQuery.of(context).size.width;
    final x = (diaryTimeOffset / timeRange) * screenWidth;
    
    final priceRange = maxPrice - minPrice;
    final priceOffset = diary.price - minPrice;
    final y = widget.height - (priceOffset / priceRange) * widget.height;
    
    return Positioned(
      left: x - 30,
      top: y - 45,
      child: GestureDetector(
        onTap: () {
          print('点击了日记标记: ${diary.id}');
          _onDiaryMarkerTap(diary);
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            children: [
              // 绘制完整的标记
              Positioned(
                left: 22,
                top: 15,
                child: _buildMarkerIcon(diary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarkerIcon(KlineDiary diary) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 标记点
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: diary.markerColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        // 连接线
        Container(
          width: 2,
          height: 15,
          color: diary.markerColor.withOpacity(0.7),
        ),
        // 小三角形指示器
        Container(
          width: 0,
          height: 0,
          decoration: BoxDecoration(
            border: Border(
              left: const BorderSide(color: Colors.transparent, width: 4),
              right: const BorderSide(color: Colors.transparent, width: 4),
              bottom: BorderSide(color: diary.markerColor, width: 6),
            ),
          ),
        ),
      ],
    );
  }

  /// 根据时间间隔获取时间范围
  Duration _getTimeRangeForTimeframe() {
    switch (widget.timeframe) {
      case '1m':
        return const Duration(hours: 1);
      case '30m':
        return const Duration(hours: 12);
      case '1h':
        return const Duration(days: 1);
      case 'D':
        return const Duration(days: 30);
      case 'W':
        return const Duration(days: 180);
      case 'M':
        return const Duration(days: 365);
      default:
        return const Duration(days: 1);
    }
  }

  /// 根据资产类型获取价格范围
  Map<String, double> _getPriceRangeForAsset() {
    switch (widget.category) {
      case 'crypto':
        if (widget.symbol.toUpperCase().contains('BTC')) {
          return {'min': 90000.0, 'max': 120000.0};
        } else if (widget.symbol.toUpperCase().contains('ETH')) {
          return {'min': 2500.0, 'max': 3500.0};
        } else {
          return {'min': 0.5, 'max': 1.5};
        }
      case 'stock':
        return {'min': 100.0, 'max': 200.0};
      case 'forex':
        return {'min': 0.8, 'max': 1.2};
      default:
        return {'min': 50.0, 'max': 150.0};
    }
  }

  Widget _buildLongPressDetector() {
    return Positioned.fill(
      child: GestureDetector(
        onLongPressStart: _onLongPressStart,
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }

  void _onLongPressStart(LongPressStartDetails details) {
    print('长按检测到: ${details.localPosition}');
    
    // 显示触觉反馈
    // HapticFeedback.mediumImpact();
    
    // 计算点击位置对应的时间和价格
    final timestamp = _calculateTimestampFromPosition(details.localPosition);
    final price = _calculatePriceFromPosition(details.localPosition);
    
    print('计算出的时间: $timestamp, 价格: $price');
    
    // 查找该位置是否已有日记记录
    final existingDiary = _findDiaryAtPosition(timestamp, price);
    
    if (existingDiary != null) {
      print('找到现有日记记录: ${existingDiary.id}');
      // 如果已有日记记录，显示详情供修改
      _showDiaryDetailDialog(existingDiary);
    } else {
      print('未找到现有日记记录，创建新的');
      // 如果没有日记记录，创建新的
      _showDiaryInputDialog(details.localPosition);
    }
  }

  /// 根据时间和价格查找现有的日记记录
  KlineDiary? _findDiaryAtPosition(DateTime timestamp, double price) {
    // 设置一个时间容差（±5分钟）和价格容差（±1%）
    final timeTolerance = const Duration(minutes: 5);
    final priceTolerance = price * 0.01; // 1%的价格容差
    
    for (final diary in _diaries) {
      final timeDiff = diary.timestamp.difference(timestamp).abs();
      final priceDiff = (diary.price - price).abs();
      
      if (timeDiff <= timeTolerance && priceDiff <= priceTolerance) {
        return diary;
      }
    }
    return null;
  }

  void _onDiaryMarkerTap(KlineDiary diary) {
    _showDiaryDetailDialog(diary);
  }

  void _showDiaryDetailDialog(KlineDiary diary) {
    print('显示日记详情弹窗: ${diary.id}');
    showDialog(
      context: context,
      builder: (context) => DiaryDetailDialog(diary: diary),
    ).then((result) {
      print('日记详情弹窗结果: $result');
      if (result != null) {
        if (result == 'delete') {
          _deleteDiary(diary);
        } else if (result is KlineDiary) {
          _saveDiary(result);
        }
      }
    });
  }

  void _showDiaryInputDialog(Offset? position, {KlineDiary? existingDiary}) {
    if (existingDiary != null) {
      // 编辑现有日记
      showDialog(
        context: context,
        builder: (context) => DiaryInputDialog(
          symbol: widget.symbol,
          category: widget.category,
          timestamp: existingDiary.timestamp,
          price: existingDiary.price,
          existingDiary: existingDiary,
        ),
      ).then((result) {
        if (result != null) {
          if (result == 'delete') {
            _deleteDiary(existingDiary);
          } else if (result is KlineDiary) {
            _saveDiary(result);
          }
        }
      });
    } else if (position != null) {
      // 添加新日记 - 根据点击位置计算时间和价格
      final timestamp = _calculateTimestampFromPosition(position);
      final price = _calculatePriceFromPosition(position);
      
      showDialog(
        context: context,
        builder: (context) => DiaryInputDialog(
          symbol: widget.symbol,
          category: widget.category,
          timestamp: timestamp,
          price: price,
          existingDiary: null,
        ),
      ).then((result) {
        if (result != null && result is KlineDiary) {
          _saveDiary(result);
        }
      });
    }
  }

  /// 根据点击位置计算对应的时间戳
  DateTime _calculateTimestampFromPosition(Offset position) {
    // 获取当前时间范围（根据时间间隔调整）
    final now = DateTime.now();
    Duration timeRange;
    
    switch (widget.timeframe) {
      case '1m':
        timeRange = const Duration(hours: 1); // 1分钟图显示1小时
        break;
      case '30m':
        timeRange = const Duration(hours: 12); // 30分钟图显示12小时
        break;
      case '1h':
        timeRange = const Duration(days: 1); // 1小时图显示1天
        break;
      case 'D':
        timeRange = const Duration(days: 30); // 日线图显示30天
        break;
      case 'W':
        timeRange = const Duration(days: 180); // 周线图显示6个月
        break;
      case 'M':
        timeRange = const Duration(days: 365); // 月线图显示1年
        break;
      default:
        timeRange = const Duration(days: 1);
    }
    
    final startTime = now.subtract(timeRange);
    final endTime = now;
    
    // 根据X坐标计算时间
    final screenWidth = MediaQuery.of(context).size.width;
    final xRatio = position.dx / screenWidth;
    final timeOffset = timeRange.inMilliseconds * xRatio;
    
    return startTime.add(Duration(milliseconds: timeOffset.round()));
  }

  /// 根据点击位置计算对应的价格
  double _calculatePriceFromPosition(Offset position) {
    final priceRange = _getPriceRangeForAsset();
    final minPrice = priceRange['min']!;
    final maxPrice = priceRange['max']!;
    
    // 根据Y坐标计算价格
    final screenHeight = widget.height;
    final yRatio = position.dy / screenHeight;
    
    // Y坐标越小，价格越高（图表是倒置的）
    final priceRangeValue = maxPrice - minPrice;
    final priceOffset = priceRangeValue * (1 - yRatio);
    return minPrice + priceOffset;
  }

  Future<void> _saveDiary(KlineDiary diary) async {
    try {
      final success = await DiaryService.instance.saveDiary(diary);
      if (success) {
        await _loadDiaries();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(diary.id == diary.id ? '日记已更新' : '日记已保存'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('保存失败，请重试'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('保存日记失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('保存失败，请重试'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteDiary(KlineDiary diary) async {
    try {
      final success = await DiaryService.instance.deleteDiary(diary.id);
      if (success) {
        await _loadDiaries();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('日记已删除'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('删除失败，请重试'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('删除日记失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('删除失败，请重试'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
