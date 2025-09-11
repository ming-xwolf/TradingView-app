import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradingview_app/view/home/service/forex/iforex_data_source.dart';
import 'package:tradingview_app/view/home/view-model/cubit/forex_state.dart';

class ForexCubit extends Cubit<ForexState> {
  ForexCubit({required this.forexDataSource}) : super(ForexInitial());
  final IForexDataSource forexDataSource;

  Future<void> fetchForexData() async {
    try {
      emit(ForexLoading());
      final response = await forexDataSource.fetchData();
      emit(ForexCompleted(response));
    } catch (e) {
      emit(ForexError(message: e.toString()));
    }
  }

  Future<void> fetchForexBySymbol(String symbol) async {
    try {
      emit(ForexLoading());
      final response = await forexDataSource.fetchForexBySymbol(symbol);
      if (response != null) {
        emit(ForexCompleted([response]));
      } else {
        emit(ForexError(message: 'Forex not found'));
      }
    } catch (e) {
      emit(ForexError(message: e.toString()));
    }
  }
}
