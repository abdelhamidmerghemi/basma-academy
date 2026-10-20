import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? prefix;
  final TextInputType keyboardType;
  final bool readOnly;
  final bool enabled;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextDirection? textDirection;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText = '',
    this.prefixIcon,
    this.prefix,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.enabled = true,
    this.obscureText = false,
    this.suffixIcon,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveDirection =
        textDirection ?? (keyboardType == TextInputType.phone ? TextDirection.ltr : null);

    final widgetTree = TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      enabled: enabled,
      obscureText: obscureText,
      textDirection: effectiveDirection,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: theme.primaryColor) : null,
        prefix: prefix,
        suffixIcon: suffixIcon,
        alignLabelWithHint: true,
      ),
    );

    if (effectiveDirection != null) {
      return Directionality(
        textDirection: effectiveDirection,
        child: widgetTree,
      );
    }

    return widgetTree;
  }
}
