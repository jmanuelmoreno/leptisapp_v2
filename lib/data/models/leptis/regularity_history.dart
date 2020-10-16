import 'package:html/parser.dart' as html;
import 'package:logging/logging.dart';

class RegularityHistory {
  final Logger log = new Logger('RegularityHistory');

  RegularityHistory({
    this.id,
    this.memberId,
    this.season,
    this.date,
    this.points,
  });

  final int id;
  final String memberId;
  final String season;
  final String date;
  final double points;


  static List<RegularityHistory> parseHistoryAll(String memberId, String season, String htmlString) {
    Logger('RegularityHistory').fine("RegularityHistory.parseHistoryAll - htmlString: $htmlString");

    var document = html.parse(htmlString);
    Logger('RegularityHistory').fine("RegularityHistory.parseHistoryAll - document: ${document.toString()}");

    try {
      var histories = document.querySelectorAll('table tr');

      var contTr = 0;
      List<RegularityHistory> history = histories.map((tr) {
        var contTd = 0;
        var date = "";
        var points = "";

        tr.querySelectorAll('td').forEach((td) {
          if (contTd == 0) date = td.text;
          if (contTd == 1) points = td.text;
          contTd++;
        });

        if(date.isEmpty) return null;
        Logger('RegularityHistory').fine("RegularityHistory.parseHistoryAll - date: $date, points: $points");
        contTr++;
        return RegularityHistory(
          id: contTr-1,
          memberId: memberId,
          season: season,
          date: date,
          points: double.parse(points)
        );
      }).toList();

      history.removeWhere((regularityHistory) => regularityHistory == null);
      //history.sort((a, b) => b.date.compareTo(a.date));

      return history;

    } catch (err) {
      print("RegularityHistory.parseHistoryAll - Error parseando JSON: ERROR=${err.toString()}");
    }

    return null;
  }

  @override
  String toString() {
    return '''RegularityHistory {
      id: $id, 
      memberId: $memberId,
      season: $season,
      date: $date, 
      points: $points,
    }''';
  }

}