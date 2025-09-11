import 'package:tradingview_app/view/home/model/stock.dart';

abstract class StockState {}

class StockInitial extends StockState {}

class StockLoading extends StockState {}

class StockCompleted extends StockState {
  final List<Stock> stockList;
  StockCompleted(this.stockList);
}

class StockError extends StockState {
  final String? message;
  StockError({this.message});
}
