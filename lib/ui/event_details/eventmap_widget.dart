import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:leptisapp/data/models/leptis/event.dart';

class DirectionMapWidget extends StatefulWidget {
  DirectionMapWidget(this.event);
  final Event event;

  @override
  _DirectionMapWidgetState createState() => _DirectionMapWidgetState();
}

class _DirectionMapWidgetState extends State<DirectionMapWidget> {

  @override
  void initState() {
    super.initState();
  }

  Widget _buildCaption() {
    var content = <Widget>[
      /*const Text(
        'Dirección',
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
        ),
      ),*/
      Expanded(
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.location_on,
              color: Colors.black87,
            ),
            const SizedBox(width: 8.0),
            const Text(
              'Ubicación',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      )
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: content,
    );
  }

  Widget _buildContent() {
    /*return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _launchMaps,
        child: Text(widget.event.direction),
      ),
    );*/
    return MarkdownBody(data: widget.event.direction);
  }

  /*_launchMaps() async {
    String googleUrl =
        'comgooglemaps://?q=centurylink+field';
    String appleUrl =
        'https://maps.apple.com/?sll=';
    if (await canLaunch("comgooglemaps://")) {
      print('launching com googleUrl');
      await launch(googleUrl);
    } else if (await canLaunch(appleUrl)) {
      print('launching apple url');
      await launch(appleUrl);
    } else {
      throw 'Could not launch url';
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildCaption(),
            const SizedBox(height: 8.0),
            _buildContent(),
          ],
        ),
      ),
    );
  }
}
