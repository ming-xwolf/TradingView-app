import 'package:flutter/material.dart';
import 'package:tradingview_app/core/constants/color/color_constant.dart';
import 'package:tradingview_app/core/component/icon/asset_icon.dart';
import 'package:tradingview_app/view/home/model/asset_category.dart';
import 'package:tradingview_app/view/home/view/asset_detail_page.dart';

class AssetCard extends StatelessWidget {
  const AssetCard({
    required this.asset,
    this.onRemove,
    super.key,
  });

  final AssetItem asset;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => AssetDetailPage(asset: asset),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: ProjectColors.cardBackground,
          border: Border(
            bottom: BorderSide(
              color: ProjectColors.borderColor,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
        children: [
          // 图标
          _buildIcon(),
          const SizedBox(width: 12),
          // 资产信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  asset.subtitle,
                  style: TextStyle(
                    color: ProjectColors.manatee,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // 价格信息
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatPrice(asset.currentPrice),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${asset.isPositive ? '+' : ''}${_formatChange(asset.change)}',
                    style: TextStyle(
                      color: asset.isPositive ? ProjectColors.jungleGreen : ProjectColors.cabaret,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${asset.isPositive ? '+' : ''}${asset.changePercent.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: asset.isPositive ? ProjectColors.jungleGreen : ProjectColors.cabaret,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // 删除按钮
          if (onRemove != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _showDeleteDialog(context),
              child: Icon(
                Icons.delete_outline,
                color: ProjectColors.cabaret,
                size: 20,
              ),
            ),
          ],
        ],
      ),
      ),
    );
  }

  Widget _buildIcon() {
    return AssetIcon(asset: asset);
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      return price.toStringAsFixed(0);
    } else if (price >= 1) {
      return price.toStringAsFixed(2);
    } else {
      return price.toStringAsFixed(4);
    }
  }

  String _formatChange(double change) {
    return change.abs().toStringAsFixed(2);
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ProjectColors.cardBackground,
          title: const Text(
            '确认删除',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            '确定要从自选列表中删除 ${asset.name} 吗？',
            style: TextStyle(color: ProjectColors.manatee),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '取消',
                style: TextStyle(color: ProjectColors.manatee),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRemove?.call();
              },
              child: Text(
                '删除',
                style: TextStyle(color: ProjectColors.cabaret),
              ),
            ),
          ],
        );
      },
    );
  }
}
