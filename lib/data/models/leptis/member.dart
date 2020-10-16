import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;
import 'package:logging/logging.dart';


class Member {
  Member({
    this.username,
    this.name,
    this.lastname,
    this.phone,
    this.email,
    this.avatarUrl,
    this.rol
  });

  final String username;
  final String name;
  final String lastname;
  final String phone;
  final String email;
  final String avatarUrl;
  final String rol;


  static List<String> parseIds(String htmlString) {
    Document document = html.parse(htmlString);

    List<String> membersId = document.querySelectorAll('.boton-input').map((elem) {
      if(elem.attributes['value'] == 'Detalle/Editar') {
        String link = elem
            .attributes['onclick']; //document.location.href='gestion_socios_editar.php?codPK=22'
        //print("id: ${link.substring(link.lastIndexOf('codPK=') + 1)}");
        return link.substring(link.lastIndexOf('=') + 1).replaceAll("'", "");
      }
      return null;
    }).toList();
    membersId.removeWhere((item) => item == null);

    return membersId;
  }

  static List<String> parsePagination(String htmlString) {
    Document document = html.parse(htmlString);

    List<String> pagIdx = document.querySelector('#paginador').querySelectorAll('a').map((elem) => (elem.text.indexOf('Siguiente')==-1) ? elem.text : null).toList();
    pagIdx.removeWhere((item) => item == null);
    return pagIdx;
  }

  static Member parse(String htmlString) {
    final Logger log = new Logger('Member');

    var document = html.parse(htmlString);


    //String codPK = document.querySelector('#codPK').attributes['value'];
    String nombre = document.querySelector('#nombre').attributes['value'];
    String apellidos = document.querySelector('#apellidos').attributes['value'];
    String telefono = document.querySelector('#telefono').attributes['value'];
    String telefonomovil = document.querySelector('#telefonomovil').attributes['value'];
    String mail = document.querySelector('#mail').attributes['value'];
    String login = document.querySelector('#login').attributes['value'];
    //String pass = document.querySelector('#pass').attributes['value'];

    String tipo = document.getElementById('tipo').querySelector('option[selected]').text ?? 'Usuario';
    log.fine('Usuario: $nombre $apellidos, Rol: $tipo');

    return Member(
      username: login,
      name: nombre,
      lastname: apellidos,
      email: mail,
      phone: telefono ?? telefonomovil,
      rol: tipo
    );
  }

  static List<Member> parseAll(String htmlString) {
    var document = html.parse(htmlString);

    var members = document.querySelectorAll('table tr.yes tr.no');

    return members.map((tr) {
      var cont = 0;
      var name, lastname, phone, email, rol;

      tr.querySelectorAll('td').forEach((td) {
        switch (cont++){
          case 0: name = td.text; break;
          case 1: lastname = td.text; break;
          case 2: rol = td.text; break;
          case 3: phone = td.text; break;
          case 4: email = td.text; break;
        }
      });

      return Member(
        name: name,
        lastname: lastname,
        phone: phone,
        email: email,
        rol: rol
      );
    }).toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Member &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              lastname == other.lastname &&
              phone == other.phone &&
              email == other.email &&
              avatarUrl == other.avatarUrl &&
              rol == other.rol;

  @override
  int get hashCode =>
      name.hashCode ^
      lastname.hashCode ^
      phone.hashCode ^
      email.hashCode ^
      avatarUrl.hashCode ^
      rol.hashCode;
}