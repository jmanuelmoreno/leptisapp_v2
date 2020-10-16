import 'package:html/parser.dart' as html;

//final RegExp _nameExpr = new RegExp(r'([A-Z])([A-Z]+)');

class Regularity {
  Regularity({
    this.id,
    this.memberId,
    this.season,
    this.fullname,
    this.score,
    this.history,
  });

  final int id;
  final String memberId;
  final String season;
  final String fullname;
  final double score;
  List<Map<String, String>> history;


  static List<Regularity> parseAll(String htmlString, String season) {
    var document = html.parse(htmlString);

    try {
      var regularities = document.querySelectorAll('table tr');

      var id = 0;
      List<Regularity> regularity = regularities.map((tr) {
        var cont = 0;
        var fullname = "";
        var score = 0.0;
        var memberId = "";

        tr.querySelectorAll('td').forEach((td) {
          if (cont == 0) fullname = td.text;
          if (cont == 1) score = (td.text != '') ? double.parse(td.text) : 0.0;
          if (cont == 2) {
            //print("Regularity.parseAll - html: ${td.querySelector('a').toString()}");
            //print("Regularity.parseAll - attributes: ${td.querySelector('a').attributes.toString()}");
            //print("Regularity.parseAll - href: ${td.querySelector('a').attributes['href'].toString()}");
            memberId = _getMemberId(td.querySelector('a').attributes['href']);
          }
          cont++;
        });

        //print("Regularity.parseAll - fullname: $fullname, score: $score");
        return Regularity(
            id: id++,
            memberId: memberId,
            season: season,
            //fullname: _normalize(fullname),
            fullname: fullname,
            score: score,
            history: []
        );
      }).toList();
      regularity.removeWhere((item) => item.fullname.trim().isEmpty);
      regularity.sort((a, b) => b.score.compareTo(a.score));

      return regularity;
    } catch (err) {
      print("Regularity.parseAll - Error parseando JSON: ERROR=${err.toString()}");
    }

    return null;
  }

  static List<Map<String, String>> parseHistoryAll(String htmlString) {
    var document = html.parse(htmlString);

    try {
      var histories = document.querySelectorAll('table tr');
      List<Map<String, String>> history = histories.map((tr) {
        var cont = 0;
        var date = "";
        var points = "";

        tr.querySelectorAll('td').forEach((td) {
          if (cont == 0) date = td.text;
          if (cont == 1) points = td.text;
          cont++;
        });

        return new Map<String, String>()
          ..['date'] = date
          ..['points'] = points;
      }).toList();
      history.removeWhere((item) => item['date'].trim().isEmpty);
      history.sort((a, b) => b['date'].compareTo(a['date']));

      return history;
    } catch (err) {
      print("Regularity.parseAll - Error parseando JSON: ERROR=${err.toString()}");
    }

    return null;
  }

  @override
  String toString() {
    return '''Regularity {
      id: $id, 
      memberId: $memberId,
      season: $season,
      fullname: $fullname, 
      score: $score,
      history: ${history.toString()}
    }''';
  }

  /*static String _normalize(String text) {
    return text.replaceAllMapped(_nameExpr, (match) {
      return '${match.group(1)}${match.group(2).toLowerCase()}';
    });
  }*/

  static String _getMemberId(String link) {
    //print("Regularity._getMemberId - Start");
    RegExp regExp = new RegExp(r"socioFK=[^&?]*", caseSensitive: true, multiLine: false,);
    return regExp.stringMatch(link).toString().split('=')[1];
  }
}