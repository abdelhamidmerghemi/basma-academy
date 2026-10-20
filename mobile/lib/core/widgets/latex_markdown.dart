import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown/markdown.dart' as md;

/// Syntax parser for inline math `$...$` and `\(...\)`
class LatexInlineSyntax extends md.InlineSyntax {
  LatexInlineSyntax() : super(r'(\$([^\$]+)\$|\\\(([^\)]+)\\\))');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final rawMatch = match.group(0) ?? '';
    String content = '';
    if (rawMatch.startsWith(r'\(') && rawMatch.endsWith(r'\)')) {
      content = rawMatch.substring(2, rawMatch.length - 2);
    } else if (rawMatch.startsWith(r'$') && rawMatch.endsWith(r'$')) {
      content = rawMatch.substring(1, rawMatch.length - 1);
    } else {
      content = match.group(2) ?? match.group(3) ?? '';
    }

    final element = md.Element.text('latex_inline', content);
    parser.addNode(element);
    return true;
  }
}

/// Syntax parser for block math `$$...$$` and `\[...\]`
class LatexBlockSyntax extends md.InlineSyntax {
  LatexBlockSyntax() : super(r'(\$\$([^\$]+)\$\$|\\\[([^\]]+)\\\])');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final rawMatch = match.group(0) ?? '';
    String content = '';
    if (rawMatch.startsWith(r'\[') && rawMatch.endsWith(r'\]')) {
      content = rawMatch.substring(2, rawMatch.length - 2);
    } else if (rawMatch.startsWith(r'$$') && rawMatch.endsWith(r'$$')) {
      content = rawMatch.substring(2, rawMatch.length - 2);
    } else {
      content = match.group(2) ?? match.group(3) ?? '';
    }

    final element = md.Element.text('latex_block', content);
    parser.addNode(element);
    return true;
  }
}

/// Builder that renders LaTeX expressions using `flutter_math_fork`
class LatexElementBuilder extends MarkdownElementBuilder {
  final bool isBlock;
  final TextStyle? style;

  LatexElementBuilder({this.isBlock = false, this.style});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final String latex = element.textContent.trim();
    if (latex.isEmpty) return const SizedBox.shrink();

    final textStyle = style ?? preferredStyle ?? const TextStyle();

    try {
      final mathWidget = Math.tex(
        latex,
        textStyle: textStyle,
        mathStyle: isBlock ? MathStyle.display : MathStyle.text,
        onErrorFallback: (err) => Text(
          latex,
          style: textStyle.copyWith(color: Colors.amber),
        ),
      );

      final ltrMathWidget = Directionality(
        textDirection: TextDirection.ltr,
        child: mathWidget,
      );

      if (isBlock) {
        return Container(
          width: double.infinity,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: ltrMathWidget,
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: ltrMathWidget,
        ),
      );
    } catch (e) {
      return Text(latex, style: textStyle);
    }
  }
}

/// Custom MarkdownBody wrapper with built-in LaTeX rendering for math & science formulas
class LatexMarkdown extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final MarkdownStyleSheet? styleSheet;
  final bool selectable;
  final void Function(String, String?, String)? onTapLink;

  const LatexMarkdown({
    super.key,
    required this.data,
    this.style,
    this.styleSheet,
    this.selectable = false,
    this.onTapLink,
  });

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      selectable: selectable,
      onTapLink: onTapLink,
      styleSheet: styleSheet,
      inlineSyntaxes: [
        LatexBlockSyntax(),
        LatexInlineSyntax(),
      ],
      builders: {
        'latex_inline': LatexElementBuilder(isBlock: false, style: style),
        'latex_block': LatexElementBuilder(isBlock: true, style: style),
      },
    );
  }
}
