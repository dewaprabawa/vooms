import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class McachedImage extends StatelessWidget {
  const McachedImage({super.key,
   required this.url,
    this.height, 
    this.width, 
    this.radius,
    this.border
    });
  final String url;
  final double? height;
  final double? width;
  final double? radius;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
          imageUrl: url,
          imageBuilder: (context, imageProvider) => Container(
            height: height ?? 50,
            width: width ?? 50,
            decoration: BoxDecoration(
              border: border,
              borderRadius: BorderRadius.circular(radius ?? 50),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => const Icon(Icons.image),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );
  }
}