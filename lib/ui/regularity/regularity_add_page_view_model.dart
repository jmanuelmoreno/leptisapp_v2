import 'package:flutter/material.dart';
import 'package:leptisapp/data/loading_status.dart';
import 'package:leptisapp/data/models/leptis/regularity.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/leptis/regularity/regularity_actions.dart';
import 'package:leptisapp/redux/leptis/regularity/regularity_selectors.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:share/share.dart';
import 'package:strings/strings.dart';

import 'regularity_add_list.dart';

typedef void AddPointRegularityCallback(BuildContext context, List<MemberItemCheckList> membersCheckList, String day);

class RegularityAddPageViewModel {
  RegularityAddPageViewModel({
    @required this.status,
    @required this.regularity,
    @required this.refreshRegularity,
    @required this.addPointRegularity,
  });

  final LoadingStatus status;
  final List<Regularity> regularity;
  final Function refreshRegularity;
  final AddPointRegularityCallback addPointRegularity;

  static RegularityAddPageViewModel fromStore(
    Store<AppState> store,
    BuildContext context,
  ) {
    return RegularityAddPageViewModel(
      status: store.state.bookEventState.loadingStatus,
      regularity: regularitySelector(store.state),
      refreshRegularity: () => store.dispatch(RefreshRegularityAction()),
      addPointRegularity: (BuildContext context, List<MemberItemCheckList> membersCheckList, String day) {
        store.dispatch(AddPointRegularityAction(
            membersCheckList: membersCheckList,
            day: day
        ));
        Navigator.of(context).pop();

        _showResumen(context, membersCheckList, day);
      },
    );
  }

  static void _showResumen(BuildContext context, List<MemberItemCheckList> _membersCheckList, String day) {

    final _listTiles = _membersCheckList.map((item) => (item.checked) ? item.title.split(' ').map((txt) => capitalize(txt.toLowerCase())).join(' ') : null).toList();
    _listTiles.removeWhere((item) => item == null);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Resumen'),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _listTiles.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_listTiles[index]),
                    onTap: () => {},
                  );
                },
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Compartir'),
                onPressed: () {
                  Navigator.of(context).pop();
                  final RenderBox box = context.findRenderObject();
                  Share.share('*ASISTENCIA - $day*\n\n- ' + _listTiles.join('\n- '),
                      subject: 'Socios puntuados',
                      sharePositionOrigin:
                      box.localToGlobal(Offset.zero) &
                      box.size);
                },
              ),
              FlatButton(
                child: Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );



  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegularityAddPageViewModel &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          regularity == other.regularity &&
          refreshRegularity == other.refreshRegularity &&
          addPointRegularity == other.addPointRegularity;

  @override
  int get hashCode =>
      status.hashCode ^ regularity.hashCode ^ refreshRegularity.hashCode ^ addPointRegularity.hashCode;
}
