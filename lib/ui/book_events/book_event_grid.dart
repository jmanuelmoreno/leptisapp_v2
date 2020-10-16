import 'package:flutter/material.dart';
import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/ui/book_event_details/book_event_details_page.dart';
import 'package:leptisapp/ui/book_events/book_event_grid_item.dart';
import 'package:leptisapp/ui/common/info_message_view.dart';
import 'package:meta/meta.dart';

class BookEventGrid extends StatelessWidget {
  static const Key emptyViewKey = const Key('emptyView');
  static const Key contentKey = const Key('content');

  BookEventGrid({
    @required this.bookEvents,
    @required this.onReloadCallback,
  });

  final List<BookEvent> bookEvents;
  final VoidCallback onReloadCallback;

  void _openBookEventDetails(BuildContext context, BookEvent bookEvent) {
    Navigator.push<Null>(
      context,
      MaterialPageRoute(
        builder: (_) => BookEventDetailsPage(bookEvent: bookEvent, onReloadCallback: onReloadCallback),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    //var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    //var crossAxisChildCount = isPortrait ? 1 : 4;

    /*return Container(
      key: contentKey,
      //color: const Color(0xFF222222),
      color: Colors.black12,
      child: Scrollbar(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisChildCount,
            childAspectRatio: 1.65 / 1,
          ),
          itemCount: bookEvents.length,
          itemBuilder: (BuildContext context, int index) {
            var bookEvent = bookEvents[index];
            return BookEventGridItem(
              bookEvent: bookEvent,
              onTapped: () => _openBookEventDetails(context, bookEvent),
            );
          },
        ),
      ),
    );*/

    return new ListView(
      itemExtent: BookEventGridItem.height,
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      children: bookEvents.map((BookEvent bookEvent) {
        return new Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: new BookEventGridItem(
            bookEvent: bookEvent,
            onTapped: () => _openBookEventDetails(context, bookEvent),
          ),
        );
      }).toList()
    );
  }

  @override
  Widget build(BuildContext context) {
    if (bookEvents.isEmpty) {
      return InfoMessageView(
        key: emptyViewKey,
        title: 'Todo vacío!',
        description: 'No encuentro ninguna ruta. ¯\\_(ツ)_/¯',
        onActionButtonTapped: onReloadCallback,
      );
    }

    return _buildContent(context);
  }
}
