import 'package:flutter/material.dart';
import 'package:tradingview_app/view/home/model/kline_diary.dart';

/// K线图日记标记组件
class KlineDiaryMarkers extends StatelessWidget {
  final List<KlineDiary> diaries;
  final double chartWidth;
  final double chartHeight;
  final double minPrice;
  final double maxPrice;
  final DateTime startTime;
  final DateTime endTime;
  final Function(KlineDiary)? onMarkerTap;

  const KlineDiaryMarkers({
    required this.diaries,
    required this.chartWidth,
    required this.chartHeight,
    required this.minPrice,
    required this.maxPrice,
    required this.startTime,
    required this.endTime,
    this.onMarkerTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(chartWidth, chartHeight),
      painter: DiaryMarkersPainter(
        diaries: diaries,
        minPrice: minPrice,
        maxPrice: maxPrice,
        startTime: startTime,
        endTime: endTime,
        onMarkerTap: onMarkerTap,
      ),
    );
  }
}

/// 日记标记绘制器
class DiaryMarkersPainter extends CustomPainter {
  final List<KlineDiary> diaries;
  final double minPrice;
  final double maxPrice;
  final DateTime startTime;
  final DateTime endTime;
  final Function(KlineDiary)? onMarkerTap;

  DiaryMarkersPainter({
    required this.diaries,
    required this.minPrice,
    required this.maxPrice,
    required this.startTime,
    required this.endTime,
    this.onMarkerTap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    for (final diary in diaries) {
      final position = _calculateMarkerPosition(diary, size);
      if (position != null) {
        _drawMarker(canvas, position, diary, paint);
      }
    }
  }

  DiaryMarkerPosition? _calculateMarkerPosition(KlineDiary diary, Size size) {
    // 计算时间在图表中的X位置
    final timeRange = endTime.difference(startTime).inMilliseconds;
    final diaryTimeOffset = diary.timestamp.difference(startTime).inMilliseconds;
    
    if (diaryTimeOffset < 0 || diaryTimeOffset > timeRange) {
      return null; // 日记时间不在当前显示范围内
    }
    
    final x = (diaryTimeOffset / timeRange) * size.width;
    
    // 将标记放在图表中间位置，不依赖价格
    final y = size.height * 0.5;
    
    return DiaryMarkerPosition(
      x: x,
      y: y,
      timestamp: diary.timestamp,
    );
  }

  void _drawMarker(Canvas canvas, DiaryMarkerPosition position, KlineDiary diary, Paint paint) {
    // 绘制标记点 - 放在K线上方
    final markerY = position.y - 15; // 向上偏移15像素
    
    // 绘制外圈
    paint.color = Colors.white.withOpacity(0.9);
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(position.x, markerY),
      8,
      paint,
    );
    
    // 绘制内圈
    paint.color = diary.markerColor;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(position.x, markerY),
      6,
      paint,
    );
    
    // 绘制中心点
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(position.x, markerY),
      2,
      paint,
    );
    
    // 绘制连接线到K线
    paint.color = diary.markerColor.withOpacity(0.7);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    canvas.drawLine(
      Offset(position.x, markerY + 8),
      Offset(position.x, position.y),
      paint,
    );
    
    // 绘制小三角形指示器
    _drawTriangle(canvas, Offset(position.x, markerY + 8), diary.markerColor);
  }

  void _drawTriangle(Canvas canvas, Offset position, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(position.dx - 4, position.dy);
    path.lineTo(position.dx + 4, position.dy);
    path.lineTo(position.dx, position.dy + 6);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is DiaryMarkersPainter &&
        (oldDelegate.diaries != diaries ||
         oldDelegate.minPrice != minPrice ||
         oldDelegate.maxPrice != maxPrice ||
         oldDelegate.startTime != startTime ||
         oldDelegate.endTime != endTime);
  }
}

/// 可交互的日记标记覆盖层
class InteractiveDiaryMarkers extends StatefulWidget {
  final List<KlineDiary> diaries;
  final double chartWidth;
  final double chartHeight;
  final double minPrice;
  final double maxPrice;
  final DateTime startTime;
  final DateTime endTime;
  final Function(KlineDiary)? onMarkerTap;

  const InteractiveDiaryMarkers({
    required this.diaries,
    required this.chartWidth,
    required this.chartHeight,
    required this.minPrice,
    required this.maxPrice,
    required this.startTime,
    required this.endTime,
    this.onMarkerTap,
    super.key,
  });

  @override
  State<InteractiveDiaryMarkers> createState() => _InteractiveDiaryMarkersState();
}

class _InteractiveDiaryMarkersState extends State<InteractiveDiaryMarkers> {
  KlineDiary? _hoveredDiary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      child: Stack(
        children: [
          KlineDiaryMarkers(
            diaries: widget.diaries,
            chartWidth: widget.chartWidth,
            chartHeight: widget.chartHeight,
            minPrice: widget.minPrice,
            maxPrice: widget.maxPrice,
            startTime: widget.startTime,
            endTime: widget.endTime,
            onMarkerTap: widget.onMarkerTap,
          ),
          // 为每个日记标记添加独立的点击区域
          ...widget.diaries.map((diary) => _buildMarkerClickArea(diary)),
          if (_hoveredDiary != null)
            _buildTooltip(_hoveredDiary!),
        ],
      ),
    );
  }

  Widget _buildMarkerClickArea(KlineDiary diary) {
    final markerPosition = _calculateMarkerPosition(diary);
    if (markerPosition == null) return const SizedBox.shrink();
    
    final markerY = markerPosition.y - 15;
    
    return Positioned(
      left: markerPosition.x - 25,
      top: markerY - 25,
      child: GestureDetector(
        onTap: () {
          print('点击了日记标记: ${diary.id}');
          widget.onMarkerTap?.call(diary);
        },
        child: Container(
          width: 50,
          height: 50,
          color: Colors.transparent,
          child: const Center(
            child: SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    // 这个可以用于其他交互，比如显示提示
  }

  KlineDiary? _findDiaryAtPosition(Offset position) {
    for (final diary in widget.diaries) {
      final markerPosition = _calculateMarkerPosition(diary);
      if (markerPosition != null) {
        // 标记在K线上方15像素，所以点击区域也要相应调整
        final markerY = markerPosition.y - 15;
        final markerOffset = Offset(markerPosition.x, markerY);
        final distance = (position - markerOffset).distance;
        if (distance <= 25) { // 25像素的点击区域，更容易点击
          return diary;
        }
      }
    }
    return null;
  }

  DiaryMarkerPosition? _calculateMarkerPosition(KlineDiary diary) {
    final timeRange = widget.endTime.difference(widget.startTime).inMilliseconds;
    final diaryTimeOffset = diary.timestamp.difference(widget.startTime).inMilliseconds;
    
    if (diaryTimeOffset < 0 || diaryTimeOffset > timeRange) {
      return null;
    }
    
    final x = (diaryTimeOffset / timeRange) * widget.chartWidth;
    // 将标记放在图表中间位置，不依赖价格
    final y = widget.chartHeight * 0.5;
    
    return DiaryMarkerPosition(
      x: x,
      y: y,
      timestamp: diary.timestamp,
    );
  }

  Widget _buildTooltip(KlineDiary diary) {
    return Positioned(
      left: 10,
      top: 10,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: diary.markerColor,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${diary.symbol} • ${_formatTimestamp(diary.timestamp)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              diary.content,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.month}/${timestamp.day} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
