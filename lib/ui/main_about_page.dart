import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:leptisapp/assets.dart';

class MainAboutPage extends StatefulWidget {
  static const String routeName = '/about';

  const MainAboutPage();

  @override
  _MainAboutPageState createState() => _MainAboutPageState();
}

class _MainAboutPageState extends State<MainAboutPage> {
  String _aboutText = "";

  @override
  void initState() {
    super.initState();
  }

  Future<Null> _getAboutText() async {
    rootBundle.loadString(OtherAssets.preloadedAboutText).then((txt){
      setState(() {
        _aboutText = txt;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _getAboutText();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Reglamento"),
        ),
        body: Markdown(data: _aboutText)
    );
  }
}
