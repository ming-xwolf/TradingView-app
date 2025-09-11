# Akshare数据源集成

## 概述
为了解决Tushare API的频率限制问题，我们集成了akshare数据源作为股票数据的主要来源。akshare是一个免费的金融数据接口，没有频率限制，提供丰富的A股市场数据。

## 主要特性

### 1. 无频率限制
- ✅ 免费使用，无API调用次数限制
- ✅ 实时数据更新
- ✅ 支持大量并发请求

### 2. 数据来源
- **东方财富API**: 使用EastMoney的公开接口
- **数据质量**: 与Tushare数据质量相当
- **更新频率**: 实时更新

### 3. 支持的数据
- ✅ 股票基本信息（代码、名称、行业等）
- ✅ 实时行情（价格、涨跌幅、成交量等）
- ✅ 按交易所筛选（上交所、深交所）
- ✅ 按股票代码搜索

## 技术实现

### 1. AkshareStockDataSource类
```dart
class AkshareStockDataSource extends IStockDataSource {
  // 实现IStockDataSource接口
  Future<List<Stock>> fetchData()
  Future<Stock?> fetchStockBySymbol(String symbol)
  Future<List<Stock>> fetchStocksByExchange(String exchange)
}
```

### 2. 数据获取流程
```
用户搜索 → StockDataSourceSelector → AkshareStockDataSource → EastMoney API → 数据处理 → 返回结果
```

### 3. API接口
- **股票列表**: `https://push2.eastmoney.com/api/qt/clist/get`
- **实时行情**: `https://push2.eastmoney.com/api/qt/ulist.np`

## 数据源选择策略

### 1. 优先级顺序
1. **Akshare** (默认) - 无频率限制，稳定可靠
2. **Tushare** (备用) - 高质量数据，但有频率限制
3. **Mock数据** (最后备用) - 本地模拟数据

### 2. 自动回退机制
```dart
// 如果akshare失败，自动尝试tushare
if (defaultType == StockDataSourceType.akshare) {
  try {
    return await akshareDataSource.fetchData();
  } catch (e) {
    try {
      return await tushareDataSource.fetchData();
    } catch (e2) {
      return await mockDataSource.fetchData();
    }
  }
}
```

## 数据字段映射

### 股票基本信息
| Akshare字段 | 说明 | Stock模型字段 |
|------------|------|---------------|
| f12 | 股票代码 | symbol |
| f14 | 股票名称 | name |
| f15 | 行业 | industry |
| 地区判断 | 根据代码判断 | area |
| 市场判断 | 根据代码判断 | market |

### 实时行情
| Akshare字段 | 说明 | Stock模型字段 |
|------------|------|---------------|
| f2 | 最新价 | currentPrice |
| f3 | 涨跌幅 | changePercent |
| f4 | 涨跌额 | change |
| f5 | 成交量 | volume |
| f6 | 成交额 | amount |
| f9 | 市盈率 | pe |
| f23 | 市净率 | pb |

## 交易所识别

### 上交所 (SSE)
- 股票代码以6开头
- 包含主板和科创板

### 深交所 (SZSE)
- 股票代码以0开头（主板）
- 股票代码以3开头（创业板）
- 股票代码以2开头（中小板）

## 配置和使用

### 1. 依赖注入配置
```dart
// 注册akshare数据源
getIt.registerSingleton<AkshareStockDataSource>(AkshareStockDataSource(dio: dio));

// 注册数据源选择器，默认使用akshare
getIt.registerSingleton<StockDataSourceSelector>(
  StockDataSourceSelector(
    tushareDataSource: getIt<TushareStockDataSource>(),
    akshareDataSource: getIt<AkshareStockDataSource>(),
    mockDataSource: getIt<StockDataSourceWithDio>(),
    defaultType: StockDataSourceType.akshare,
  ),
);
```

### 2. 在AddAssetPage中使用
```dart
// 获取数据源选择器
_stockDataSource = GetIt.instance<StockDataSourceSelector>();

// 获取股票数据
final stocks = await _stockDataSource.fetchData();
```

## 优势对比

### Akshare vs Tushare
| 特性 | Akshare | Tushare |
|------|---------|---------|
| 频率限制 | ❌ 无限制 | ⚠️ 免费版每小时1次 |
| 数据质量 | ✅ 高质量 | ✅ 高质量 |
| 数据覆盖 | ✅ 全面 | ✅ 全面 |
| 稳定性 | ✅ 稳定 | ✅ 稳定 |
| 成本 | ✅ 免费 | ⚠️ 高级功能需付费 |

## 错误处理

### 1. 网络错误
- 自动重试机制
- 回退到备用数据源
- 用户友好的错误提示

### 2. 数据解析错误
- 字段验证和默认值
- 异常捕获和日志记录
- 优雅降级处理

### 3. API限制
- 虽然akshare无频率限制，但仍需处理其他可能的限制
- 实现请求间隔控制
- 错误重试策略

## 测试场景

### 1. 正常使用
- ✅ 搜索股票代码（如"000001"）
- ✅ 搜索股票名称（如"平安银行"）
- ✅ 搜索行业（如"银行"）
- ✅ 按交易所筛选

### 2. 错误处理
- ✅ 网络断开时的处理
- ✅ API返回错误时的处理
- ✅ 数据解析失败时的处理

### 3. 性能测试
- ✅ 大量数据加载
- ✅ 并发搜索请求
- ✅ 内存使用优化

## 未来扩展

### 1. 更多数据源
- 可以添加更多免费数据源
- 实现数据源负载均衡
- 数据质量评估机制

### 2. 缓存机制
- 实现本地数据缓存
- 减少API调用次数
- 提高响应速度

### 3. 数据同步
- 定期更新股票列表
- 增量数据更新
- 数据一致性保证

## 总结

akshare数据源的集成为应用提供了：
- ✅ **无限制的API调用** - 解决Tushare频率限制问题
- ✅ **高质量数据** - 与Tushare相当的数据质量
- ✅ **稳定可靠** - 多重备用机制确保服务可用性
- ✅ **易于维护** - 清晰的架构和错误处理

现在用户可以无限制地搜索和获取股票数据，享受流畅的股票搜索体验！
