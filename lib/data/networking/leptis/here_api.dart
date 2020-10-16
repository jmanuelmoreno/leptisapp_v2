import 'package:leptisapp/data/models/leptis/weather.dart';
import 'package:leptisapp/here_config.dart';
import 'dart:async';
import 'package:leptisapp/utils/http_utils.dart';
import 'package:logging/logging.dart';

class HereApi {

  static Future<List<Weather>> getWeatherForecast(String cityname) async {
    Logger('HereApi').fine("HereApi.getWeatherForecast - Start");

    //print("HereApi.getWeatherForecast - HEREConfig.weatherUrl: ${HEREConfig.weatherUrl}");
    String response = await getRequest(Uri.parse(HEREConfig.weatherUrl).replace(
      queryParameters: <String, String>{
        'app_id': HEREConfig.appId,
        'app_code': HEREConfig.appCode,
        'language': 'spanish',
        'product': 'forecast_7days_simple',
        'name': cityname
      }
    ));
    List<Weather> weathers = Weather.parseHereWeather(response);
    return weathers;
  }

}