import 'dart:convert';


class Escort {
  Escort({
    this.day,
    this.escort1,
    this.escort2,
  });

  final DateTime day;
  final String escort1;
  final String escort2;


  static List<Escort> parseAll(String jsonString) {
    print("Escort.parseAll - Start");
    final JsonDecoder json = const JsonDecoder();

    var document = json.convert(jsonString);

    try {
      List escorts = document;
      return escorts.map((node) {
        return Escort(
          day: DateTime.parse(node['fecha']),
          escort1: node['pareja1'],
          escort2: node['pareja2'],
        );
      }).toList();
    } catch (err) {
      print("Escort.parseAll - Error parseando JSON: ERROR=${err.toString()}");
    }

    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Escort &&
              runtimeType == other.runtimeType &&
              day == other.day &&
              escort1 == other.escort1 &&
              escort2 == other.escort2;

  @override
  int get hashCode =>
      day.hashCode ^
      escort1.hashCode ^
      escort2.hashCode;

  @override
  String toString() {
    return """{
      day=$day,
      escort1=$escort1,
      escort2=$escort2
    }""";
  }
}