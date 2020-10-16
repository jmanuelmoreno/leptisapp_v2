import 'dart:convert';
import 'package:logging/logging.dart';

class Event {
  Event({
    this.startDate,
    this.endDate,
    this.hour,
    this.title,
    this.subtitle,
    this.description,
    this.direction,
    this.coverUrl,
    this.authors,
    this.photoUrls,
  });

  final DateTime startDate; // fecha inicio
  final DateTime endDate; // fecha fin
  final DateTime hour; // hora inicio
  final String title; // titulo
  final String subtitle; // subtitulo
  final String description; // descripción
  final String direction; // dirección
  final String coverUrl; // foto de portada
  final List<String> authors; // autor

  List<String> photoUrls; // fotos adicionales


  bool get hasSubtitle =>
      (subtitle != null && subtitle.isNotEmpty);

  bool get hasHour => (hour != null);

  bool get hasDescription =>
      (description != null && description.isNotEmpty);

  bool get hasDirection =>
      (direction != null && direction.isNotEmpty);

  bool get hasPhotos =>
      (photoUrls != null && photoUrls.isNotEmpty);


  static List<Event> parseAll(String jsonString) {
    var document = jsonDecode(jsonString);

    try {
      List grupos = document['eventos'];

      return grupos.map((node) {
        print("node: ${node.toString()}");
        return Event(
          startDate: _parseDateTimeOrNull(node['fecha_inicio']),
          endDate: _parseDateTimeOrNull(node['fecha_fin']),
          hour:_parseDateTimeOrNull('${node['fecha_inicio']} ${node['hora']}'),
          title: node['titulo'],
          subtitle: node['subtitulo'],
          description: node['descripcion'],
          direction: node['direccion'],
          coverUrl: node['url_portada'],
          authors: _parseAuthors(node['autores']),
          photoUrls: _parseListOrNull(node['fotos']),
        );
      }).toList();
    } catch (err) {
      Logger('Event').severe("Event.parseAll - Error parseando JSON, ${err.toString()}");
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

  static List<String> _parseListOrNull(List<dynamic> content) {
    if (content.isNotEmpty && content.length > 0) {
      try {
        return content.map((item) => item.toString()).toList();
      } catch (e) {}
    }
    return null;
  }

  @override
  String toString() {
    return """{
      startDate=$startDate, 
      endDate=$endDate, 
      hour=$hour, 
      title=$title,
      subtitle=$subtitle,  
      description=$description, 
      direction=$direction, 
      coverUrl=$coverUrl, 
      authors=$authors
    }""";
  }
}