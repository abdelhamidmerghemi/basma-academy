import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../network/api_client.dart';
import '../theme/theme_config.dart';

class CustomProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final File? localFile;
  final String? name;
  final double radius;
  final Color? backgroundColor;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool showBorder;

  const CustomProfileAvatar({
    super.key,
    this.avatarUrl,
    this.localFile,
    this.name,
    this.radius = 24.0,
    this.backgroundColor,
    this.iconColor,
    this.onTap,
    this.showBorder = false,
  });

  /// Resolves relative image path to full URL
  String? get _resolvedUrl {
    if (avatarUrl == null || avatarUrl!.trim().isEmpty) return null;
    final url = avatarUrl!.trim();
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    final baseDomain = ApiClient.baseUrl.replaceAll('/api', '');
    return url.startsWith('/') ? '$baseDomain$url' : '$baseDomain/$url';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = radius * 2;

    final resolved = _resolvedUrl;

    Widget avatarContent;

    if (localFile != null && localFile!.existsSync()) {
      avatarContent = Image.file(
        localFile!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallback(isDark),
      );
    } else if (resolved != null) {
      avatarContent = Image.network(
        resolved,
        width: size,
        height: size,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildFallback(isDark);
        },
        errorBuilder: (context, error, stackTrace) => _buildFallback(isDark),
      );
    } else {
      avatarContent = _buildFallback(isDark);
    }

    Widget result = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size,
        height: size,
        child: avatarContent,
      ),
    );

    if (showBorder) {
      result = Container(
        padding: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [ThemeConfig.primaryColor, ThemeConfig.secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: result,
        ),
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: result,
      );
    }

    return result;
  }

  Widget _buildFallback(bool isDark) {
    // Premium iOS style fallback: crisp white person icon on slate background
    final bg = backgroundColor ?? (isDark ? const Color(0xFF334155) : const Color(0xFF94A3B8));
    final icColor = iconColor ?? Colors.white;

    return Container(
      width: radius * 2,
      height: radius * 2,
      alignment: Alignment.center,
      color: bg,
      child: Icon(
        CupertinoIcons.person_fill,
        size: radius * 1.15,
        color: icColor,
      ),
    );
  }
}
