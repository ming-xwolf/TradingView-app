# 添加商品对话框搜索功能修复

## 问题描述
在"添加商品"对话框中，用户无法搜索股票，只能看到硬编码的静态数据。

## 问题原因
1. **静态数据**: AddAssetPage只使用硬编码的静态数据
2. **缺少Tushare集成**: 没有集成Tushare数据源进行动态搜索
3. **搜索逻辑不完整**: 搜索功能只对静态数据进行过滤

## 修复内容

### 1. 集成Tushare数据源
```dart
// 添加Tushare数据源
late TushareStockDataSource _tushareDataSource;

@override
void initState() {
  super.initState();
  _tushareDataSource = TushareStockDataSource(dio: Dio());
  _loadInitialData();
}
```

### 2. 动态数据加载
```dart
Future<void> _loadInitialData() async {
  setState(() {
    _isLoading = true;
  });

  try {
    // 加载静态数据
    final staticAssets = _getStaticAssets();
    
    // 加载Tushare股票数据
    final tushareStocks = await _tushareDataSource.fetchData();
    final tushareAssets = tushareStocks.map((stock) => AssetItem.fromStock(stock)).toList();
    
    setState(() {
      _availableAssets = [...staticAssets, ...tushareAssets];
      _isLoading = false;
    });
  } catch (e) {
    // 错误处理，回退到静态数据
  }
}
```

### 3. 智能搜索功能
```dart
Future<void> _searchAssets(String query) async {
  if (_selectedCategory == AssetCategory.stock) {
    // 搜索股票 - 使用Tushare数据源
    final stocks = await _tushareDataSource.fetchData();
    final filteredStocks = stocks.where((stock) {
      final symbol = stock.symbol?.toLowerCase() ?? '';
      final name = stock.name?.toLowerCase() ?? '';
      final industry = stock.industry?.toLowerCase() ?? '';
      final queryLower = query.toLowerCase();
      
      return symbol.contains(queryLower) || 
             name.contains(queryLower) || 
             industry.contains(queryLower);
    }).toList();
    
    searchResults = filteredStocks.map((stock) => AssetItem.fromStock(stock)).toList();
  } else {
    // 搜索其他类别的资产 - 使用静态数据
  }
}
```

### 4. 改进的用户界面
- **加载状态**: 显示加载指示器
- **空状态**: 显示友好的空状态提示
- **搜索反馈**: 显示搜索关键词和结果数量
- **价格显示**: 显示涨跌幅和颜色编码

### 5. 分类切换优化
```dart
onSelected: (selected) {
  setState(() {
    _selectedCategory = category;
    _searchQuery = '';
    _searchController.clear();
  });
  _loadInitialData(); // 重新加载数据
},
```

## 功能特点

### 搜索能力
- ✅ **股票代码搜索**: 支持搜索如"000001"、"600036"等
- ✅ **股票名称搜索**: 支持搜索如"平安银行"、"招商银行"等
- ✅ **行业搜索**: 支持搜索如"银行"、"房地产"等
- ✅ **实时搜索**: 输入时实时显示搜索结果

### 数据源
- ✅ **Tushare数据**: 真实的A股市场数据（带模拟数据回退）
- ✅ **静态数据**: 外汇、加密货币等静态数据
- ✅ **智能回退**: API限制时自动使用模拟数据

### 用户体验
- ✅ **加载状态**: 搜索时显示加载指示器
- ✅ **空状态**: 无结果时显示友好提示
- ✅ **分类切换**: 切换分类时自动重新加载数据
- ✅ **价格显示**: 显示当前价格和涨跌幅

## 测试方法

### 1. 启动应用
- 应用已在iPhone 16 Pro模拟器上运行

### 2. 测试股票搜索
1. 点击右上角"+"按钮进入添加商品页面
2. 选择"股票"分类
3. 在搜索框中输入：
   - "000001" - 搜索平安银行
   - "银行" - 搜索银行行业股票
   - "平安" - 搜索包含"平安"的股票

### 3. 测试其他分类
1. 选择"外汇"分类 - 搜索"EUR"
2. 选择"加密货币"分类 - 搜索"BTC"
3. 选择"商品"分类 - 搜索商品

## 技术实现

### 数据流
```
用户输入 → _searchAssets() → TushareStockDataSource → 过滤结果 → UI更新
```

### 错误处理
- API调用失败时回退到模拟数据
- 网络错误时显示友好提示
- 搜索无结果时显示空状态

### 性能优化
- 只在股票分类时调用Tushare API
- 其他分类使用本地静态数据
- 搜索结果缓存避免重复请求

## 结果

现在"添加商品"对话框支持：
- ✅ 动态搜索股票（使用Tushare数据源）
- ✅ 搜索外汇、加密货币、商品
- ✅ 实时搜索反馈
- ✅ 友好的用户界面
- ✅ 智能错误处理

用户现在可以正常搜索和添加各种类型的资产到自选列表中！
