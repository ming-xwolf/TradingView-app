import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:tradingview_app/view/home/model/asset_category.dart';

/// 自选列表服务 - 管理用户添加的资产
class WatchlistService {
  static const String _watchlistKey = 'user_watchlist';
  
  /// 获取自选列表
  Future<List<AssetItem>> getWatchlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final watchlistJson = prefs.getString(_watchlistKey);
      
      if (watchlistJson == null) {
        return [];
      }
      
      final List<dynamic> watchlistData = json.decode(watchlistJson);
      return watchlistData.map((data) => AssetItem.fromJson(data)).toList();
    } catch (e) {
      print('Error loading watchlist: $e');
      return [];
    }
  }
  
  /// 添加资产到自选列表
  Future<bool> addToWatchlist(AssetItem asset) async {
    try {
      final watchlist = await getWatchlist();
      
      // 检查是否已存在
      if (watchlist.any((item) => item.symbol == asset.symbol && item.category == asset.category)) {
        return false; // 已存在
      }
      
      watchlist.add(asset);
      return await _saveWatchlist(watchlist);
    } catch (e) {
      print('Error adding to watchlist: $e');
      return false;
    }
  }
  
  /// 从自选列表移除资产
  Future<bool> removeFromWatchlist(AssetItem asset) async {
    try {
      final watchlist = await getWatchlist();
      watchlist.removeWhere((item) => 
        item.symbol == asset.symbol && item.category == asset.category);
      return await _saveWatchlist(watchlist);
    } catch (e) {
      print('Error removing from watchlist: $e');
      return false;
    }
  }
  
  /// 检查资产是否在自选列表中
  Future<bool> isInWatchlist(AssetItem asset) async {
    try {
      final watchlist = await getWatchlist();
      return watchlist.any((item) => 
        item.symbol == asset.symbol && item.category == asset.category);
    } catch (e) {
      print('Error checking watchlist: $e');
      return false;
    }
  }
  
  /// 保存自选列表
  Future<bool> _saveWatchlist(List<AssetItem> watchlist) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final watchlistJson = json.encode(watchlist.map((asset) => asset.toJson()).toList());
      return await prefs.setString(_watchlistKey, watchlistJson);
    } catch (e) {
      print('Error saving watchlist: $e');
      return false;
    }
  }
  
  /// 清空自选列表
  Future<bool> clearWatchlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_watchlistKey);
    } catch (e) {
      print('Error clearing watchlist: $e');
      return false;
    }
  }
}
