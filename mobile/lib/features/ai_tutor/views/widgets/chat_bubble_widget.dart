import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/theme_config.dart';
import '../../../../core/widgets/latex_markdown.dart';
import '../../models/chat_message_model.dart';

class ChatBubbleWidget extends StatelessWidget {
  final ChatMessageModel message;

  const ChatBubbleWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;
    final theme = Theme.of(context);
    final textColor = isUser
        ? Colors.white
        : (theme.textTheme.bodyLarge?.color ?? Colors.black87);

    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(message.text);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.84,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? ThemeConfig.primaryColor
              : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (isUser) ...[
              if (message.attachmentPath != null && message.attachmentPath!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: message.attachmentPath!.startsWith('http')
                        ? Image.network(
                            message.attachmentPath!,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.image_outlined,
                              color: Colors.white70,
                              size: 40,
                            ),
                          )
                        : Image.file(
                            File(message.attachmentPath!),
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.image_outlined,
                              color: Colors.white70,
                              size: 40,
                            ),
                          ),
                  ),
                ),
              Text(
                message.text,
                style: isArabic
                    ? GoogleFonts.cairo(
                        fontSize: 14.5,
                        height: 1.45,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      )
                    : GoogleFonts.inter(
                        fontSize: 14.5,
                        height: 1.45,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              ),
            ]
            else
              Directionality(
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                child: LatexMarkdown(
                  data: message.text,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: isArabic
                        ? GoogleFonts.cairo(fontSize: 14.5, height: 1.5, color: textColor)
                        : GoogleFonts.inter(fontSize: 14.5, height: 1.5, color: textColor),
                    strong: isArabic
                        ? GoogleFonts.cairo(fontSize: 14.5, fontWeight: FontWeight.bold, color: textColor)
                        : GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.bold, color: textColor),
                    h1: isArabic
                        ? GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)
                        : GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                    h2: isArabic
                        ? GoogleFonts.cairo(fontSize: 16.5, fontWeight: FontWeight.bold, color: textColor)
                        : GoogleFonts.inter(fontSize: 16.5, fontWeight: FontWeight.bold, color: textColor),
                    h3: isArabic
                        ? GoogleFonts.cairo(fontSize: 15.5, fontWeight: FontWeight.w600, color: textColor)
                        : GoogleFonts.inter(fontSize: 15.5, fontWeight: FontWeight.w600, color: textColor),
                    listBullet: isArabic
                        ? GoogleFonts.cairo(fontSize: 14.5, color: textColor)
                        : GoogleFonts.inter(fontSize: 14.5, color: textColor),
                    code: GoogleFonts.firaCode(
                      fontSize: 13,
                      color: theme.primaryColor,
                      backgroundColor: theme.primaryColor.withOpacity(0.08),
                    ),
                    codeblockPadding: const EdgeInsets.all(10),
                    codeblockDecoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 6),
            Text(
              '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 10,
                color: isUser ? Colors.white70 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
