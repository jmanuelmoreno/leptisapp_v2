import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gpx/gpx.dart';
import 'package:latlong/latlong.dart';
import 'package:logging/logging.dart';
import 'package:xml/xml.dart' as xml;
import 'package:leptisapp/utils/leafletjs_utils.dart';

abstract class MapsUtil {

  ///
  /// Load GPX file
  ///

  static Future<List<Polyline>> loadGpx(String gpx) async {
    final Logger log = new Logger('MapsUtil');
    log.fine('MapsUtil.loadGpx - Start');

    String xmlString;
    try {
      xmlString = await rootBundle.loadString(gpx);
    } catch (err) {
      print("MapsUtil.loadGpx - ERROR: Recurso '$gpx' no existe.");
      return null;
    }
    var document = xml.parse(xmlString);

    List<Polyline> polylines = document.findAllElements('trk').map((trksegNode) {
      List<LatLng> points = trksegNode.findAllElements('trkpt').map((trkptNode) {
        var lat = trkptNode.getAttribute('lat');
        var lon = trkptNode.getAttribute('lon');
        return LatLng(double.parse(lat), double.parse(lon));
      }).toList();

      //String number = trkseg_node.findElements('number').elementAt(0).text;
      //print("Track ${number}: ${points.toString()}");

      return new Polyline(
          points: points,
          strokeWidth: 4.0,
          color: Colors.blue);
    }).toList();

    return polylines;
  }

  static Future<List<Polyline>> loadGpx_v2(String gpx) async {
    final Logger log = new Logger('MapsUtil');
    log.fine('MapsUtil.loadGpx_v2 - Start');

    List<Polyline> polylines = new List<Polyline>();
    try {
      String gpxString = await rootBundle.loadString(gpx);

      var xmlGpx = GpxReader().fromString(gpxString);

      List<LatLng> points = xmlGpx.trks[0].trksegs[0].trkpts.map((trkpt) {
        return LatLng(trkpt.lat, trkpt.lon);
      }).toList();

      polylines.add(new Polyline(
          points: points,
          strokeWidth: 4.0,
          color: Colors.blue));
    } catch (err) {
      log.severe('MapsUtil.loadGpx_v2 - ERROR: $err');
      return null;
    }

    return polylines;
  }


  ///
  /// MapQuest Static Map
  ///
  static Future<String> staticMapUrl(String gpxUrl,
      {double width = 600.0, double height = 200.0}) async {
    final Logger log = new Logger('MapsUtil');
    log.fine('MapsUtil.staticMapUrl - Start');

    final String mapquestApiKey = "GRfwLTXvbZzAwls2UAG7MJXHSlD92NmV";
    final Uri mapquestBaseUrl = new Uri.https(
        'www.mapquestapi.com', '/staticmap/v5/map');

    List<Polyline> polyline = await loadGpx(gpxUrl);

    if(polyline == null) return null;

    List<LatLng> points = [];
    polyline.forEach((pl) {
      points.addAll(pl.points);
    });

    var polylineStr = PolylineUtil.encode(points);
    return mapquestBaseUrl.replace(queryParameters: <String, String>{
      'key': mapquestApiKey,
      'type': 'map',
      'shape': 'cmp|enc:$polylineStr',
      'size': '${width.round()},${height.round()}',
    }).toString();
  }
}