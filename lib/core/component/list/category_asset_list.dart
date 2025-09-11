import 'package:flutter/material.dart';
import 'package:tradingview_app/core/constants/color/color_constant.dart';
import 'package:tradingview_app/core/component/card/asset_card.dart';
import 'package:tradingview_app/view/home/model/asset_category.dart';
import 'package:tradingview_app/view/home/view/add_asset_page.dart';
import 'package:tradingview_app/view/home/service/watchlist_service.dart';

class CategoryAssetList extends StatelessWidget {
  const CategoryAssetList({
    required this.category,
    required this.assets,
    this.onRemoveAsset,
    super.key,
  });

  final AssetCategory category;
  final List<AssetItem> assets;
  final Function(AssetItem)? onRemoveAsset;

  @override
  Widget build(BuildContext context) {
    if (assets.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 分类标题
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            category.displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // 资产列表
        ...assets.map((asset) => AssetCard(
          asset: asset,
          onRemove: onRemoveAsset != null ? () => onRemoveAsset!(asset) : null,
        )),
        const SizedBox(height: 8),
      ],
    );
  }
}

class AddAssetButton extends StatelessWidget {
  const AddAssetButton({this.onAssetAdded, super.key});
  
  final VoidCallback? onAssetAdded;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAssetPage(
                onAssetAdded: onAssetAdded,
              ),
            ),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          '添加商品',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: ProjectColors.pictonBlue,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
