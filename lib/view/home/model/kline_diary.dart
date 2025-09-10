import 'package:flutter/material.dart';

/// K线日记数据模型
class KlineDiary {
  final String id;
  final String symbol;
  final String category;
  final DateTime timestamp;
  final double price;
  final String content;
  final Color markerColor;
  final DateTime createdAt;
  final DateTime updatedAt;

  KlineDiary({
    required this.id,
    required this.symbol,
    required this.category,
    required this.timestamp,
    required this.price,
    required this.content,
    this.markerColor = const Color(0xFF388EFF),
    required this.createdAt,
    required this.updatedAt,
  });

  /// 从JSON创建对象
  factory KlineDiary.fromJson(Map<String, dynamic> json) {
    return KlineDiary(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      category: json['category'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      price: (json['price'] as num).toDouble(),
      content: json['content'] as String,
      markerColor: Color(json['markerColor'] as int),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'category': category,
      'timestamp': timestamp.toIso8601String(),
      'price': price,
      'content': content,
      'markerColor': markerColor.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// 复制并修改
  KlineDiary copyWith({
    String? id,
    String? symbol,
    String? category,
    DateTime? timestamp,
    double? price,
    String? content,
    Color? markerColor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return KlineDiary(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      category: category ?? this.category,
      timestamp: timestamp ?? this.timestamp,
      price: price ?? this.price,
      content: content ?? this.content,
      markerColor: markerColor ?? this.markerColor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'KlineDiary(id: $id, symbol: $symbol, timestamp: $timestamp, price: $price, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KlineDiary && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// 日记标记位置信息
class DiaryMarkerPosition {
  final double x;
  final double y;
  final DateTime timestamp;
  final double price;

  DiaryMarkerPosition({
    required this.x,
    required this.y,
    required this.timestamp,
    required this.price,
  });
}
