import 'dart:convert';
import 'package:leptisapp/data/models/leptis/member.dart';
import 'package:leptisapp/data/models/leptis/weather.dart';

enum BookEventListType {
  inSeason,
  inAlternative,
}

class BookEvent {
  BookEvent({
    this.id,
    this.eventDay,
    this.title,
    this.description,
    this.routeline,
    this.escort,
    this.coverUrl,
    this.hardness,
    this.distance,
    this.authors,
    this.photoUrls,
    this.rating,
    this.start,
    this.daylight,
    this.startPoint,
    this.routeMapCoverUrl,
    this.routeMapUrl,
    this.weather,
  });

  final int id;
  final DateTime eventDay; // día de la salida
  final String title; // titulo
  final String description; // descripción
  final String routeline; // recorrido
  final String coverUrl; // foto de portada
  final String hardness; // dificultad
  final double distance; // distancia
  final List<String> authors; // autor
  final DateTime start; // fecha y hora de salida
  final String daylight; // tipo de horario
  final String startPoint; // lugar de salida
  final String routeMapUrl; // mapa de la ruta
  final double rating; // puntuacion de la salida

  List<Member> escort; // acompañamiento
  List<String> photoUrls; // fotos adicionales
  String routeMapCoverUrl; // imagen de portada del mapa
  Weather weather;

  bool get hasEventDay => (eventDay != null);

  bool get hasDistance => (distance != null && distance > 0);

  bool get hasRouteDetails =>
      (routeline != null && routeline.isNotEmpty);

  bool get hasRouteMap =>
      (routeMapUrl != null && routeMapUrl.isNotEmpty);

  bool get hasEscort =>
      (escort != null && escort.isNotEmpty);

  bool get hasPhotos =>
      (photoUrls != null && photoUrls.isNotEmpty);

  bool get hasWeather => (weather != null);

  static List<BookEvent> parseAll(String jsonString) {
    //print("BookEvent.parseAll - Start");
    final JsonDecoder json = const JsonDecoder();

    //print("BookEvent.parseAll - jsonString=$jsonString");
    var document = json.convert(jsonString);

    try {
      //print("BookEvent.parseAll - calendario: ${document['calendario'].toString()}");
      List events = document['calendario'];
      //print("BookEvent.parseAll - events.length=${events.length}");
      return events.map((node) {
        //print("BookEvent.parseAll - node: ${node.toString()}");
        return BookEvent(
          id: node['id'],
          eventDay: _parseDateTimeOrNull(node['fecha']),
          title: node['ruta']['nombre'],
          description: node['ruta']['descripcion'],
          routeline: node['ruta']['recorrido'],
          coverUrl: node['url_portada'],
          hardness: node['ruta']['dificultad'],
          distance: node['ruta']['kms'],
          authors: _parseAuthors(node['autores']),
          start: _parseDateTimeOrNull('${node['fecha']} ${node['hora']}'),
          daylight: node['horario_verano'],
          startPoint: node['lugar_salida'],
          rating: node['puntuacion'],
          //routeMapCoverUrl: node['ruta']['imagen_track'],
          routeMapUrl: node['ruta']['track'],
          //photoUrls: ['https://picsum.photos/800/400/?random', 'https://picsum.photos/800/400/?random', 'https://picsum.photos/800/400/?random', 'https://picsum.photos/800/400/?random'],
          escort: [],
        );
      }).toList();
    } catch (err) {
      print("BookEvent.parseAll - Error parseando JSON: ERROR=${err.toString()}");
    }

    return null;
  }

  static List<String> _parseAuthors(List<dynamic> nodes) {
    //print("BookEvent._parseAuthors - Start");
    return nodes.map((node) {
      return '$node';
    }).toList();
  }

  static DateTime _parseDateTimeOrNull(String content) {
    //print("BookEvent._parseDateTimeOrNull - Start");
    if (content.isNotEmpty) {
      try {
        return DateTime.parse(content);
      } catch (e) {}
    }
    return null;
  }

  @override
  String toString() {
    return """{
      id=$id, 
      eventDay=$eventDay, 
      title=$title, 
      description=$description, 
      routeline=$routeline, 
      routeMapUrl=$routeMapUrl,
      escort=$escort, 
      coverUrl=$coverUrl, 
      hardness=$hardness, 
      distance=$distance, 
      authors=$authors,
      weather=${weather.toString()}
    }""";
  }
}