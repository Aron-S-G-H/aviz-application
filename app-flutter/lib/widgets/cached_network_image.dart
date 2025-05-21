import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget cachedNetworkImage(String imageUrl, [double radius=0, BoxFit? fit=BoxFit.cover]) {
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(radius)),
    child: CachedNetworkImage(
      fit: fit,
      imageUrl: imageUrl,
      errorWidget: (context, url, error) => Container(color: Colors.red[100]),
      placeholder: (context, url) => Container(color: Colors.grey),
    ),
  );
}
