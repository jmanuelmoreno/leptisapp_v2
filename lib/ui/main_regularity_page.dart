import 'package:flutter/material.dart';
import 'package:leptisapp/ui/regularity/regularity_page.dart';

class MainRegularityPage extends StatefulWidget {
  const MainRegularityPage();

  static const String routeName = '/regularity';

  @override
  _MainRegularityPageState createState() => _MainRegularityPageState();
}

class _MainRegularityPageState extends State<MainRegularityPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regularidad'),
      ),
      body:  RegularityPage(),
    );
  }
}
