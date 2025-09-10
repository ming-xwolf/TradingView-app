import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradingview_app/core/enum/base_status.dart';
import 'package:tradingview_app/core/constants/color/color_constant.dart';
import 'package:tradingview_app/core/component/navigation/bottom_navigation_bar.dart';
import 'package:tradingview_app/core/component/app_bar/custom_app_bar.dart';
import 'package:tradingview_app/core/component/list/category_asset_list.dart';
import 'package:tradingview_app/view/home/model/asset_category.dart';
import 'package:tradingview_app/view/home/model/crypto.dart';
import 'package:tradingview_app/view/home/view/add_asset_page.dart';
import 'package:tradingview_app/view/home/view-model/cubit/crypto_cubit.dart';
import 'package:tradingview_app/view/home/view-model/cubit/crypto_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors.haiti,
      appBar: CustomAppBar(
        title: 'TradingView',
        actions: [
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
      body: BlocBuilder<CryptoCubit, CryptoState>(
        builder: (context, state) {
          switch (state.status) {
            case BaseStatus.initial:
              return const SizedBox.shrink();
            case BaseStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case BaseStatus.completed:
              return _buildAssetList(state as CryptoCompleted);
            case BaseStatus.error:
              return const Center(child: Text('加载失败'));
          }
        },
      ),
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

  Widget _buildAssetList(CryptoCompleted data) {
    // 将加密货币数据转换为AssetItem，只显示BTCUSD和其他两个
    final allCryptoAssets = data.response
        .map((crypto) => AssetItem.fromCrypto(crypto as Crypto))
        .toList();
    
    // 筛选出BTCUSD和其他两个加密货币
    final cryptoAssets = allCryptoAssets.where((asset) {
      final symbol = asset.symbol.toUpperCase();
      return symbol == 'BTC' || symbol == 'ETH' || symbol == 'BNB';
    }).toList();

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

    // 创建示例股票数据
    final stockAssets = [
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

    return SingleChildScrollView(
      child: Column(
        children: [
          CategoryAssetList(
            category: AssetCategory.forex,
            assets: forexAssets,
          ),
          CategoryAssetList(
            category: AssetCategory.crypto,
            assets: cryptoAssets,
          ),
          CategoryAssetList(
            category: AssetCategory.stock,
            assets: stockAssets,
          ),
          const AddAssetButton(),
        ],
      ),
    );
  }
}

