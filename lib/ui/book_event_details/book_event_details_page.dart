import 'package:flutter/material.dart';
import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/ui/book_event_details/book_event_backdrop_photo.dart';
import 'package:leptisapp/ui/book_event_details/book_event_details_scroll_effects.dart';
import 'package:leptisapp/ui/book_event_details/book_event_routedetails_widget.dart';
import 'package:leptisapp/ui/book_event_details/escort_scroller.dart';
import 'package:leptisapp/ui/book_event_details/map_widget.dart';
import 'package:leptisapp/ui/book_event_details/photo_scroller.dart';
import 'package:leptisapp/ui/book_event_details/routetime_information.dart';
import 'package:leptisapp/ui/book_event_details/weather_widget.dart';
import 'package:leptisapp/ui/common/info_message_view.dart';
import 'package:leptisapp/utils/clock.dart';
import 'package:leptisapp/utils/widget_utils.dart';
import 'package:intl/intl.dart';

class BookEventDetailsPage extends StatefulWidget {
  BookEventDetailsPage({
    @required this.bookEvent,
    @required this.onReloadCallback,
    this.showBackButton = true
  });
  final BookEvent bookEvent;
  final VoidCallback onReloadCallback;
  final bool showBackButton;

  @override
  _BookEventDetailsPageState createState() => _BookEventDetailsPageState();
}

class _BookEventDetailsPageState extends State<BookEventDetailsPage> {
  static const Key emptyViewKey = const Key('emptyView');
  static const Key contentKey = const Key('content');

  static const double backdrop_height = 200.0;

  ScrollController _scrollController;
  BookEventDetailsScrollEffects _scrollEffects;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _scrollEffects = BookEventDetailsScrollEffects();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    setState(() {
      _scrollEffects.updateScrollOffset(context, _scrollController.offset);
    });
  }

  Widget  _buildHeader(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Transparent container that makes the space for the backdrop photo.
        Container(
          height: backdrop_height,
          //margin: const EdgeInsets.only(bottom: 118.0),
          //margin: const EdgeInsets.only(bottom: 55.0),
        ),
      ],
    );
  }

  /*Widget _buildPortraitPhoto() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: BookEventPoster(
        bookEvent: widget.bookEvent,
        size: const Size(100.0, 150.0),
        displayPlayButton: true,
      ),
    );
  }*/

  Widget _buildEventTitle() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12.0,
        bottom: 12.0,
        left: 16.0,
        right: 10.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: _buildBookEventInfo(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0),
            child: WeatherWidget(
              bookEvent: widget.bookEvent,
              size: 48.0,
              onWeatherTapped: () => {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookEventInfo() {
    var content = <Widget>[]..addAll(
        _buildTitleAndRouteInfo(),
      );

    /*if (widget.bookEvent.authors.isNotEmpty) {
      content.add(Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: _buildAuthorInfo(),
      ));
    }*/

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: content,
    );
  }

  List<Widget> _buildTitleAndRouteInfo() {
    var eventDay = (widget.bookEvent.eventDay != null) ? '${Clock.getDefaultDateTimeFormatted(widget.bookEvent.eventDay)} | ' : '';
    var routeHardness = "Dificultad: ${widget.bookEvent.hardness}";
    var routeDistance = widget.bookEvent.hasDistance ? " | Distancia: ${NumberFormat.decimalPattern().format(widget.bookEvent.distance)} Kms" : "";

    return <Widget>[
      Text(
        widget.bookEvent.title,
        style: const TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 8.0),
      Text(
        "$eventDay$routeHardness$routeDistance",
        style: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    ];
  }

  /*Widget _buildAuthorInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Autor:',
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 4.0),
        Expanded(
          child: Text(
            widget.bookEvent.authors.first,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }*/

  Widget _buildShowtimeInformation() {
    if (widget.bookEvent.start != null) {
      return Padding(
        padding: const EdgeInsets.only(
          bottom: 8.0,
          left: 16.0,
          right: 16.0,
        ),
        child: BookEventTimeInformation(widget.bookEvent),
      );
    }
    return null;
  }

  Widget _buildRouteDetails() {
    if (widget.bookEvent.hasRouteDetails) {
      return Padding(
        //padding: EdgeInsets.only(top: widget.show == null ? 12.0 : 0.0),
        padding: const EdgeInsets.only(top: 0.0),
        child: BookEventRouteDetailsWidget(widget.bookEvent),
      );
    }
    return null;
  }

  Widget _buildRouteMap() {
    if (widget.bookEvent.hasRouteMap) {
      return Padding(
        padding: const EdgeInsets.only(top: 0.0),
        //child: BookEventMapWidget(widget.bookEvent, height: 200.0),
        child: MapWidget(widget.bookEvent, height: 200.0),
      );
    }
    return null;
  }

  Widget _buildEscortScroller() => widget.bookEvent.eventDay != null ?
    EscortScroller(widget.bookEvent) : null;

  Widget _buildPhotoScroller() =>
      widget.bookEvent.hasPhotos ? PhotoScroller(widget.bookEvent) : null;

  Widget _buildBookEventBackdrop() {
    return Positioned(
      top: _scrollEffects.headerOffset,
      child: BookEventBackdropPhoto(
        bookEvent: widget.bookEvent,
        height: _scrollEffects.backdropHeight,
        overlayBlur: _scrollEffects.backdropOverlayBlur,
        blurOverlayOpacity: _scrollEffects.backdropOverlayOpacity,
      ),
      //child: ArcBannerImage(widget.bookEvent.coverUrl),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 4.0,
      child: IgnorePointer(
        ignoring: _scrollEffects.backButtonOpacity == 0.0,
        child: Material(
          type: MaterialType.circle,
          color: Colors.transparent,
          child: BackButton(
            color: Colors.white.withOpacity(
              _scrollEffects.backButtonOpacity * 0.9,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBarBackground() {
    var statusBarColor = Theme.of(context).primaryColor;

    return Container(
      height: _scrollEffects.statusBarHeight,
      color: statusBarColor,
    );
  }

  Widget _buildContent(BuildContext context) {
    var content = <Widget>[
      _buildHeader(context),
    ];

    addIfNonNull(_buildEventTitle(), content);
    addIfNonNull(_buildShowtimeInformation(), content);
    addIfNonNull(_buildRouteDetails(), content);
    addIfNonNull(_buildRouteMap(), content);
    addIfNonNull(_buildPhotoScroller(), content);
    addIfNonNull(_buildEscortScroller(), content);

    // Some padding for the bottom.
    content.add(const SizedBox(height: 132.0));

    var bodyPage = <Widget>[
      _buildBookEventBackdrop(),
      CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverList(delegate: SliverChildListDelegate(content)),
        ],
      ),
      _buildStatusBarBackground(),
    ];
    if (widget.showBackButton) {
      bodyPage.add(_buildBackButton());
    }

    return Stack(
      children: bodyPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: (widget.bookEvent == null) ?
        InfoMessageView(
          key: emptyViewKey,
          title: 'Todo vacío!',
          description: 'No encuentro ninguna ruta. ¯\\_(ツ)_/¯',
          onActionButtonTapped: widget.onReloadCallback,
        )
      :
        _buildContent(context)
    );
  }
}
