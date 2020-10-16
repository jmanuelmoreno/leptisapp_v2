import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/here_config.dart';
import 'package:leptisapp/utils/maps_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';


class BookEventMapPage extends StatefulWidget {
  BookEventMapPage(
      this.bookEvent,
      );

  final BookEvent bookEvent;

  @override
  _BookEventMapPageState createState() => _BookEventMapPageState();
}

class _BookEventMapPageState extends State<BookEventMapPage> with TickerProviderStateMixin {
  // Note the addition of the TickerProviderStateMixin here. If you are getting an error like
  // 'The class 'TickerProviderStateMixin' can't be used as a mixin because it extends a class other than Object.'
  // in your IDE, you can probably fix it by adding an analysis_options.yaml file to your project
  // with the following content:
  //  analyzer:
  //    language:
  //      enableSuperMixins: true
  // See https://github.com/flutter/flutter/issues/14317#issuecomment-361085869
  // This project didn't require that change, so YMMV.

  final Logger log = new Logger('_BookEventMapPageState');

  LatLng _currentLocation;
  StreamSubscription<Position> _locationSubscription;

  Polyline _track;
  MapController _mapController;
  LatLngBounds _trackBounds = new LatLngBounds();
  String _currentMapLayer = choices.first.url;

  @override
  void initState() {
    log.fine('_BookEventMapPageState.initState - Start');

    super.initState();
    _mapController = new MapController();

    initMapState(); // Inicializamos mapa
    initPlatformState(); // Inicializamos GPS
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }

    super.dispose();
    _mapController = null;
    _locationSubscription = null;
  }

  // Load map is asynchronous, so we initialize in an async method.
  initMapState() async {
    log.fine('_BookEventMapPageState.initMapState - Start');

    // Carga ruta gpx
    List<Polyline> tracks = await MapsUtil.loadGpx_v2(widget.bookEvent.routeMapUrl);
    setState(() {
      _track = tracks[0];
    });

    // Inicializamos bounds del track
    _track.points.forEach((LatLng point){
      _trackBounds.extend(point);
    });

    // Centramos mapa
    _fitBounds(_trackBounds);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    log.fine('_BookEventMapPageState.initPlatformState - Start');

    try {
      Position _position = await Geolocator().getLastKnownPosition();
      if(_position != null) {
        debugPrint("getLastKnownPosition: ${_position.toString()}");
        setState(() {
          _currentLocation = new LatLng(_position.latitude, _position.longitude);
        });
      }

      _locationSubscription = Geolocator().getPositionStream(LocationOptions(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 2))
          .listen((Position position) {
        if (position != null) {
          debugPrint("getPositionStream: ${position.toString()}");
          setState(() {
            _currentLocation = new LatLng(position.latitude, position.longitude);
          });
        }
      });
    } on PlatformException catch (e) {
      log.warning("Error al inicializar suscripción al GPS.", e);
    }
  }

  void _animatedMapMove (LatLng destLocation, double destZoom) {
    log.fine('_BookEventMapPageState._animatedMapMove - Start');

    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = new Tween<double>(begin: _mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = new Tween<double>(begin: _mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = new Tween<double>(begin: _mapController.zoom, end: destZoom);

    // Create a new animation controller that has a duration and a TickerProvider.
    AnimationController controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =  CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      // Note that the mapController.move doesn't seem to like the zoom animation. This may be a bug in flutter_map.
      _mapController.move(LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)), _zoomTween.evaluate(animation));
      //print("Location (${_latTween.evaluate(animation)} , ${_lngTween.evaluate(animation)}) @ zoom ${_zoomTween.evaluate(animation)}");
    });

    animation.addStatusListener((status) {
      print("$status");
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void _fitBounds(LatLngBounds bounds) {
    log.fine('_BookEventMapPageState._fitBounds - Start');

    _mapController.fitBounds(
      bounds,
      options: new FitBoundsOptions(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        maxZoom: 12.0
      ),
    );
  }

  _gotoPosition() async {
    log.fine('_BookEventMapPageState._gotoPosition - Start');

    Position _position;
    try {
      _position = await Geolocator().getCurrentPosition();
    } on PlatformException catch (e) {
      log.warning("BookEventMapPage._gotoPosition() - No se ha podido obtener la posicion actual", e);
    }

    if(_position != null) {
      _animatedMapMove(new LatLng(_position.latitude, _position.longitude), 15.5);
    }
  }

  _fitMap() async {
    log.fine('_BookEventMapPageState._fitMap - Start');

    Position _position;
    try {
      _position = await Geolocator().getCurrentPosition();
    } on PlatformException catch (e) {
      log.warning("BookEventMapPage._fitMap() - No se ha podido obtener la posicion actual", e);
    }

    if(_position != null) {
      LatLngBounds trackBounds = _trackBounds;
      trackBounds.extend(new LatLng(_position.latitude, _position.longitude)); // Añadimos posicion actual al bounds

      // Centramos mapa
      _fitBounds(trackBounds);
    }
  }

  _selectLayerMap(String url) {
    log.fine('_BookEventMapPageState._selectLayerMap - Start');

    setState(() {
      _currentMapLayer = url;
    });
  }

  Widget build(BuildContext context) {
    log.fine('_BookEventMapPageState.build - Start');

    var _mapMarkers = <Marker>[];
    var _mapPolylines = <Polyline>[];

    if(_currentLocation != null) {
      _mapMarkers = [
        new Marker(
          width: 40.0,
          height: 40.0,
          point: _currentLocation,
          /*builder: (ctx) => new Transform.rotate(
            angle: ((_currentDirection ?? 0) * (math.pi / (180))),
            child: new Container(
              child: Icon(FontAwesomeIcons.locationArrow, color: Colors.blue, size: 30.0,),
            )
          ),*/
          builder: (ctx) =>
          new Container(
            child: Icon(
              FontAwesomeIcons.mapMarker, color: Colors.blue, size: 30.0,),
          ),
        )
      ];
    }

    if(_track != null){
      _mapPolylines.clear();
      _mapPolylines.add(_track);
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.bookEvent.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () {
              _gotoPosition();
            },
          ),
          IconButton(
            icon: Icon(Icons.center_focus_strong),
            onPressed: () {
              _fitMap();
            },
          ),
          PopupMenuButton<Choice>(
            icon: Icon(Icons.layers),
            onSelected: (Choice choice) => _selectLayerMap(choice.url),
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: new Padding(
          padding: new EdgeInsets.all(0.0),
          child: new Column(
            children: [
              new Flexible(
                child: new Stack(
                  children: <Widget>[
                    new FlutterMap(
                      mapController: _mapController,
                      options: new MapOptions(
                        center: new LatLng(51.5, -0.09),
                        zoom: 5.0,
                        //maxZoom: 5.0,
                        minZoom: 3.0,
                      ),
                      layers: [
                        new TileLayerOptions(
                            urlTemplate: "$_currentMapLayer",
                            subdomains: ['1', '2', '3']),
                        //_tileLayer,
                        new PolylineLayerOptions(polylines: _mapPolylines),
                        new MarkerLayerOptions(markers: _mapMarkers),
                      ],
                    ),
                    /*Positioned(
                      bottom: 20.0,
                      right: 20.0,
                      child: RaisedButton.icon(
                        label: Text('Posicionar'),
                        icon: Icon(Icons.center_focus_strong),
                        onPressed: () {
                          _gotoPosition();
                        },
                      ),
                    ),*/
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon, this.url});

  final String title;
  final IconData icon;
  final String url;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Normal', url: HEREConfig.normalMapUrl),
  const Choice(title: 'Satélite', url: HEREConfig.satelliteMapUrl),
  const Choice(title: 'Híbrido', url: HEREConfig.hybridMapUrl),
];
