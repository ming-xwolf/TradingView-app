import 'package:dio/dio.dart';
import 'package:tradingview_app/view/_product/service/api_constants.dart';
import 'package:tradingview_app/view/home/model/crypto.dart';
import 'package:tradingview_app/view/home/service/crypto/icrypto_data_source.dart';

class CryptoDataSourceWithDio extends ICryptoDataSource {
  CryptoDataSourceWithDio({required this.dio}) {
    url = ApiConstants.url;
    header = ApiConstants.header;
  }

  late String url;
  late Map<String, String> header;
  final Dio dio;

  @override
  Future<List<Crypto>> fetchData() async {
    // CoinGecko 直接返回数组而非 { data: [...] }
    final response = await dio.get<List<dynamic>>(url, options: Options(headers: header));
    final jsonList = response.data ?? <dynamic>[];
    return jsonList.map((e) => Crypto.fromJson(e as Map<String, dynamic>)).toList();
  }
}
