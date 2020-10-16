import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/here_config.dart';
import 'package:leptisapp/ui/book_event_details/book_event_map_page.dart';
import 'package:leptisapp/utils/widget_utils.dart';
import 'package:leptisapp/utils/maps_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';


class MapWidget extends StatelessWidget {
  MapWidget(this.bookEvent, {this.height = 200.0});
  final BookEvent bookEvent;
  final double height;

  @override
  Widget build(BuildContext context) {
    return MapWidgetContent(bookEvent, height);
  }
}

class MapWidgetContent extends StatelessWidget {
  const MapWidgetContent(this.bookEvent, this.height);
  final BookEvent bookEvent;

  final double height;

  Widget _buildCaption() {
    var content = <Widget>[
      const Text(
        'Ruta',
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: content,
    );
  }

  Widget _buildImageWithPlaceholder(BuildContext context) {
    var content = <Widget>[
      _buildPlaceholderBackground(context),
    ];

    addIfNonNull(_buildBackdropPhoto(context), content);

    return Stack(
      alignment: Alignment.center,
      children: content,
    );
  }

  Widget _buildPlaceholderBackground(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      child: const Center(
        child: const Icon(
          Icons.map,
          color: Colors.white30,
          size: 96.0,
        ),
      ),
    );
  }

  Future<String> _getMapCoverUrl(BookEvent bookEvent, double width, double height) async {
    String route = "";

    List<Polyline> track = await MapsUtil.loadGpx_v2(bookEvent.routeMapUrl);
    track[0].points.forEach((pt){
      route += '${pt.latitude.toString()},${pt.longitude.toString()},';
    });

    return "${HEREConfig.staticMapUrl}&w=${width.toInt()}&h=${height.toInt()}&lc0=2196F3&r0=$route";
  }

  Widget _buildBackdropPhoto(BuildContext context) {
    if (bookEvent.hasRouteMap) {
      var screenWidth = MediaQuery.of(context).size.width;
      return new FutureBuilder(
        future: _getMapCoverUrl(bookEvent, screenWidth, height),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print("data=${snapshot.data}");
            if (snapshot.data!=null) {
              return SizedBox(
                child: CachedNetworkImage(
                  placeholder: (context, url) => CircularProgressIndicator(),
                  imageUrl: snapshot.data,
                  width: screenWidth,
                  fadeInDuration: const Duration(milliseconds: 150),
                  fit: BoxFit.fill,
                ),
              );
            } else {
              return new Container();
            }
          } else {
            return new CircularProgressIndicator();
          }
        }
      );
    }

    return null;
  }

  Widget _buildContent(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: screenWidth,
      child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildCaption(),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: _buildImageWithPlaceholder(context),
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.push<Null>(
                  context, MaterialPageRoute(
                    builder: (_) => BookEventMapPage(bookEvent),
                    fullscreenDialog: true
                  ),
                ),
                child: Container(),
              ),
            ),
          ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }
}
