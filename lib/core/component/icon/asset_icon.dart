import 'package:flutter/material.dart';
import 'package:tradingview_app/core/constants/color/color_constant.dart';
import 'package:tradingview_app/view/home/model/asset_category.dart';

class AssetIcon extends StatelessWidget {
  const AssetIcon({
    required this.asset,
    super.key,
  });

  final AssetItem asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getIconBackgroundColor(),
      ),
      child: asset.iconUrl.isNotEmpty
          ? ClipOval(
              child: Image.network(
                asset.iconUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildDefaultIcon(),
              ),
            )
          : _buildDefaultIcon(),
    );
  }

  Widget _buildDefaultIcon() {
    switch (asset.category) {
      case AssetCategory.forex:
        return _buildForexIcon();
      case AssetCategory.stock:
        return _buildStockIcon();
      case AssetCategory.commodity:
        return _buildCommodityIcon();
    }
  }

  Widget _buildForexIcon() {
    // 根据货币对创建组合图标
    if (asset.symbol.contains('EUR')) {
      return _buildFlagIcon(Colors.blue, Icons.star, Colors.yellow);
    } else if (asset.symbol.contains('GBP')) {
      return _buildFlagIcon(Colors.red, Icons.flag, Colors.white);
    } else if (asset.symbol.contains('JPY')) {
      return _buildFlagIcon(Colors.white, Icons.circle, Colors.red);
    } else if (asset.symbol.contains('CNY')) {
      return _buildFlagIcon(Colors.red, Icons.star, Colors.yellow);
    } else if (asset.symbol.contains('USD')) {
      return _buildFlagIcon(Colors.blue, Icons.star, Colors.white);
    }
    return Icon(
      Icons.currency_exchange,
      color: Colors.white,
      size: 20,
    );
  }


  Widget _buildStockIcon() {
    return Icon(
      Icons.trending_up,
      color: ProjectColors.dolly,
      size: 20,
    );
  }

  Widget _buildCommodityIcon() {
    return Icon(
      Icons.inventory,
      color: ProjectColors.jungleGreen,
      size: 20,
    );
  }

  Widget _buildFlagIcon(Color backgroundColor, IconData icon, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 20,
      ),
    );
  }

  Color _getIconBackgroundColor() {
    switch (asset.category) {
      case AssetCategory.forex:
        return ProjectColors.pictonBlue;
      case AssetCategory.stock:
        return ProjectColors.dolly;
      case AssetCategory.commodity:
        return ProjectColors.jungleGreen;
    }
  }
}

