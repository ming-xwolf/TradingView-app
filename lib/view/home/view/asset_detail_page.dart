import 'package:flutter/material.dart';
import 'package:tradingview_app/core/constants/color/color_constant.dart';
import 'package:tradingview_app/core/component/chart/tradingview_chart_widget.dart';
import 'package:tradingview_app/view/home/model/asset_category.dart';

class AssetDetailPage extends StatefulWidget {
  const AssetDetailPage({
    required this.asset,
    super.key,
  });

  final AssetItem asset;

  @override
  State<AssetDetailPage> createState() => _AssetDetailPageState();
}

class _AssetDetailPageState extends State<AssetDetailPage> {
  int _selectedTab = 0; // 默认选择概览
  String _selectedInterval = '1h'; // 默认选择1小时
  int _selectedChartType = 0; // 0: K线图, 1: 折线图

  final List<String> _intervals = ['1m', '30m', '1h', 'D'];

  final List<String> _tabs = [
    '概览', '新闻', '看法', '观点'
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: ProjectColors.haiti,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // 拖拽指示器
              _buildDragHandle(),
              // 资产信息头部
              _buildAssetHeader(),
            // 图表区域
            _buildChartSection(),
            // 交易按钮
            _buildTradeButton(),
            // 底部导航
            _buildBottomTabs(),
            // 内容区域
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: _buildContentArea(),
              ),
            ),
          ],
        ),
      );
    },
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: ProjectColors.manatee,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildAssetHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              // 资产图标
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getAssetColor(),
                ),
                child: Center(
                  child: Text(
                    _getAssetInitials(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 资产信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getAssetName(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.asset.symbol} • ${_getExchange()}',
                      style: TextStyle(
                        color: ProjectColors.manatee,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // 右侧图标
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: ProjectColors.jungleGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.business,
                    color: ProjectColors.pictonBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.share,
                    color: ProjectColors.manatee,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 价格信息
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatPrice(widget.asset.currentPrice),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${widget.asset.isPositive ? '+' : ''}${_formatChange(widget.asset.change)}',
                        style: TextStyle(
                          color: widget.asset.isPositive ? ProjectColors.jungleGreen : ProjectColors.cabaret,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.asset.isPositive ? '+' : ''}${widget.asset.changePercent.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: widget.asset.isPositive ? ProjectColors.jungleGreen : ProjectColors.cabaret,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '今天',
                        style: TextStyle(
                          color: ProjectColors.manatee,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      height: 350,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ProjectColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ProjectColors.borderColor,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          // 图表控制栏
          _buildChartControls(),
          // 图表区域
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              child: TradingViewChartWidget(
                symbol: widget.asset.symbol,
                timeframe: _selectedInterval,
                category: widget.asset.category.value,
                height: 300,
                theme: 'dark',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartControls() {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: ProjectColors.haitiDark,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 时间间隔选择
          Row(
            children: _intervals.map((interval) {
              final isSelected = _selectedInterval == interval;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildCompactTimeIntervalButton(interval, isSelected),
              );
            }).toList(),
          ),
          // 图表类型选择
          Row(
            children: [
              _buildCompactChartTypeButton(Icons.bar_chart, _selectedChartType == 0, 0),
              const SizedBox(width: 6),
              _buildCompactChartTypeButton(Icons.show_chart, _selectedChartType == 1, 1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTimeIntervalButton(String interval, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedInterval = interval;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected ? ProjectColors.pictonBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          interval,
          style: TextStyle(
            color: isSelected ? Colors.white : ProjectColors.manatee,
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleTimeIntervalButton(String interval, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedInterval = interval;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? ProjectColors.pictonBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          interval,
          style: TextStyle(
            color: isSelected ? Colors.white : ProjectColors.manatee,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeIntervalButton(String interval, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedInterval = interval;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? ProjectColors.pictonBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? ProjectColors.pictonBlue : ProjectColors.manatee,
            width: 1,
          ),
        ),
        child: Text(
          interval,
          style: TextStyle(
            color: isSelected ? Colors.white : ProjectColors.manatee,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCompactChartTypeButton(IconData icon, bool isSelected, int chartType) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedChartType = chartType;
        });
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: isSelected ? ProjectColors.pictonBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : ProjectColors.manatee,
          size: 12,
        ),
      ),
    );
  }

  Widget _buildSimpleChartTypeButton(IconData icon, bool isSelected, int chartType) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedChartType = chartType;
        });
      },
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isSelected ? ProjectColors.pictonBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : ProjectColors.manatee,
          size: 14,
        ),
      ),
    );
  }

  Widget _buildChartTypeButton(IconData icon, bool isSelected, int chartType) {
    return GestureDetector(
      onTap: () {
        if (chartType >= 0) {
          setState(() {
            _selectedChartType = chartType;
          });
        } else {
          // 处理其他功能按钮
          if (icon == Icons.add) {
            // TODO: 添加指标功能
          } else if (icon == Icons.fullscreen) {
            // TODO: 全屏功能
          }
        }
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? ProjectColors.pictonBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? ProjectColors.pictonBlue : ProjectColors.manatee,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : ProjectColors.manatee,
          size: 16,
        ),
      ),
    );
  }


  Widget _buildTradeButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: 实现交易功能
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          '交易',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == _selectedTab;
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = index;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? ProjectColors.pictonBlue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    tab,
                    style: TextStyle(
                      color: isSelected ? ProjectColors.pictonBlue : ProjectColors.manatee,
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContentArea() {
    return _buildTabContent();
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0: // 概览
        return _buildOverviewContent();
      case 1: // 新闻
        return _buildNewsContent();
      case 2: // 看法
        return _buildOpinionsContent();
      case 3: // 观点
        return _buildViewsContent();
      default:
        return _buildOverviewContent();
    }
  }

  Widget _buildOverviewContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 新闻卡片
          _buildNewsCard(),
          const SizedBox(height: 16),
          // 添加笔记卡片
          _buildAddNoteCard(),
          const SizedBox(height: 24),
          // 关键统计数据
          _buildKeyStatistics(),
        ],
      ),
    );
  }

  Widget _buildNewsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.purple.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.flash_on,
            color: Colors.purple,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '09:53 · 9月2日 · 《股市简讯》',
                  style: TextStyle(
                    color: ProjectColors.manatee,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '中国"酒王" 贵州茅台早盘涨2.2%,控股股东增持股份',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: ProjectColors.manatee,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildAddNoteCard() {
    return Container(
      padding: const EdgeInsets.all(16),
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
            Icons.edit,
            color: ProjectColors.manatee,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            '添加笔记到${widget.asset.symbol}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: ProjectColors.manatee,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildKeyStatistics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '关键统计数据',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _buildStatisticRow('成交量', '396.63 K'),
        _buildStatisticRow('市值', '1.88 T CNY'),
        _buildStatisticRow('股息收益率(指定)', '3.43%'),
        _buildStatisticRow('市盈率(TTM)', '20.96'),
        _buildStatisticRow('基本每股收益(TTM)', '71.63 CNY'),
        _buildStatisticRow('净收入(FY)', '86.23 B CNY'),
        _buildStatisticRow('收入(FY)', '147.22 B CNY'),
      ],
    );
  }

  Widget _buildStatisticRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: ProjectColors.manatee,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsContent() {
    return const Center(
      child: Text(
        '新闻内容',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildOpinionsContent() {
    return const Center(
      child: Text(
        '看法内容',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildViewsContent() {
    return const Center(
      child: Text(
        '观点内容',
        style: TextStyle(color: Colors.white),
      ),
    );
  }


  String _getAssetName() {
    switch (widget.asset.category) {
      case AssetCategory.stock:
        return 'Kweichow Moutai Co., Ltd.';
      case AssetCategory.crypto:
        return '${widget.asset.name} / 美元';
      case AssetCategory.forex:
        return '${widget.asset.name} / 美元';
      case AssetCategory.commodity:
        return widget.asset.name;
    }
  }

  String _getExchange() {
    switch (widget.asset.category) {
      case AssetCategory.stock:
        return 'SSE';
      case AssetCategory.crypto:
        return 'Crypto';
      case AssetCategory.forex:
        return 'Forex';
      case AssetCategory.commodity:
        return 'Commodity';
    }
  }

  Color _getAssetColor() {
    switch (widget.asset.category) {
      case AssetCategory.stock:
        return ProjectColors.dolly;
      case AssetCategory.crypto:
        return Colors.orange;
      case AssetCategory.forex:
        return ProjectColors.pictonBlue;
      case AssetCategory.commodity:
        return ProjectColors.jungleGreen;
    }
  }

  String _getAssetInitials() {
    switch (widget.asset.category) {
      case AssetCategory.stock:
        return 'MOUTAI';
      case AssetCategory.crypto:
        return widget.asset.symbol.substring(0, 2);
      case AssetCategory.forex:
        return widget.asset.symbol.substring(0, 3);
      case AssetCategory.commodity:
        return widget.asset.symbol.substring(0, 2);
    }
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(1)}K';
    }
    return price.toStringAsFixed(2);
  }

  String _formatChange(double change) {
    return change.abs().toStringAsFixed(2);
  }
}
