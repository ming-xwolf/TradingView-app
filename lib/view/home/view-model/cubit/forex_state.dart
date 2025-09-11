import 'package:tradingview_app/view/home/model/forex.dart';

abstract class ForexState {}

class ForexInitial extends ForexState {}

class ForexLoading extends ForexState {}

class ForexCompleted extends ForexState {
  final List<Forex> forexList;
  ForexCompleted(this.forexList);
}

class ForexError extends ForexState {
  final String? message;
  ForexError({this.message});
}
