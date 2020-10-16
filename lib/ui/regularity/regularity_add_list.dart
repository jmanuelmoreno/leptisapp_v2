import 'package:flutter/material.dart';
import 'package:leptisapp/data/models/leptis/regularity.dart';
import 'package:leptisapp/ui/common/info_message_view.dart';
import 'package:leptisapp/ui/regularity/regularity_add_page_view_model.dart';
import 'package:leptisapp/utils/clock.dart';
import 'package:logging/logging.dart';

class RegularityAddList extends StatefulWidget {
  RegularityAddList({
    @required this.regularity,
    //@required this.regularityDay,
    @required this.onReloadCallback,
    @required this.onAddPointCallback,
  });
  final List<Regularity> regularity;
  //final DateTime regularityDay;
  final VoidCallback onReloadCallback;
  final AddPointRegularityCallback onAddPointCallback;

  @override
  _RegularityAddListState createState() => _RegularityAddListState();
}

class _RegularityAddListState extends State<RegularityAddList> {
  final Logger log = new Logger('_RegularityAddListState');

  static const Key emptyViewKey = const Key('emptyView');
  static const Key contentKey = const Key('content');

  List<MemberItemCheckList> _items;
  String _day;
  int cont = 0;

  @override
  void initState() {
    super.initState();
    _items = widget.regularity.map((Regularity r) => MemberItemCheckList(r.memberId, r.fullname, false)).toList();
    cont = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _addPoints() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        //initialDate: widget.regularityDay,
        firstDate: DateTime(1999),
        lastDate: DateTime(2050),
        //selectableDayPredicate: (DateTime val) => val.weekday == DateTime.sunday  ? true : false,
    );
    if(picked != null) {
      setState(() => _day = Clock.getDefaultDateTimeFormatted(picked));
      log.fine(
          "_RegularityAddListState - _addPoints: Sumando puntos para el dia $_day");
      widget.onAddPointCallback(context, _items, _day);
    } else {
      log.fine(
          "_RegularityAddListState - _addPoints: Sumando puntos se ha cancelado");
    }
  }

  void _showDialog(String msg) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Información"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    final _listTiles = _items.map((item) => CheckboxListTile(
      key: Key(item.id),
      value: item.checked ?? false,
      title: new Text(item.title),
      onChanged: (bool checked) {
          setState(() {
            item.checked = checked;
            cont += (checked ? 1 : -1);
          });
      },
    )).toList();

    return new ListView(
      children: _listTiles,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text('Sumar Pto - Regularidad'),
        title: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Text(
                'Sumar Pto - Regularidad',
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 14.0),
                child: new Text("${cont>0 ? cont : ''}", style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ))
              )
            ]
        )
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.save),
        onPressed: (){
          //widget.onAddPointCallback(_items, '01/01/2010');
          if(_items.any((item) => item.checked == true))
            _addPoints();
          else
            _showDialog("Debes seleccionar algún socio para poder continuar.");
        }
      ),
      backgroundColor: Colors.white,
      body: (widget.regularity == null) ?
        InfoMessageView(
          key: emptyViewKey,
          title: 'Todo vacío!',
          description: 'No encuentro información de regularidad. ¯\\_(ツ)_/¯',
          onActionButtonTapped: widget.onReloadCallback,
        )
      :
        _buildContent(context)
    );
  }
}

class MemberItemCheckList {
  MemberItemCheckList(this.id, this.title, this.checked);
  final String id;
  final String title;
  bool checked;

  @override
  String toString() {
    return """{
      id=$id,
      title=$title,
      checked=$checked
    }""";
  }
}
