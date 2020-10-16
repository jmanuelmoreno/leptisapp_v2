import 'package:flutter/material.dart';
import 'package:leptisapp/data/models/leptis/leptis_user.dart';
import 'package:leptisapp/data/models/leptis/regularity.dart';
import 'package:leptisapp/ui/book_event_details/book_event_details_scroll_effects.dart';
import 'package:leptisapp/ui/common/info_message_view.dart';
import 'package:leptisapp/ui/regularity/regularity_add_page.dart';
import 'package:leptisapp/ui/regularity/regularity_backdrop_photo.dart';
import 'package:intl/intl.dart';
import 'package:leptisapp/ui/regularity_history/regularity_history_page.dart';

class RegularityList extends StatefulWidget {
  RegularityList({
    @required this.regularity,
    @required this.currentUser,
    @required this.onReloadCallback,
  });
  final List<Regularity> regularity;
  final LeptisUser currentUser;
  final VoidCallback onReloadCallback;

  @override
  _RegularityListState createState() => _RegularityListState();
}

class _RegularityListState extends State<RegularityList> {
  static const Key emptyViewKey = const Key('emptyView');
  static const Key contentKey = const Key('content');

  static const double backdrop_height = 200.0;

  ScrollController _scrollController;
  BookEventDetailsScrollEffects _scrollEffects;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _scrollEffects = BookEventDetailsScrollEffects();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    setState(() {
      _scrollEffects.updateScrollOffset(context, _scrollController.offset);
    });
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Transparent container that makes the space for the backdrop photo.
        Container(
          height: backdrop_height,
          margin: const EdgeInsets.only(bottom: 15.0),
        ),
      ],
    );
  }

  Widget _buildRegularityBackdrop() {
    return Positioned(
      top: _scrollEffects.headerOffset,
      child: RegularityBackdropPhoto(
          assetImage: 'assets/images/podio.png',
          height: _scrollEffects.backdropHeight,
          overlayBlur: _scrollEffects.backdropOverlayBlur,
          blurOverlayOpacity: _scrollEffects.backdropOverlayOpacity,
        ),
      //child: ArcBannerImage(widget.bookEvent.coverUrl),
    );
  }

  /*Widget _buildStatusBarBackground() {
    var statusBarColor = Theme.of(context).primaryColor;

    return Container(
      height: _scrollEffects.statusBarHeight,
      color: statusBarColor,
    );
  }*/

  Widget _buildRegularityList() {
    return new SliverList(
        delegate: SliverChildBuilderDelegate((context, i) {
          if (i.isOdd) return const Divider(indent: 70.0,);

          final index = i ~/ 2;
          return _buildRow(widget.regularity[index]);
        },
        childCount: widget.regularity.length * 2,
      )
    );
  }


  _displayHistoryDialog(BuildContext context, String memberId) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Salidas Realizadas'),
            content: Container(
              width: double.maxFinite,
              height: 300.0,
              child: RegularityHistoryPage(memberId: memberId),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }


  Widget _buildRow(Regularity regularity) {
    /*return new ListTile(
      leading: new CircleAvatar(child: new Text(item.fullname[0])),
      title: Text('${item.fullname}'),
      trailing: Text('${item.score}'),
    );*/

    /*return new ExpansionTile(
      leading: new CircleAvatar(child: new Text(regularity.fullname[0])),
      title: new Text('${regularity.fullname}', style: Theme.of(context).textTheme.headline.copyWith(fontSize: 16.0),),
      trailing: Text('${NumberFormat.decimalPattern().format(regularity.score)}', style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 20.0, fontWeight: FontWeight.w800),),
      children: <Widget>[
        new Column(
          children: _buildExpandableContent(regularity),
        ),
      ],
    );*/

    return new ListTile(
      leading: new CircleAvatar(child: new Text(regularity.fullname[0])),
      title: new Text('${regularity.fullname}', style: Theme.of(context).textTheme.headline.copyWith(fontSize: 16.0),),
      trailing: Text('${NumberFormat.decimalPattern().format(regularity.score)}', style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 20.0, fontWeight: FontWeight.w800),),
      onTap: () => _displayHistoryDialog(context, regularity.memberId),
    );
  }

  /*_buildExpandableContent(Regularity regularity) {
    List<Widget> columnContent = [];

    for (Map<String, String> content in regularity.history)
      columnContent.add(
        new ListTile(
          title: Text(content['date'], style: const TextStyle(fontSize: 16.0),),
          trailing: Text(content['points']),
        ),
      );

    return columnContent;
  }*/

  Widget _buildContent(BuildContext context) {
    var bodyPage = <Widget>[
      _buildRegularityBackdrop(),
      CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverList(delegate: SliverChildListDelegate(<Widget>[
            _buildHeader(context),
          ])),
          _buildRegularityList(),
          SliverList(delegate: SliverChildListDelegate(<Widget>[
            const SizedBox(height: 132.0),
          ])),
        ],
      ),
      //_buildStatusBarBackground(),
    ];

    return Stack(
      key: contentKey,
      children: bodyPage,
    );
  }

  Widget _buildAddButton(BuildContext context) {
    //print('RegularityList._buildAddButton - Rol: ' + widget.currentUser.toString());
    return (widget.currentUser != null && widget.currentUser.rol == 'Administrador') ? new FloatingActionButton(
      //elevation: 0.0,
        child: new Icon(Icons.plus_one),
        //backgroundColor: new Color(0xFFE57373),
        onPressed: (){
          Navigator.of(context).push(
            new MaterialPageRoute<Null>(
              builder: ( BuildContext context ) => new RegularityAddPage(),
              fullscreenDialog: true
            )
          );
        }
    ) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /*floatingActionButton: new FloatingActionButton(
          //elevation: 0.0,
          child: new Icon(Icons.plus_one),
          //backgroundColor: new Color(0xFFE57373),
          onPressed: (){
            Navigator.push<Null>(
                context, MaterialPageRoute(
                  //builder: (_) => RegularityNew(regularity: widget.regularity, season: widget.season),
                  builder: (_) => RegularityAddPage(),
                  fullscreenDialog: true
              )
            );
          }
      ),*/
      floatingActionButton: _buildAddButton(context),
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
