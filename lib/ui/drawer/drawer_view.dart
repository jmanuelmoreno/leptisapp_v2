import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:leptisapp/data/models/leptis/leptis_user.dart';
import 'package:leptisapp/redux/leptis/login/auth_state.dart';
import 'package:leptisapp/ui/main_about_page.dart';
import 'package:leptisapp/ui/main_events_page.dart';
import 'package:leptisapp/ui/main_regularity_page.dart';
import 'package:leptisapp/utils/info_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerView extends StatefulWidget {
  static const String routeName = '/material/drawer';

  const DrawerView({
    @required this.status,
    @required this.currentUser,
    this.authOptions,
  });

  final AuthStatus status;
  final LeptisUser currentUser;
  final List<Widget> authOptions;

  @override
  DrawerViewState createState() => new DrawerViewState();
}

class DrawerViewState extends State<DrawerView> with TickerProviderStateMixin {
  static const List<Map<String, dynamic>> _principalItemsMenu =
    <Map<String, dynamic>>[
      {
        'title': 'Eventos',
        'subtitle': 'Excursiones y actividades',
        'icon': Icons.event,
        'routename': MainEventsPage.routeName,
        'auth': false
      },
      {
        'title': 'Regularidad',
        'subtitle': 'Puntos por asistencia',
        'icon': Icons.score,
        'routename': MainRegularityPage.routeName,
        'auth': true
      },
    ];

  static const List<Map<String, dynamic>> _aditionalInfoItemsMenu =
    <Map<String, dynamic>>[
      {
        'title': 'Reglamento',
        'subtitle': 'Reglamento de las salidas',
        'icon': FontAwesomeIcons.gavel,
        'routename': MainAboutPage.routeName,
      },
      {
        'title': 'Siguenos en Facebook',
        'icon': FontAwesomeIcons.facebookSquare,
        'url': 'https://www.facebook.com/leptisutrera/',
      }
    ];

  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;
  bool _showDrawerContents = true;
  Map<String, String> appInfo;

  @override
  void initState() {
    super.initState();

    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _drawerContentsOpacity = new CurvedAnimation(
      parent: new ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = new Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(new CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));

    AppInfo.getAppInfo().then((info){
      appInfo = info;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openUrl(String url) async {
    // Close the about dialog.
    Navigator.pop(context);

    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _openItemMenu(String routeName) async {
    Navigator.pop(context);

    if (routeName.isNotEmpty) {
      Navigator.pushNamed(context, routeName);
    }
  }

  Widget _getAccountHeader(LeptisUser user) {
    Widget accountHeader = const DrawerHeader(child: const Text('No logado'));
      accountHeader = UserAccountsDrawerHeader(
        accountName: Text((user!=null)?widget.currentUser.displayName:'No registrado'),
        accountEmail: Text((user!=null)?widget.currentUser.email:''),
        currentAccountPicture: (user!=null)? CircleAvatar(
          //backgroundImage: new NetworkImage(widget.currentUser.avatarUrl),
          backgroundImage: CachedNetworkImageProvider(widget.currentUser.avatarUrl),
        ) : const CircleAvatar(
          child: Icon(Icons.person_outline),
        ),
        margin: EdgeInsets.zero,
        onDetailsPressed: () {
          _showDrawerContents = !_showDrawerContents;
          if (_showDrawerContents)
            _controller.reverse();
          else
            _controller.forward();
        },
      );
    return accountHeader;
  }

  Widget _aboutContent() {
    final ThemeData theme = Theme.of(context);
    return new AlertDialog(
      content: new Container(
        width: 200.0,
        height: 300.0,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/images/leptis_trans.png", width: 100.0,),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text("Calendario Leptis", style: theme.textTheme.title,),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
              child: Text("Versión ${appInfo[AppInfo.APP_VERSION]}", style: theme.textTheme.caption,),
            ),
            const Text("Calendario de salidas para la Asociación Cicloecologísta 'Legiones de Leptis'.", textAlign: TextAlign.center,),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                color: Colors.orangeAccent,
                child: const Text("Puntúa esta aplicación"),
                onPressed: () {  },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showAbout(){
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (_) => _aboutContent()
    );
  }

  Widget _buildItemMenu(Map<String, dynamic> item) {
    return (item['auth'] == null || !item['auth'] || (item['auth'] && widget.currentUser != null)) ?
      ListTile(
        leading: (item['icon'] != null) ? Icon(item['icon']) : null,
        title: Text(item['title']),
        subtitle: (item['subtitle'] != null) ? Text(item['subtitle']) : null,
        onTap: () {
          if(item['routename'] != null) _openItemMenu(item['routename']);
          if(item['url'] != null) _openUrl(item['url']);
        },
      ) : null;
  }

  List<Widget> _buildDrawerContents() {
    List<Widget> itemsMenu = [];

    List<Widget> principalItems = new List.from(
      _principalItemsMenu.map((Map<String, dynamic> content) {
        return _buildItemMenu(content);
      }).toList());
    principalItems.removeWhere((item) => item == null);

    List<Widget> aditionalInfoItems = new List.from(
      _aditionalInfoItemsMenu.map((Map<String, dynamic> content) {
        return _buildItemMenu(content);
      }).toList());
    aditionalInfoItems.removeWhere((item) => item == null);

    itemsMenu
      ..add(ListTile(
        leading: const Icon(FontAwesomeIcons.bookOpen),
        title: const Text('Calendario'),
        subtitle: const Text('Calendario de salidas'),
        onTap: () => Navigator.pop(context),
      ))
      ..addAll(principalItems)
      ..add(const Divider())
      ..add(const ListTile(
        title: const Text('Información adicional'),
      ))
      ..addAll(aditionalInfoItems)
      ..add(ListTile(
        leading: const Icon(Icons.info_outline),
        title: const Text('Información'),
        onTap: () => _showAbout(),
      ));

    return itemsMenu;
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new Column(
        children: <Widget>[
          _getAccountHeader(widget.currentUser),
          new MediaQuery.removePadding(
            context: context,
            // DrawerHeader consumes top MediaQuery padding.
            removeTop: true,
            child: new Expanded(
              child: new ListView(
                padding: const EdgeInsets.only(top: 8.0),
                children: <Widget>[
                  new Stack(
                    children: <Widget>[
                      // The initial contents of the drawer.
                      new FadeTransition(
                        opacity: _drawerContentsOpacity,
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _buildDrawerContents(),
                        ),
                      ),
                      // The drawer's "details" view.
                      new SlideTransition(
                        position: _drawerDetailsPosition,
                        child: new FadeTransition(
                          opacity: new ReverseAnimation(_drawerContentsOpacity),
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: widget.authOptions,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}