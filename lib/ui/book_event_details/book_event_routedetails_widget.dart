import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:leptisapp/data/models/leptis/book_event.dart';

class BookEventRouteDetailsWidget extends StatefulWidget {
  BookEventRouteDetailsWidget(this.bookEvent);
  final BookEvent bookEvent;

  @override
  _BookEventRouteDetailsWidgetState createState() => _BookEventRouteDetailsWidgetState();
}

class _BookEventRouteDetailsWidgetState extends State<BookEventRouteDetailsWidget> {
  bool _isExpandable;
  bool _isExpanded = false;

  int maxlengthRouteline = 350;

  @override
  void initState() {
    super.initState();
    _isExpandable = widget.bookEvent.routeline.length > maxlengthRouteline;
  }

  void _toggleExpandedState() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  Widget _buildCaption() {
    var content = <Widget>[
      const Text(
        'Recorrido',
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    ];

    if (_isExpandable) {
      content.add(Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: _buildExpandCollapsePrompt(),
      ));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: content,
    );
  }

  Widget _buildExpandCollapsePrompt() {
    const captionStyle = const TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w600,
      color: Colors.black54,
    );

    if (_isExpanded) {
      return const Text('[toca para contraer]', style: captionStyle);
    }

    return const Text('[toca para expandir]', style: captionStyle);
  }

  Widget _buildContent() {
    var longText = widget.bookEvent.routeline;
    var shortText = (longText.length > maxlengthRouteline) ? "${longText.substring(0, maxlengthRouteline)} ..." : longText;

    return AnimatedCrossFade(
      /*firstChild: Text("${widget.bookEvent.routeline.substring(0, maxlength_routeline)} ..."),
      secondChild: Text(widget.bookEvent.routeline),*/
      firstChild: MarkdownBody(data: shortText),
      secondChild: MarkdownBody(data: longText),
      crossFadeState:
          _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: kThemeAnimationDuration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _isExpandable ? _toggleExpandedState : null,
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
