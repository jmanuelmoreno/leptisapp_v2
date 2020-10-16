import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/data/models/leptis/season.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/search/search_actions.dart';
import 'package:leptisapp/ui/book_event_details/book_event_page.dart';
import 'package:leptisapp/ui/book_events/book_events_page.dart';
import 'package:leptisapp/ui/drawer/drawer_app.dart';

class MainPage extends StatefulWidget {
  const MainPage();

  static const String routeName = '/home';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  TabController _controller;
  TextEditingController _searchQuery;
  bool _isSearching = false;
  bool _showSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    _searchQuery = TextEditingController();

    _controller.addListener(() {
      setState(() {
        _showSearching = true;
      });
      if(_controller.index == 0) {
        _stopSearching();

        setState(() {
          _showSearching = false;
        });
      }
    });
  }

  void _startSearch() {
    ModalRoute
        .of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQuery.clear();
      _updateSearchQuery(null);
    });
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    /*var subtitle = StoreConnector<AppState, Theater>(
      converter: (store) => store.state.theaterState.currentTheater,
      builder: (BuildContext context, Theater currentTheater) {
        return Text(
          currentTheater?.name ?? '',
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.white70,
          ),
        );
      },
    );*/
    var subtitle = StoreConnector<AppState, Season>(
      converter: (store) => store.state.bookEventState.currentSeason,
      builder: (BuildContext context, Season currentSeason) {
        return Text(
          currentSeason != null ? currentSeason.title : '',
          style: const TextStyle(
            fontSize: 12.0,
            fontStyle: FontStyle.italic,
            color: Colors.white70,
          ),
        );
      },
    );

    return InkWell(
      onTap: () => scaffoldKey.currentState.openDrawer(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            const Text('Calendario \u{00AB}Leptis Utrera\u{00BB}'),
            subtitle,
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Buscar salida...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: _updateSearchQuery,
    );
  }

  void _updateSearchQuery(String newQuery) {
    var store = StoreProvider.of<AppState>(context);
    store.dispatch(SearchQueryChangedAction(newQuery));
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              // Stop searching.
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    var buttons = <Widget>[];
    if(_showSearching) {
      buttons.add(IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ));
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: _buildActions(),
        bottom: TabBar(
          controller: _controller,
          isScrollable: true,
          tabs: const <Tab>[
            const Tab(text: 'Próxima Salida'),
            const Tab(text: 'Calendario de Salidas'),
            const Tab(text: 'Rutas Alternativas'),
          ],
        ),
      ),
      /*drawer: Drawer(
        child: TheaterList(
          header: const leptisappDrawerHeader(),
          onTheaterTapped: () => Navigator.pop(context),
        ),
      ),*/
      drawer: DrawerApp(),
      body: TabBarView(
        controller: _controller,
        children: <Widget>[
          BookEventPage(),
          BookEventsPage(BookEventListType.inSeason),
          BookEventsPage(BookEventListType.inAlternative),
        ],
      ),
    );
  }
}
