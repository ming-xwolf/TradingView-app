import 'package:tradingview_app/view/home/model/commodity.dart';

abstract class CommodityState {}

class CommodityInitial extends CommodityState {}

class CommodityLoading extends CommodityState {}

class CommodityCompleted extends CommodityState {
  final List<Commodity> commodityList;
  CommodityCompleted(this.commodityList);
}

class CommodityError extends CommodityState {
  final String? message;
  CommodityError({this.message});
}
