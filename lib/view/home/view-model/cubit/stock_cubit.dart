import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradingview_app/view/home/service/stock/istock_data_source.dart';
import 'package:tradingview_app/view/home/view-model/cubit/stock_state.dart';

class StockCubit extends Cubit<StockState> {
  StockCubit({required this.stockDataSource}) : super(StockInitial());
  final IStockDataSource stockDataSource;

  Future<void> fetchStockData() async {
    try {
      emit(StockLoading());
      final response = await stockDataSource.fetchData();
      emit(StockCompleted(response));
    } catch (e) {
      emit(StockError(message: e.toString()));
    }
  }

  Future<void> fetchStockBySymbol(String symbol) async {
    try {
      emit(StockLoading());
      final response = await stockDataSource.fetchStockBySymbol(symbol);
      if (response != null) {
        emit(StockCompleted([response]));
      } else {
        emit(StockError(message: 'Stock not found'));
      }
    } catch (e) {
      emit(StockError(message: e.toString()));
    }
  }

  Future<void> fetchStocksByExchange(String exchange) async {
    try {
      emit(StockLoading());
      final response = await stockDataSource.fetchStocksByExchange(exchange);
      emit(StockCompleted(response));
    } catch (e) {
      emit(StockError(message: e.toString()));
    }
  }
}
