abstract class IIconNetwork {
  String getIconToNetwork(String id);
}

class IconNetwork implements IIconNetwork {
  @override
  String getIconToNetwork(String id) {
    // CoinGecko 直接返回图像 URL，在模型里已有 image，可退化为使用 CoinGecko 静态资源
    // 但为兼容原有结构，这里组装一个 CoinGecko 图标地址（第三方镜像，常见可用）
    return 'https://assets.coingecko.com/coins/images/1/large/$id.png?ref=app';
  }
}
