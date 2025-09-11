import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:tradingview_app/core/constants/color/color_constant.dart';
import 'package:tradingview_app/core/component/icon/asset_icon.dart';
import 'package:tradingview_app/view/home/model/asset_category.dart';
import 'package:tradingview_app/view/home/service/stock/stock_data_source_selector.dart';
import 'package:tradingview_app/view/home/service/asset_data_manager.dart';
import 'package:tradingview_app/view/home/widget/datasource_selector_dialog.dart';

class AddAssetPage extends StatefulWidget {
  const AddAssetPage({super.key});

  @override
  State<AddAssetPage> createState() => _AddAssetPageState();
}

class _AddAssetPageState extends State<AddAssetPage> {
  final TextEditingController _searchController = TextEditingController();
  AssetCategory _selectedCategory = AssetCategory.forex;
  String _searchQuery = '';
  List<AssetItem> _availableAssets = [];
  bool _isLoading = false;
  late StockDataSourceSelector _stockDataSource;

  @override
  void initState() {
    super.initState();
    _stockDataSource = GetIt.instance<StockDataSourceSelector>();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 加载静态数据（外汇、加密货币等）
      final staticAssets = _getStaticAssets();
      
      // 如果是股票分类，加载股票数据（优先使用akshare）
      if (_selectedCategory == AssetCategory.stock) {
        final stocks = await _stockDataSource.fetchData();
        final stockAssets = stocks.map((stock) => AssetItem.fromStock(stock)).toList();
        
        setState(() {
          _availableAssets = stockAssets;
          _isLoading = false;
        });
      } else {
        // 其他分类使用静态数据
        setState(() {
          _availableAssets = staticAssets;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('加载数据失败: $e');
      setState(() {
        if (_selectedCategory == AssetCategory.stock) {
          // 股票数据加载失败，显示空列表
          _availableAssets = [];
        } else {
          // 其他分类使用静态数据
          _availableAssets = _getStaticAssets();
        }
        _isLoading = false;
      });
      
      // 显示错误提示
      if (mounted && _selectedCategory == AssetCategory.stock) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('股票数据加载失败: ${e.toString().split(':').last}'),
            backgroundColor: ProjectColors.cabaret,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showDataSourceSelector() {
    showDialog(
      context: context,
      builder: (context) => DataSourceSelectorDialog(
        stockDataSourceSelector: _stockDataSource,
        onDataSourceChanged: () {
          // 数据源切换后重新加载股票数据
          if (_selectedCategory == AssetCategory.stock) {
            _loadInitialData();
          }
        },
      ),
    );
  }

  List<AssetItem> _getStaticAssets() {
    return [
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
    ];
  }

  Future<void> _searchAssets(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchQuery = query;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _searchQuery = query;
    });

    try {
      List<AssetItem> searchResults = [];
      
      if (_selectedCategory == AssetCategory.stock) {
        // 搜索股票 - 使用数据源选择器（优先akshare）
        List<AssetItem> stockResults = [];
        
        // 首先尝试直接按股票代码搜索
        if (RegExp(r'^\d{6}$').hasMatch(query)) {
          print('Searching for stock code: $query');
          try {
            final stock = await _stockDataSource.fetchStockBySymbol(query);
            if (stock != null) {
              stockResults = [AssetItem.fromStock(stock)];
              print('Found stock by code: ${stock.name} (${stock.symbol})');
            }
          } catch (e) {
            print('Direct stock code search failed: $e');
          }
        }
        
        // 如果直接搜索没有结果，尝试从股票列表中搜索
        if (stockResults.isEmpty) {
          try {
            final stocks = await _stockDataSource.fetchData();
            final filteredStocks = stocks.where((stock) {
              final symbol = stock.symbol?.toLowerCase() ?? '';
              final name = stock.name?.toLowerCase() ?? '';
              final industry = stock.industry?.toLowerCase() ?? '';
              final queryLower = query.toLowerCase();
              
              return symbol.contains(queryLower) || 
                     name.contains(queryLower) || 
                     industry.contains(queryLower);
            }).toList();
            
            stockResults = filteredStocks.map((stock) => AssetItem.fromStock(stock)).toList();
            print('Found ${stockResults.length} stocks from list search');
          } catch (e) {
            print('Stock list search failed: $e');
          }
        }
        
        searchResults = stockResults;
      } else {
        // 搜索其他类别的资产
        final filteredAssets = _availableAssets.where((asset) {
          final matchesCategory = asset.category == _selectedCategory;
          final matchesSearch = asset.name.toLowerCase().contains(query.toLowerCase()) ||
                               asset.subtitle.toLowerCase().contains(query.toLowerCase());
          return matchesCategory && matchesSearch;
        }).toList();
        
        searchResults = filteredAssets;
      }
      
      setState(() {
        _availableAssets = searchResults;
        _isLoading = false;
      });
    } catch (e) {
      print('股票搜索失败: $e');
      // 对于股票搜索失败，显示空结果而不是错误
      setState(() {
        _availableAssets = [];
        _isLoading = false;
      });
      
      // 显示错误提示
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('股票数据获取失败: ${e.toString().split(':').last}'),
            backgroundColor: ProjectColors.cabaret,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<AssetItem> filteredAssets;
    
    if (_searchQuery.isNotEmpty) {
      // 如果正在搜索，显示搜索结果
      filteredAssets = _availableAssets.where((asset) {
        return asset.category == _selectedCategory;
      }).toList();
    } else {
      // 如果没有搜索，显示所有匹配类别的资产
      filteredAssets = _availableAssets.where((asset) {
        return asset.category == _selectedCategory;
      }).toList();
    }

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
        actions: [
          // 只在股票分类时显示数据源选择按钮
          if (_selectedCategory == AssetCategory.stock)
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () => _showDataSourceSelector(),
              tooltip: '选择数据源',
            ),
        ],
      ),
      body: Column(
        children: [
          // 搜索框
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _searchAssets(value);
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
                        _searchQuery = '';
                        _searchController.clear();
                      });
                      _loadInitialData();
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
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: ProjectColors.pictonBlue,
                    ),
                  )
                : filteredAssets.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: ProjectColors.manatee,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? '暂无${_selectedCategory.displayName}数据'
                                  : '未找到匹配的${_selectedCategory.displayName}',
                              style: TextStyle(
                                color: ProjectColors.manatee,
                                fontSize: 16,
                              ),
                            ),
                            if (_searchQuery.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                '搜索关键词: $_searchQuery',
                                style: TextStyle(
                                  color: ProjectColors.manateeLight,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      )
                    : ListView.builder(
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
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _formatPrice(asset.currentPrice),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${asset.changePercent >= 0 ? '+' : ''}${asset.changePercent.toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    color: asset.isPositive
                                        ? ProjectColors.jungleGreen
                                        : ProjectColors.cabaret,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
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

