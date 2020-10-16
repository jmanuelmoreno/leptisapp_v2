import 'package:flutter/material.dart';
import 'package:leptisapp/assets.dart';
import 'package:leptisapp/data/models/leptis/book_event.dart';

class PhotoScroller extends StatelessWidget {
  PhotoScroller(this.bookEvent);
  final BookEvent bookEvent;

  Widget _buildPhoto(BuildContext context, int index) {
    var photo = bookEvent.photoUrls[index];

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: FadeInImage.assetNetwork(
          placeholder: ImageAssets.transparentImage,
          image: photo,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 250),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //var textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const Text(
            'Fotos',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox.fromSize(
          size: const Size.fromHeight(100.0),
          child: ListView.builder(
            itemCount: bookEvent.photoUrls.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 8.0, left: 20.0),
            itemBuilder: _buildPhoto,
          ),
        ),
      ],
    );
  }
}