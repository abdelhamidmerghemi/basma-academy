import 'package:flutter/material.dart';
import '../network/api_client.dart';

class SmartImage extends StatelessWidget {
  final String? imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final BorderRadius? borderRadius;

  const SmartImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.borderRadius,
  });

  String? get _resolvedUrl {
    if (imagePath == null || imagePath!.trim().isEmpty) return null;
    final path = imagePath!.trim();
    if (path.startsWith('assets/')) return path;
    if (path.startsWith('http://') || path.startsWith('https://')) return path;

    final baseDomain = ApiClient.baseUrl.replaceAll('/api', '');
    return path.startsWith('/') ? '$baseDomain$path' : '$baseDomain/$path';
  }

  @override
  Widget build(BuildContext context) {
    final resolved = _resolvedUrl;
    final fallback = placeholder ??
        Container(
          width: width,
          height: height,
          color: Theme.of(context).dividerColor.withOpacity(0.1),
          child: Icon(
            Icons.image_not_supported_rounded,
            color: Theme.of(context).disabledColor,
            size: 24,
          ),
        );

    if (resolved == null) return fallback;

    Widget imageWidget;

    if (resolved.startsWith('assets/')) {
      imageWidget = Image.asset(
        resolved,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    } else {
      imageWidget = Image.network(
        resolved,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
