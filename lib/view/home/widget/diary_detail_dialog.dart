import 'package:flutter/material.dart';
import 'package:tradingview_app/core/constants/color/color_constant.dart';
import 'package:tradingview_app/view/home/model/kline_diary.dart';

/// 日记详情弹窗 - 显示和编辑日记内容
class DiaryDetailDialog extends StatefulWidget {
  final KlineDiary diary;

  const DiaryDetailDialog({
    required this.diary,
    super.key,
  });

  @override
  State<DiaryDetailDialog> createState() => _DiaryDetailDialogState();
}

class _DiaryDetailDialogState extends State<DiaryDetailDialog> {
  late TextEditingController _contentController;
  late Color _selectedColor;
  bool _isEditing = false;
  
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
    _contentController = TextEditingController(text: widget.diary.content);
    _selectedColor = widget.diary.markerColor;
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
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 头部
            _buildHeader(),
            
            // 内容区域
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 资产信息
                      _buildAssetInfo(),
                      const SizedBox(height: 20),
                      
                      // 时间信息
                      _buildTimeInfo(),
                      const SizedBox(height: 20),
                      
                      // 价格信息
                      _buildPriceInfo(),
                      const SizedBox(height: 20),
                      
                      // 日记内容
                      _buildContentSection(),
                      const SizedBox(height: 20),
                      
                      // 颜色选择（编辑模式）
                      if (_isEditing) ...[
                        _buildColorSelector(),
                        const SizedBox(height: 20),
                      ],
                      
                      // 创建/更新时间
                      _buildTimestampInfo(),
                    ],
                  ),
                ),
              ),
            ),
            
            // 底部按钮
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ProjectColors.haitiDark,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: widget.diary.markerColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit_note,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '日记详情',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${widget.diary.symbol} • ${widget.diary.category}',
                  style: TextStyle(
                    color: ProjectColors.manatee,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.close,
              color: ProjectColors.manatee,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProjectColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ProjectColors.borderColor,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: widget.diary.markerColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                widget.diary.symbol.substring(0, 2).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.diary.symbol,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.diary.category,
                  style: TextStyle(
                    color: ProjectColors.manatee,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProjectColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ProjectColors.borderColor,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            color: ProjectColors.pictonBlue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '记录时间',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDateTime(widget.diary.timestamp),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProjectColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ProjectColors.borderColor,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.trending_up,
            color: ProjectColors.pictonBlue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '记录价格',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.diary.price.toStringAsFixed(2),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '日记内容',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (!_isEditing)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('编辑'),
                style: TextButton.styleFrom(
                  foregroundColor: ProjectColors.pictonBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: ProjectColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ProjectColors.borderColor,
              width: 0.5,
            ),
          ),
          child: TextField(
            controller: _contentController,
            enabled: _isEditing,
            maxLines: 6,
            maxLength: 500,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: '记录你对这根K线的观察和想法...',
              hintStyle: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterStyle: const TextStyle(
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
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _availableColors.map((color) {
            final isSelected = _selectedColor == color;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = color;
                });
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimestampInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ProjectColors.haitiDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: ProjectColors.manatee,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '创建于 ${_formatDateTime(widget.diary.createdAt)} • 更新于 ${_formatDateTime(widget.diary.updatedAt)}',
              style: TextStyle(
                color: ProjectColors.manatee,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ProjectColors.haitiDark,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          // 删除按钮
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
          
          // 取消按钮（编辑模式）
          if (_isEditing) ...[
            Expanded(
              child: TextButton(
                onPressed: _cancelEdit,
                style: TextButton.styleFrom(
                  backgroundColor: ProjectColors.haitiDark,
                  foregroundColor: ProjectColors.manatee,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('取消'),
              ),
            ),
            const SizedBox(width: 12),
          ],
          
          // 保存/编辑按钮
          Expanded(
            child: ElevatedButton(
              onPressed: _isEditing ? _saveChanges : _startEdit,
              style: ElevatedButton.styleFrom(
                backgroundColor: ProjectColors.pictonBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(_isEditing ? '保存' : '编辑'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
           '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _startEdit() {
    setState(() {
      _isEditing = true;
    });
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _contentController.text = widget.diary.content;
      _selectedColor = widget.diary.markerColor;
    });
  }

  void _saveChanges() {
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

    final updatedDiary = widget.diary.copyWith(
      content: content,
      markerColor: _selectedColor,
      updatedAt: DateTime.now(),
    );

    Navigator.of(context).pop(updatedDiary);
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
          '确定要删除这条日记吗？删除后无法恢复。',
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
}
