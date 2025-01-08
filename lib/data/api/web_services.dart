import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:scorehub/constants/strings.dart';
import 'package:scorehub/data/models/matches_of_day.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebServices {
  late WebSocketChannel webSocketChannel;
  final Dio dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    headers: {
      "X-RapidAPI-Key": apiKey,
      "X-RapidAPI-Host": xRapidapiHost,
    },
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
  ));
  WebServices() {
    SetUpInceptors();
  }
  void SetUpInceptors() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 429) {
          int retryAfter = int.tryParse(
                  error.response?.headers.value('Retry-After') ?? '1') ??
              1;
          await Future.delayed(Duration(seconds: retryAfter));
          try {
            final response = await dio.request(
              error.requestOptions.path,
              options: Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers),
              queryParameters: error.requestOptions.queryParameters,
              data: error.requestOptions.data,
            );
            return handler.resolve(response);
          } catch (e) {
            return handler.reject(e as DioException);
          }
        }
      },
    ));
  }

  Future<List<dynamic>> getFixtures(String date) async {
    try {
      var response = await dio.get("/fixtures", queryParameters: {
        "date": date,
      });

      if (response.statusCode == 200) {
        print(response.data);

        return response.data["response"];
      } else {
        print("حدث خطأ: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("حدث خطأ: $e");
      return [];
    }
  }

  Future<List<dynamic>> getStatisticTeams(int idTeam, int idFixture) async {
    try {
      var response = await dio.get("/fixtures/statistics", queryParameters: {
        "team": idTeam,
        "fixture": idFixture,
      });

      if (response.statusCode == 200) {
        print(response.data["response"]);
        return response.data["response"];
      } else {
        print("حدث خطأ في تفاصيل الماتش: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("حدث خطأ في تفاصيل الماتش: $e");
      return [];
    }
  }

  Future<List<dynamic>> getLineUps(
    int idFixture,
  ) async {
    try {
      var response = await dio.get("fixtures/lineups", queryParameters: {
        "fixture": idFixture,
      });
      if (response.statusCode == 200) {
        print(response.data);
        return response.data["response"];
      } else {
        return [];
      }
    } catch (e) {
      print("Error in Line Up: $e");
      return [];
    }
  }

  Future<List<dynamic>> getStandings(int season, int idLeague) async {
    try {
      var response = await dio.get("/standings", queryParameters: {
        'league': idLeague,
        'season': season,
      });
      if (response.statusCode == 200) {
        print(response.data);
        return response.data["response"];
      } else {
        print(response.statusCode);
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
