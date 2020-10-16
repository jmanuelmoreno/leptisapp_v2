import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/data/models/leptis/weather.dart';
import 'package:leptisapp/data/networking/leptis/here_api.dart';

class WeatherWidget extends StatelessWidget {
  WeatherWidget({
    @required this.bookEvent,
    @required this.size,
    @required this.onWeatherTapped,
  });
  final BookEvent bookEvent;
  final double size;
  final VoidCallback onWeatherTapped;

  Future<Weather> _getWeather(String cityname) async {
    List<Weather> result = await HereApi.getWeatherForecast(cityname);
    Weather weather = result.firstWhere((Weather weather) => weather.day.toLocal().isAtSameMomentAs(bookEvent.eventDay), orElse: () => null);
    return weather;
  }

  @override
  Widget build(BuildContext context) {
    /*return StoreConnector<AppState, Weather>(
      rebuildOnChange: true,
      onInit: (store) => store.dispatch(FetchWeatherAction(bookEvent)),
      converter: (store) => weatherForBookEventSelector(store.state, bookEvent),
      builder: (_, Weather weather) => WeatherContent(weather: weather, size: size, onWeatherTapped: onWeatherTapped),
    );*/
    return new FutureBuilder(
        future: _getWeather("Utrera"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!=null) {
              return WeatherContent(weather: snapshot.data, size: size, onWeatherTapped: onWeatherTapped);
            } else {
              return new Container();
            }
          } else {
            //return new CircularProgressIndicator();
            return new Container();
          }
        }
    );
  }
}

class WeatherContent extends StatelessWidget {
  WeatherContent({
    @required this.weather,
    @required this.size,
    @required this.onWeatherTapped,
  });
  final Weather weather;
  final double size;
  final VoidCallback onWeatherTapped;

  @override
  Widget build(BuildContext context) {
    var content = (weather != null)?
      Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 0.0),
            //child: Icon(weather != null ? weather.condition.getIcon() : WeatherIcons.na, size: size),
            child: CachedNetworkImage(
              placeholder: (context, url) => CircularProgressIndicator(),
              imageUrl: weather.condition.iconLink,
              width: size,
              fadeInDuration: const Duration(milliseconds: 150),
              fit: BoxFit.fill,
            ),
          ),
          //Text(weather != null ? weather.condition.description : "Sin previsión", style: Theme.of(context).textTheme.caption)
        ],
      ) : Container();

    return content;

    /*return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Icon(weather != null ? weather.condition.getIcon() : WeatherIcons.na, size: size),
        ),
        Text(weather != null ? weather.condition.getDescription() : "Sin previsión", style: Theme.of(context).textTheme.caption)
      ],
    );*/
  }
}