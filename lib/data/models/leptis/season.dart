import 'dart:convert';

class Season {
  Season({
    this.id,
    this.title,
  });

  final String id;
  final String title;


  static Season parse(String jsonString) {
    //print("Season.parse - Start");
    final JsonDecoder json = const JsonDecoder();

    //print("Season.parse - jsonString=$jsonString");
    var document = json.convert(jsonString);

    try {
      //print("Season.parse - temporada: ${document['temporada'].toString()}");
      var season = document['temporada'];
      return Season(
        id: season['id'],
        title: season['titulo']
      );
    } catch (err) {
      print("Season.parse - Error parseando JSON: ERROR=${err.toString()}");
    }

    return null;
  }

  @override
  String toString() {
    return '''Season {
      id: $id, 
      title: $title
    }''';
  }
}