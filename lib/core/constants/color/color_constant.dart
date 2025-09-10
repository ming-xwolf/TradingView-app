import 'package:flutter/material.dart';

class ProjectColors {
  factory ProjectColors() {
    return _projectColors;
  }

  ProjectColors._internal();
  static final ProjectColors _projectColors = ProjectColors._internal();

  // TradingView 深色主题颜色
  // 主背景色 - 深黑色
  static Color get haiti => const Color.fromRGBO(12, 13, 18, 1);
  // 次背景色 - 深灰色
  static Color get haitiDark => const Color.fromRGBO(20, 23, 30, 1);
  // 选中项颜色 - 蓝色
  static Color get pictonBlue => const Color.fromRGBO(56, 142, 255, 1);
  // 未选中项颜色 - 灰色
  static Color get manatee => const Color.fromRGBO(131, 135, 150, 1);
  // 浅灰色
  static Color get manateeLight => const Color.fromRGBO(131, 135, 150, 0.7);
  // 文本颜色
  static Color get spoonBearl => const Color.fromRGBO(187, 190, 200, 1);
  // 白色
  static Color get white => const Color.fromRGBO(255, 255, 255, 1);
  // 黄色 - 用于图标
  static Color get dolly => const Color.fromRGBO(255, 193, 7, 1);
  // 按钮背景色
  static Color get marinique => const Color.fromRGBO(30, 35, 45, 1);
  // 下跌价格 - 红色
  static Color get cabaret => const Color.fromRGBO(255, 82, 82, 1);
  // 上涨价格 - 绿色
  static Color get jungleGreen => const Color.fromRGBO(76, 175, 80, 1);
  // 边框颜色
  static Color get borderColor => const Color.fromRGBO(40, 44, 52, 1);
  // 卡片背景色
  static Color get cardBackground => const Color.fromRGBO(25, 28, 35, 1);
}
