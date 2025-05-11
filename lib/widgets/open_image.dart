
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ChatImageWidget extends StatelessWidget {
  final String imageUrl;

  const ChatImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullScreenImageViewer(imageUrl: imageUrl),
          ),
        );
      },
      child: Hero(
        tag: imageUrl,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            height: 200,
            width: 150,
            fit: BoxFit.cover,
            progressIndicatorBuilder:
                (context, url, progress) => Center(
                  child: CircularProgressIndicator(value: progress.progress),
                ),
            errorWidget:
                (context, url, error) => const Icon(Icons.broken_image),
          ),
        ),
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta! > 20) {
            Navigator.pop(context);
          }
        },
        child: Center(
          child: Hero(
            tag: imageUrl,
            child: PhotoView(
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              imageProvider: CachedNetworkImageProvider(imageUrl),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
