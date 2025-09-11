import 'package:flutter/material.dart';
import 'package:tradingview_app/view/tradingview/view/trading_page.dart';

class RoutingWithCore {
  factory RoutingWithCore() {
    return _routingWithCore;
  }
  RoutingWithCore._internal();
  static final RoutingWithCore _routingWithCore = RoutingWithCore._internal();

  static MaterialPageRoute<TradingPage> goTradingPage() {
    return MaterialPageRoute<TradingPage>(
      builder: (context) {
        return const TradingPage();
      },
    );
  }
}
