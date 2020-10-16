import 'package:flutter/material.dart';
import 'package:leptisapp/ui/events/event_page.dart';

class MainEventsPage extends StatefulWidget {
  const MainEventsPage();

  static const String routeName = '/events';

  @override
  _MainEventsPageState createState() => _MainEventsPageState();
}

class _MainEventsPageState extends State<MainEventsPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos y Actividades'),
      ),
      body:  EventPage(),
    );
  }
}
