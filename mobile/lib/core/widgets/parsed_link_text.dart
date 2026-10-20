import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/theme_config.dart';

/// A widget that parses text and highlights URLs and @usernames with the primary color.
/// It enables URL launching, custom mention tapping, and dynamic RTL/LTR support.
class ParsedLinkText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final Function(String username)? onMentionTap;

  const ParsedLinkText({
    super.key,
    required this.text,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.textAlign = TextAlign.start,
    this.onMentionTap,
  });

  @override
  State<ParsedLinkText> createState() => _ParsedLinkTextState();
}

class _ParsedLinkTextState extends State<ParsedLinkText> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    // Standardize URL: prepend https:// if it looks like a domain but lacks protocol
    String standardizedUrl = url;
    if (!url.toLowerCase().startsWith('http')) {
      standardizedUrl = 'https://$url';
    }

    final Uri uri = Uri.parse(standardizedUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Could not launch $standardizedUrl: $e');
    }
  }

  void _handleMentionTap(String username) {
    if (widget.onMentionTap != null) {
      widget.onMentionTap!(username);
    } else {
      // Fallback navigation
      final cleanUsername = username.startsWith('@')
          ? username.substring(1)
          : username;
      Get.toNamed('/profile', parameters: {'username': cleanUsername});
    }
  }

  bool _isRTL(String text) {
    if (text.isEmpty) return false;
    // Simple check for Arabic characters
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.text.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final baseStyle = (widget.style ?? const TextStyle()).withArabicCheck(widget.text);

    // Clear old recognizers before rebuilding
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();

    final List<InlineSpan> spans = [];

    // Regex for URLs, @usernames, and common domains like meet.google.com
    final RegExp combinedRegex = RegExp(
      r'(https?:\/\/[^\s]+|meet\.google\.com[^\s]*|@[a-zA-Z0-9._-]+)',
      caseSensitive: false,
    );

    final matches = combinedRegex.allMatches(widget.text);
    int lastMatchEnd = 0;

    for (final match in matches) {
      // Add normal text before the match
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: widget.text.substring(lastMatchEnd, match.start),
            style: baseStyle,
          ),
        );
      }

      final matchedText = match.group(0)!;
      final bool isMention = matchedText.startsWith('@');

      // It's a link if it's not a mention
      final bool isLink = !isMention;

      final recognizer = TapGestureRecognizer()
        ..onTap = isLink
            ? () => _launchURL(matchedText)
            : () => _handleMentionTap(matchedText);
      _recognizers.add(recognizer);

      spans.add(
        TextSpan(
          text: matchedText,
          style: baseStyle.copyWith(
            color: theme.primaryColor,
            fontWeight: isMention ? FontWeight.bold : FontWeight.normal,
          ),
          recognizer: recognizer,
        ),
      );

      lastMatchEnd = match.end;
    }

    // Add remaining text
    if (lastMatchEnd < widget.text.length) {
      spans.add(
        TextSpan(
          text: widget.text.substring(lastMatchEnd),
          style: baseStyle,
        ),
      );
    }

    final isRtlText = _isRTL(widget.text);

    // Determine directional alignment.
    // We use absolute Left/Right to ensure it sticks to the extremes regardless of app Directionality.
    final alignment = isRtlText ? TextAlign.right : TextAlign.left;
    final direction = isRtlText ? TextDirection.rtl : TextDirection.ltr;

    return Text.rich(
      TextSpan(children: spans),
      maxLines: widget.maxLines,
      overflow: widget.overflow,
      textAlign: widget.textAlign == TextAlign.start
          ? alignment
          : widget.textAlign,
      textDirection: direction,
    );
  }
}
