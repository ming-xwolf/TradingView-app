import 'package:flutter/material.dart';
import 'package:tradingview_app/core/constants/color/color_constant.dart';
import 'package:tradingview_app/core/component/navigation/bottom_navigation_bar.dart';
import 'package:tradingview_app/core/component/app_bar/custom_app_bar.dart';
import 'package:tradingview_app/core/component/list/category_asset_list.dart';
import 'package:tradingview_app/view/home/model/asset_category.dart';
import 'package:tradingview_app/view/home/view/add_asset_page.dart';
import 'package:tradingview_app/view/home/view/test_tushare_page.dart';
import 'package:tradingview_app/view/home/service/asset_data_manager.dart';
import 'package:tradingview_app/view/home/service/get-it/get_it_source.dart';
import 'package:tradingview_app/view/home/service/forex/forex_data_source_with_dio.dart';
import 'package:tradingview_app/view/home/service/stock/stock_data_source_selector.dart';
import 'package:tradingview_app/view/home/service/commodity/commodity_data_source_with_dio.dart';
import 'package:tradingview_app/view/home/service/watchlist_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  late AssetDataManager _assetDataManager;
  late WatchlistService _watchlistService;
  List<AssetItem> _stockAssets = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeDataManager();
    _loadStockData();
  }

  void _initializeDataManager() {
    // 初始化资产管理器
    _assetDataManager = AssetDataManager(
      forexDataSource: GetItSource.getIt.get<ForexDataSourceWithDio>(),
      stockDataSource: GetItSource.getIt.get<StockDataSourceSelector>(),
      commodityDataSource: GetItSource.getIt.get<CommodityDataSourceWithDio>(),
    );
    
    // 初始化自选列表服务
    _watchlistService = GetItSource.getIt.get<WatchlistService>();
  }

  Future<void> _loadStockData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 从自选列表获取股票数据
      final watchlist = await _watchlistService.getWatchlist();
      final stockAssets = watchlist.where((asset) => asset.category == AssetCategory.stock).toList();
      
      setState(() {
        _stockAssets = stockAssets;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading stock data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFromWatchlist(AssetItem asset) async {
    try {
      final success = await _watchlistService.removeFromWatchlist(asset);
      
      if (success) {
        // 重新加载数据
        await _loadStockData();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('已从自选列表删除 ${asset.name}'),
              backgroundColor: ProjectColors.jungleGreen,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('删除失败'),
              backgroundColor: ProjectColors.cabaret,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('删除失败: $e'),
            backgroundColor: ProjectColors.cabaret,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors.haiti,
      appBar: CustomAppBar(
        title: '投资日记',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TestTusharePage(),
                  ),
                );
              },
              child: const Icon(
                Icons.api,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddAssetPage(),
                  ),
                );
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: _buildAssetList(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildAssetList() {
    // 创建示例外汇数据
    final forexAssets = [
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
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          CategoryAssetList(
            category: AssetCategory.forex,
            assets: forexAssets,
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            )
          else
            CategoryAssetList(
              category: AssetCategory.stock,
              assets: _stockAssets,
              onRemoveAsset: _removeFromWatchlist,
            ),
          AddAssetButton(
            onAssetAdded: _loadStockData,
          ),
        ],
      ),
    );
  }
}

