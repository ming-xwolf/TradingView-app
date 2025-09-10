import 'package:flutter/material.dart';
import 'package:tradingview_app/core/constants/color/color_constant.dart';
import 'package:tradingview_app/view/home/model/kline_diary.dart';

/// 日记输入弹窗
class DiaryInputDialog extends StatefulWidget {
  final String symbol;
  final String category;
  final DateTime timestamp;
  final DateTime klineTime; // K线时间
  final KlineDiary? existingDiary; // 编辑现有日记时传入

  const DiaryInputDialog({
    required this.symbol,
    required this.category,
    required this.timestamp,
    required this.klineTime,
    this.existingDiary,
    super.key,
  });

  @override
  State<DiaryInputDialog> createState() => _DiaryInputDialogState();
}

class _DiaryInputDialogState extends State<DiaryInputDialog> {
  late TextEditingController _contentController;
  late Color _selectedColor;
  final List<Color> _availableColors = [
    const Color(0xFF388EFF), // 蓝色
    const Color(0xFF4CAF50), // 绿色
    const Color(0xFFFF9800), // 橙色
    const Color(0xFFE91E63), // 粉色
    const Color(0xFF9C27B0), // 紫色
    const Color(0xFFF44336), // 红色
    const Color(0xFF00BCD4), // 青色
    const Color(0xFFFFC107), // 黄色
  ];

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.existingDiary?.content ?? '',
    );
    _selectedColor = widget.existingDiary?.markerColor ?? _availableColors[0];
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ProjectColors.haiti,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            _buildHeader(),
            const SizedBox(height: 20),
            
            // 价格和时间信息
            _buildPriceInfo(),
            const SizedBox(height: 20),
            
            // 内容输入
            _buildContentInput(),
            const SizedBox(height: 20),
            
            // 颜色选择
            _buildColorSelector(),
            const SizedBox(height: 24),
            
            // 按钮
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.edit_note,
          color: ProjectColors.pictonBlue,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          widget.existingDiary != null ? '编辑日记' : '添加日记',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.close,
            color: ProjectColors.manatee,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ProjectColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ProjectColors.borderColor,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.candlestick_chart,
            color: ProjectColors.pictonBlue,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '${widget.symbol} • ${_formatTimestamp(widget.klineTime)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            _formatDateTime(widget.timestamp),
            style: TextStyle(
              color: ProjectColors.manatee,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '记录你的想法',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: ProjectColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: ProjectColors.borderColor,
              width: 0.5,
            ),
          ),
          child: TextField(
            controller: _contentController,
            maxLines: 4,
            maxLength: 500,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            decoration: const InputDecoration(
              hintText: '记录你对这根K线的观察和想法...',
              hintStyle: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
              counterStyle: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '标记颜色',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableColors.map((color) {
            final isSelected = _selectedColor == color;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = color;
                });
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        if (widget.existingDiary != null) ...[
          Expanded(
            child: TextButton(
              onPressed: _deleteDiary,
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('删除'),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              backgroundColor: ProjectColors.haitiDark,
              foregroundColor: ProjectColors.manatee,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('取消'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _saveDiary,
            style: ElevatedButton.styleFrom(
              backgroundColor: ProjectColors.pictonBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(widget.existingDiary != null ? '更新' : '保存'),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _saveDiary() {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入日记内容'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final diary = widget.existingDiary?.copyWith(
      content: content,
      markerColor: _selectedColor,
      updatedAt: DateTime.now(),
    ) ?? KlineDiary(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      symbol: widget.symbol,
      category: widget.category,
      timestamp: widget.timestamp,
      klineTime: widget.klineTime,
      content: content,
      markerColor: _selectedColor,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.of(context).pop(diary);
  }

  void _deleteDiary() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ProjectColors.haiti,
        title: const Text(
          '删除日记',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '确定要删除这条日记吗？',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop('delete');
            },
            child: const Text(
              '删除',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.month}/${timestamp.day} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
