import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradingview_app/view/home/model/kline_diary.dart';

/// 日记服务 - 管理K线日记的存储和检索
class DiaryService {
  static const String _diaryKey = 'kline_diaries';
  static DiaryService? _instance;
  
  DiaryService._();
  
  static DiaryService get instance {
    _instance ??= DiaryService._();
    return _instance!;
  }

  /// 获取所有日记
  Future<List<KlineDiary>> getAllDiaries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final diariesJson = prefs.getStringList(_diaryKey) ?? [];
      
      return diariesJson
          .map((json) => KlineDiary.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      print('获取日记列表失败: $e');
      return [];
    }
  }

  /// 根据资产获取日记
  Future<List<KlineDiary>> getDiariesByAsset(String symbol, String category) async {
    final allDiaries = await getAllDiaries();
    return allDiaries
        .where((diary) => diary.symbol == symbol && diary.category == category)
        .toList();
  }

  /// 保存日记
  Future<bool> saveDiary(KlineDiary diary) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allDiaries = await getAllDiaries();
      
      // 检查是否已存在相同ID的日记
      final existingIndex = allDiaries.indexWhere((d) => d.id == diary.id);
      
      if (existingIndex >= 0) {
        // 更新现有日记
        allDiaries[existingIndex] = diary;
      } else {
        // 添加新日记
        allDiaries.add(diary);
      }
      
      // 按时间戳排序
      allDiaries.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      
      // 保存到本地存储
      final diariesJson = allDiaries
          .map((diary) => jsonEncode(diary.toJson()))
          .toList();
      
      return await prefs.setStringList(_diaryKey, diariesJson);
    } catch (e) {
      print('保存日记失败: $e');
      return false;
    }
  }

  /// 删除日记
  Future<bool> deleteDiary(String diaryId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allDiaries = await getAllDiaries();
      
      allDiaries.removeWhere((diary) => diary.id == diaryId);
      
      final diariesJson = allDiaries
          .map((diary) => jsonEncode(diary.toJson()))
          .toList();
      
      return await prefs.setStringList(_diaryKey, diariesJson);
    } catch (e) {
      print('删除日记失败: $e');
      return false;
    }
  }

  /// 清空指定资产的所有日记
  Future<bool> clearDiariesByAsset(String symbol, String category) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allDiaries = await getAllDiaries();
      
      allDiaries.removeWhere((diary) => 
          diary.symbol == symbol && diary.category == category);
      
      final diariesJson = allDiaries
          .map((diary) => jsonEncode(diary.toJson()))
          .toList();
      
      return await prefs.setStringList(_diaryKey, diariesJson);
    } catch (e) {
      print('清空资产日记失败: $e');
      return false;
    }
  }

  /// 生成唯一ID
  String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           (DateTime.now().microsecond % 1000).toString().padLeft(3, '0');
  }
}
