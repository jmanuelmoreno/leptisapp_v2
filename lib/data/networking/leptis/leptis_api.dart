import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:leptisapp/data/models/leptis/regularity_history.dart';
import 'package:leptisapp/ui/regularity/regularity_add_list.dart';
import 'package:leptisapp/utils/http_utils.dart';
import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/data/models/leptis/member.dart';
import 'package:leptisapp/data/models/leptis/regularity.dart';
import 'package:logging/logging.dart';


class LeptisApi {
  final Logger log = new Logger('LeptisApi');

  static final DateFormat ddMMyyyy = new DateFormat('dd.MM.yyyy');

  static final String kLeptisBaseUrl = 'www.leptisutrera.com';
  static final Uri kLeptisLoginBaseUrl = new Uri.http(kLeptisBaseUrl, '/login_intranet.php');

  static final Uri kLeptisRegularityBaseUrl = new Uri.http(kLeptisBaseUrl, '/intranet/clasificacion_temporada.php');
  static final Uri kLeptisRegularityHistoryBaseUrl = new Uri.http(kLeptisBaseUrl, '/intranet/clasificacion_temporada_historico.php');
  static final Uri kLeptisRegularityNewBaseUrl = new Uri.http(kLeptisBaseUrl, '/intranet/salida_nuevo.php');
  static final Uri kLeptisRegularityUpdateBaseUrl = new Uri.http(kLeptisBaseUrl, '/intranet/salida_modificar2.php');

  static final Uri kLeptisMembersBaseUrl = new Uri.http(kLeptisBaseUrl, '/intranet/gestion_socios.php');
  static final Uri kLeptisMemberInfoBaseUrl = new Uri.http(kLeptisBaseUrl, '/intranet/gestion_socios_editar.php');


  Future<List<Member>> findAvatarsForMembers(
      BookEvent bookEvent, List<Member> members) async {
    /*int movieId = await _findMovieId(event.originalTitle);

    if (movieId != null) {
      return _getActorAvatars(movieId);
    }*/

    return members;
  }


  //Login
  Future<String> logIn(String username, String password) async {
    log.fine("LeptisApi.logIn - Start");

    return http.post(kLeptisLoginBaseUrl, body: {
      "usuario": username,
      "pass": password
    }).then((response) {
      String sessionToken = response.headers['set-cookie'];
      sessionToken = sessionToken.substring(0, sessionToken.indexOf(';'));

      var data = response.body;
      if(data.toString().indexOf('intermedia.php') != -1) {
        return getRequestWithHeaders(Uri.parse('http://www.leptisutrera.com/./intranet/intermedia.php'), {HttpHeaders.cookieHeader: sessionToken}).then((body) {
          if (body.indexOf('../inicio.php') == -1) {
            return sessionToken;
          }
          return null;
        });
      }
      return null;
    });
  }

  ///
  /// Recupera los identificadores de Socios
  ///
  Future<List<String>> _getMembersId(String sessionToken) {
    log.fine("LeptisApi._getMembers - Start");

    return getRequestWithHeaders(kLeptisMembersBaseUrl, {HttpHeaders.cookieHeader: sessionToken}).then((body) {
      //Id's pagina 1
      List<String> idsByPage = Member.parseIds(body);

      //Resto de Id's
      List<String> pagination = Member.parsePagination(body);
      return Future.forEach(pagination, ((pag) async {
        var body = await getRequestWithHeaders(
            kLeptisMembersBaseUrl.replace(queryParameters: <String, String>{'pg': pag,}), {HttpHeaders.cookieHeader: sessionToken});
        idsByPage.addAll(Member.parseIds(body));
      })).then((resp){
        return idsByPage;
      });
    });
  }

  ///
  /// Recupera información de los Socios
  ///
  Future<List<Member>> getMembers(String sessionToken) async {
    log.fine("LeptisApi.getMembers - Start");

    List<String> idList = await _getMembersId(sessionToken);
    return Future.wait(idList.map((id){
        return getRequestWithHeaders(
            kLeptisMemberInfoBaseUrl.replace(queryParameters: <String, String>{'codPK': id,}), {HttpHeaders.cookieHeader: sessionToken}
        ).then((response){
          return Member.parse(response);
        });
      }).toList()
    );
  }

  ///
  /// Recupera información de Regularidad
  ///
  Future<List<Regularity>> getRegularity(String season, String sessionToken) async {
    log.fine("LeptisApi.getRegularity - Start");

    //log.fine("LeptisApi.getRegularity - request: ${kLeptisRegularityBaseUrl.replace(queryParameters: <String, String>{'temporada': season,})}");
    var response = await getRequestWithHeaders(
        kLeptisRegularityBaseUrl.replace(queryParameters: <String, String>{'temporada': season,}),
        {HttpHeaders.cookieHeader: sessionToken}
    );
    //log.fine("LeptisApi.getRegularity - request: $response");

    return Regularity.parseAll(response, season);
  }

  ///
  /// Recupera historico de Regularidad
  ///
  Future<List<RegularityHistory>> getRegularityHistory(String memberId, String season, String sessionToken) async {
    log.fine("LeptisApi.getRegularityHistory - Start");

    var response = await getRequestWithHeaders(
        kLeptisRegularityHistoryBaseUrl.replace(queryParameters: <String, String>{'temporada': season, 'socioFK': memberId}),
        {HttpHeaders.cookieHeader: sessionToken}
    );

    return RegularityHistory.parseHistoryAll(memberId, season, response);
  }

  ///
  /// Regularidad - Nueva salida
  ///
  Future<void> saveNewRegularity(List<MemberItemCheckList> membersCheckList, String season, String day, String sessionToken) async {
    log.fine("LeptisApi.saveNewRegularity - Start");

    Map<String, String> queryParams = <String, String>{
      'aux': '',  // necesario para activar el modo de guardado en el servidor
      'fecha': day
    };
    membersCheckList.forEach((MemberItemCheckList item) => queryParams.putIfAbsent("chk${item.id}", () => item.checked ? "1" : "0" )); // +1 pto
    log.fine('Parametros: ${queryParams.toString()}');

    var url = Uri.parse('$kLeptisRegularityNewBaseUrl?temporada=$season'); // necesario enviar 'temporada' por GET
    StreamedResponse response = await postRequestWithHeaders(url, queryParams, {HttpHeaders.cookieHeader: sessionToken});

    log.fine("LeptisApi.saveNewRegularity - response: ${response.stream.toString()}");
  }
}
