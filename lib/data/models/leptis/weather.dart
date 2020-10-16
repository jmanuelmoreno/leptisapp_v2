import 'dart:convert';

class Weather {
  Weather({
    this.day,
    this.temperature,
    this.condition,
  });

  final DateTime day;
  final double temperature;
  final Condition condition;


  static Weather parse(String jsonString) {
    print("Weather.parse - Start");
    //print("Weather.parse - jsonString=$jsonString");

    try {
      final JsonDecoder json = const JsonDecoder();
      var map = json.convert(jsonString);

      String description = map["weather"][0]["description"];
      int id = map["weather"][0]["id"];

      Condition condition = new Condition(id: "$id", description: description);
      double temperature = map["main"]["temp"].toDouble();

      var weather = new Weather(
          temperature: temperature,
          condition: condition
      );
      //print("Weather.parse - weather=${weather.toString()}");
      return weather;
    } catch (err) {
      print("Weather.parse - ERROR: ${err.toString()}");
    }
    return null;
  }

  static List<Weather> parseForecast(String jsonString) {
    print("Weather.parseForecast - Start");
    //print("Weather.parseForecast - jsonString=$jsonString");

    try {
      final JsonDecoder json = const JsonDecoder();
      var map = json.convert(jsonString);

      List weathers = map['list'];
      return weathers.map((node) {
        //print("Weather.parseForecast - node: ${node.toString()}");

        String description = node["weather"][0]["description"];
        int id = node["weather"][0]["id"];
        DateTime day = DateTime.parse(node["dt_txt"]);

        Condition condition = new Condition(id: "$id", description: description);
        double temperature = node["main"]["temp"].toDouble();

        return Weather(
            day: day,
            temperature: temperature,
            condition: condition
        );
      }).toList();

    } catch (err) {
      print("Weather.parse - ERROR: ${err.toString()}");
    }
    return null;
  }

  static List<Weather> parseHereWeather(String jsonString) {
    print("Weather.parseHereWeather - Start");
    print("Weather.parseHereWeather - jsonString: $jsonString");

    try {
      final JsonDecoder json = const JsonDecoder();
      var map = json.convert(jsonString);
      //print("Weather.parseHereWeather - map: ${map.toString()}");

      List weathers = map['dailyForecasts']['forecastLocation']['forecast'];
      return weathers.map((node) {
        String description = node["skyDescription"];
        String id = node["icon"];
        String iconLink = node["iconLink"];
        DateTime day = DateTime.parse(node["utcTime"]);
        double temperature = double.parse(node["comfort"]);

        Condition condition = new Condition(id: id, description: description, iconLink: iconLink);

        return Weather(
            day: day,
            temperature: temperature,
            condition: condition
        );
      }).toList();

    } catch (err) {
      print("Weather.parseHereWeather - ERROR: ${err.toString()}");
    }
    return null;
  }

  @override
  String toString() {
    return '''Weather {
      day: $day,
      temperature: $temperature, 
      condition: ${condition.toString()}
    }''';
  }
}


class Condition {
  String id;
  String description;
  String iconLink;

  Condition({this.id, this.description, this.iconLink});

  /*String getDescription(){
    if (id != null) {
      if (id >= 200 && id <= 299)
        return "Tormenta";
      else if (id >= 300 && id <= 399)
        return "Llovizna";
      else if (id >= 500 && id <= 599)
        return "Lluvia";
      else if (id >= 600 && id <= 699)
        return "Nieve";
      else if (id >= 700 && id <= 799)
        return "Niebla";
      else if (id == 800)
        return "Soleado";
      else if (id == 801)
        return "Pocas nubes";
      else if (id == 802)
        return "Nubes dispersas";
      else if (id == 803 || id == 804)
        return "Nublado";

      print("Unknown condition $id");
    }

    return "Desconocido";
  }

  IconData getIcon() {
    if (id != null) {
      if (id >= 200 && id <= 299)
        return WeatherIcons.day_thunderstorm;
      else if (id >= 300 && id <= 399)
        return WeatherIcons.day_showers;
      else if (id >= 500 && id <= 599)
        return WeatherIcons.day_rain;
      else if (id >= 600 && id <= 699)
        return WeatherIcons.day_snow;
      else if (id >= 700 && id <= 799)
        return WeatherIcons.day_fog;
      else if (id == 800)
        return WeatherIcons.day_sunny;
      else if (id == 801)
        return WeatherIcons.day_sunny_overcast;
      else if (id == 802)
        return WeatherIcons.cloudy;
      else if (id == 803 || id == 804)
        return WeatherIcons.cloudy_gusts;

      print("Unknown condition $id");
    }

    return WeatherIcons.na;
  }

  String getAssetString() {
    if (id >= 200 && id <= 299)
      return "assets/img/d7s.png";
    else if (id >= 300 && id <= 399)
      return "assets/img/d6s.png";
    else if (id >= 500 && id <= 599)
      return "assets/img/d5s.png";
    else if (id >= 600 && id <= 699)
      return "assets/img/d8s.png";
    else if (id >= 700 && id <= 799)
      return "assets/img/d9s.png";
    else if (id >= 300 && id <= 399)
      return "assets/img/d6s.png";
    else if (id == 800)
      return "assets/img/d1s.png";
    else if (id == 801)
      return "assets/img/d2s.png";
    else if (id == 802)
      return "assets/img/d3s.png";
    else if (id == 803 || id == 804)
      return "assets/img/d4s.png";

    print("Unknown condition $id");
    return "assets/img/n1s.png";
  }*/

  @override
  String toString() {
    return '''Condition {
      id: $id, 
      description: $description
    }''';
  }
}