import 'package:leptisapp/data/models/leptis/weather.dart';
import 'dart:async';
import 'package:leptisapp/utils/http_utils.dart';
import 'package:logging/logging.dart';

class WeatherApi {
  final Logger log = new Logger('WeatherApi');

  static const String openWeatherApiKey = "ef7da61cd2b19e17d3df33cc7e2af07f";

  Future<Weather> getWeather(String zipCode) async {
    log.fine("WeatherApi.getWeather - Start");

    String response = await getRequest(Uri.parse(Endpoints.WEATHER).replace(
      queryParameters: <String, String>{'zip': '$zipCode,ES', 'units': 'metric', 'APPID': openWeatherApiKey}
    ));
    return Weather.parse(response);
  }

  Future<List<Weather>> getWeatherForecast(String zipCode) async {
    log.fine("WeatherApi.getWeatherForecast - Start");

    log.finest("WeatherApi.getWeatherForecast - weatherUrl=${Uri.parse(Endpoints.FORECAST).toString()}");

    String response = await getRequest(Uri.parse(Endpoints.FORECAST).replace(
      queryParameters: <String, String>{'zip': '$zipCode,ES', 'units': 'metric', 'APPID': openWeatherApiKey}
    ));
    return Weather.parseForecast(response);
  }
}

class Endpoints {
  static const _ENDPOINT = "http://api.openweathermap.org/data/2.5";
  static const WEATHER = _ENDPOINT + "/weather";
  static const FORECAST = _ENDPOINT + "/forecast";
}