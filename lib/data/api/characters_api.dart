import '../../constants/end_points.dart';
import '../../constants/strings.dart';
import 'package:dio/dio.dart';

class CharactersApi {
  Dio? dio;
  CharactersApi() {
    BaseOptions baseOptions = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: 20 * 1000, //20second ,
      receiveTimeout: 20 * 1000,
    );
    dio = Dio(baseOptions);
  }
  Future<List<dynamic>> getAllCharacters() async {
    try {
      Response response = await dio!.get(
        CHARACTER,
      );
      print(response.data.toString());
      return response.data;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getCharacterQoute(String charName) async {
    try {
      Response response = await dio!.get(
        QOUTE,
        queryParameters: {'author': charName},
      );
      print(response.data.toString());
      return response.data;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
