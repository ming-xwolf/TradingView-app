import 'package:flutter/material.dart';
import 'package:tradingview_app/core/constants/color/color_constant.dart';
import 'package:tradingview_app/core/component/icon/asset_icon.dart';
import 'package:tradingview_app/view/home/model/asset_category.dart';
import 'package:tradingview_app/view/home/model/crypto.dart';

class AddAssetPage extends StatefulWidget {
  const AddAssetPage({super.key});

  @override
  State<AddAssetPage> createState() => _AddAssetPageState();
}

class _AddAssetPageState extends State<AddAssetPage> {
  final TextEditingController _searchController = TextEditingController();
  AssetCategory _selectedCategory = AssetCategory.forex;
  String _searchQuery = '';

  final List<AssetItem> _availableAssets = [
    // 外汇
    AssetItem.forex(
      symbol: 'EURUSD',
      name: 'EURUSD',
      subtitle: '欧元/美元',
      currentPrice: 1.1693,
      change: -0.00142,
      changePercent: -0.12,
      iconUrl: '',
    ),
    AssetItem.forex(
      symbol: 'GBPUSD',
      name: 'GBPUSD',
      subtitle: '英镑/美元',
      currentPrice: 1.3518,
      change: -0.00076,
      changePercent: -0.06,
      iconUrl: '',
    ),
    AssetItem.forex(
      symbol: 'USDJPY',
      name: 'USDJPY',
      subtitle: '美元/日元',
      currentPrice: 147.45,
      change: 0.048,
      changePercent: 0.03,
      iconUrl: '',
    ),
    AssetItem.forex(
      symbol: 'USDCNY',
      name: 'USDCNY',
      subtitle: '美元/人民币',
      currentPrice: 7.1287,
      change: 0.0083,
      changePercent: 0.12,
      iconUrl: '',
    ),
    // 加密货币
    AssetItem.fromCrypto(Crypto(
      id: 'bitcoin',
      name: 'Bitcoin',
      symbol: 'BTC',
      image: 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
      quote: Quote(
        uSD: USD(
          price: 111012,
          percentChange24h: -0.47,
        ),
      ),
    )),
    AssetItem.fromCrypto(Crypto(
      id: 'ethereum',
      name: 'Ethereum',
      symbol: 'ETH',
      image: 'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
      quote: Quote(
        uSD: USD(
          price: 4308.9,
          percentChange24h: -0.03,
        ),
      ),
    )),
    // 股票
    AssetItem.stock(
      symbol: '000661',
      name: '000661 D',
      subtitle: '长春高新',
      currentPrice: 124.33,
      change: -3.16,
      changePercent: -2.48,
      iconUrl: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredAssets = _availableAssets.where((asset) {
      final matchesCategory = asset.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          asset.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          asset.subtitle.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: ProjectColors.haiti,
      appBar: AppBar(
        backgroundColor: ProjectColors.haitiDark,
        title: const Text(
          '添加商品',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 搜索框
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '搜索商品...',
                hintStyle: TextStyle(color: ProjectColors.manatee),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: ProjectColors.haitiDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // 分类选择
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AssetCategory.values.length,
              itemBuilder: (context, index) {
                final category = AssetCategory.values[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      category.displayName,
                      style: TextStyle(
                        color: isSelected ? Colors.white : ProjectColors.manatee,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: ProjectColors.haitiDark,
                    selectedColor: ProjectColors.pictonBlue,
                    checkmarkColor: Colors.white,
                  ),
                );
              },
            ),
          ),
          // 资产列表
          Expanded(
            child: ListView.builder(
              itemCount: filteredAssets.length,
              itemBuilder: (context, index) {
                final asset = filteredAssets[index];
                return ListTile(
                  leading: AssetIcon(asset: asset),
                  title: Text(
                    asset.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    asset.subtitle,
                    style: TextStyle(color: ProjectColors.manatee),
                  ),
                  trailing: Text(
                    _formatPrice(asset.currentPrice),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    // TODO: 添加到自选列表
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('已添加 ${asset.name} 到自选列表'),
                        backgroundColor: ProjectColors.jungleGreen,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

