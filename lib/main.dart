import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/common_actions.dart';
import 'package:leptisapp/redux/store.dart';
import 'package:leptisapp/ui/main_about_page.dart';
import 'package:leptisapp/ui/main_events_page.dart';
import 'package:leptisapp/ui/main_page.dart';
import 'package:leptisapp/ui/main_regularity_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';

Future<Null> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  //logger
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  // Default locale
  Intl.defaultLocale = "es_ES";
  await initializeDateFormatting("es_ES");

  var store = await createStore();
  runApp(LeptisApp(store));
}

class LeptisApp extends StatefulWidget {
  LeptisApp(this.store);
  final Store<AppState> store;

  @override
  _LeptisAppState createState() => _LeptisAppState();
}

class _LeptisAppState extends State<LeptisApp> {
  final Logger log = new Logger('_LeptisAppState');

  @override
  void initState() {
    log.fine('Default Locale: ${Intl.defaultLocale}');

    super.initState();
    widget.store.dispatch(InitAction());
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
      child: MaterialApp(
        title: 'Calendario de Salidas Leptis',
        theme: ThemeData(
          primaryColor: const Color(0xFF33691e),
          accentColor: const Color(0xFFFFAD32),
        ),
        routes: {
          MainPage.routeName: (context) => const MainPage(),
          MainRegularityPage.routeName: (context) => const MainRegularityPage(),
          MainEventsPage.routeName: (context) => const MainEventsPage(),
          MainAboutPage.routeName: (context) => const MainAboutPage(),
        },
        home: const MainPage(),
      ),
    );
  }
}
