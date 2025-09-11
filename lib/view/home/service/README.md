# 资产数据源架构

本项目为不同的资产类别（外汇、股票、商品）创建了独立的数据源，便于扩展和维护。

## 架构设计

### 1. 数据模型 (Models)
- `forex.dart` - 外汇数据模型  
- `stock.dart` - 股票数据模型
- `commodity.dart` - 商品数据模型

### 2. 数据源接口 (Data Source Interfaces)
- `IForexDataSource` - 外汇数据源接口
- `IStockDataSource` - 股票数据源接口
- `ICommodityDataSource` - 商品数据源接口

### 3. 数据源实现 (Data Source Implementations)
- `ForexDataSourceWithDio` - 外汇数据源实现 (模拟数据)
- `StockDataSourceWithDio` - 股票数据源实现 (模拟数据)
- `TushareStockDataSource` - Tushare股票数据源实现 (真实A股数据)
- `CommodityDataSourceWithDio` - 商品数据源实现 (模拟数据)

### 4. 状态管理 (State Management)
- `ForexCubit` / `ForexState` - 外汇状态管理
- `StockCubit` / `StockState` - 股票状态管理
- `CommodityCubit` / `CommodityState` - 商品状态管理

### 5. 统一管理器
- `AssetDataManager` - 统一管理所有资产类别的数据源

## 使用方法

### 1. 依赖注入配置
```dart
// 在 GetItSource.setup() 中注册所有数据源
GetItSource.setup();
```

### 2. 使用特定数据源
```dart
// 获取外汇数据
final forexCubit = ForexCubit(forexDataSource: GetItSource.getIt<ForexDataSourceWithDio>());
await forexCubit.fetchForexData();

// 获取股票数据
final stockCubit = StockCubit(stockDataSource: GetItSource.getIt<StockDataSourceWithDio>());
await stockCubit.fetchStockData();
```

### 3. 使用统一管理器
```dart
final assetManager = AssetDataManager(
  forexDataSource: GetItSource.getIt<ForexDataSourceWithDio>(),
  stockDataSource: GetItSource.getIt<StockDataSourceWithDio>(),
  commodityDataSource: GetItSource.getIt<CommodityDataSourceWithDio>(),
);

// 获取所有外汇资产
final forexAssets = await assetManager.getAllAssetsByCategory(AssetCategory.forex);

// 获取所有资产
final allAssets = await assetManager.getAllAssets();

// 使用Tushare获取真实A股数据
final tushareStocks = await assetManager.getTushareStocks();
final sseStocks = await assetManager.getTushareStocksByExchange('SSE');
```

## 扩展指南

### 添加新的资产类别
1. 创建新的数据模型
2. 创建数据源接口
3. 实现数据源
4. 创建Cubit和State
5. 在GetItSource中注册
6. 在AssetDataManager中添加支持

### 添加新的API端点
1. 在对应的数据源实现中添加新方法
2. 在接口中声明新方法
3. 在Repository中添加对应方法
4. 在Cubit中添加新的状态管理方法

## 数据源特点

- **独立性**: 每个资产类别都有独立的数据源，互不影响
- **可扩展性**: 易于添加新的资产类别或API端点
- **统一性**: 通过AssetDataManager提供统一的访问接口
- **类型安全**: 使用强类型模型确保数据安全
- **状态管理**: 完整的BLoC状态管理支持

## Tushare股票数据源

### 配置要求
1. 注册Tushare账号: https://tushare.pro/
2. 获取API Token
3. 在 `service_keys.dart` 中配置Token

### 支持的功能
- **股票基本信息**: 代码、名称、行业、地区、上市日期等
- **实时行情**: 价格、涨跌幅、成交量、成交额等
- **技术指标**: 市盈率、市净率、换手率等
- **交易所筛选**: 支持上交所(SSE)、深交所(SZSE)、北交所(BSE)

### 数据字段
- 基础信息: ts_code, symbol, name, area, industry, market
- 行情数据: close, pct_chg, change, volume, amount
- 技术指标: pe, pb, turnover, total_share, float_share
- 价格信息: open, high, low, pre_close

### 使用示例
```dart
// 直接使用Tushare数据源
final tushareDataSource = TushareStockDataSource(dio: Dio());
final stocks = await tushareDataSource.fetchData();

// 通过AssetDataManager使用
final assetManager = AssetDataManager(...);
final tushareAssets = await assetManager.getTushareStocks();
```
