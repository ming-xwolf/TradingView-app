import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradingview_app/view/home/service/commodity/icommodity_data_source.dart';
import 'package:tradingview_app/view/home/view-model/cubit/commodity_state.dart';

class CommodityCubit extends Cubit<CommodityState> {
  CommodityCubit({required this.commodityDataSource}) : super(CommodityInitial());
  final ICommodityDataSource commodityDataSource;

  Future<void> fetchCommodityData() async {
    try {
      emit(CommodityLoading());
      final response = await commodityDataSource.fetchData();
      emit(CommodityCompleted(response));
    } catch (e) {
      emit(CommodityError(message: e.toString()));
    }
  }

  Future<void> fetchCommodityBySymbol(String symbol) async {
    try {
      emit(CommodityLoading());
      final response = await commodityDataSource.fetchCommodityBySymbol(symbol);
      if (response != null) {
        emit(CommodityCompleted([response]));
      } else {
        emit(CommodityError(message: 'Commodity not found'));
      }
    } catch (e) {
      emit(CommodityError(message: e.toString()));
    }
  }

  Future<void> fetchCommoditiesByCategory(String category) async {
    try {
      emit(CommodityLoading());
      final response = await commodityDataSource.fetchCommoditiesByCategory(category);
      emit(CommodityCompleted(response));
    } catch (e) {
      emit(CommodityError(message: e.toString()));
    }
  }
}
