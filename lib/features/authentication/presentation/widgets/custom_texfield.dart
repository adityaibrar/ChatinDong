import '../../../../core/theme.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.autoFocus,
    this.enabled = true,
    this.style,
    this.keyboardType,
    this.suffixIcon,
    this.onSubmitted,
    this.suffixColor,
    this.preffixIcon,
    this.cursorColor,
    this.borderColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 10,
    ),
    this.obscureText = false,
    this.focusNode,
    this.onSuffixIconPressed,
    this.onChanged,
    this.maxLine,
    this.height,
  });

  final TextEditingController controller;
  final bool? autoFocus;
  final bool enabled;
  final String labelText;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final IconData? suffixIcon;
  final IconData? preffixIcon;
  final int? maxLine;
  final double? height;
  final Color? suffixColor;
  final Color? cursorColor;
  final Color? borderColor;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final bool obscureText;
  final FocusNode? focusNode;
  final VoidCallback? onSuffixIconPressed;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height ?? 60,
          child: TextField(
            autofocus: autoFocus ?? false,
            focusNode: focusNode,
            maxLines: maxLine,
            enabled: enabled,
            controller: controller,
            cursorColor: cursorColor ?? primaryColor,
            obscureText: obscureText,
            style: style ??
                TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                ),
            keyboardType: keyboardType ?? TextInputType.text,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              suffixIcon: suffixIcon != null
                  ? GestureDetector(
                      onTap: onSuffixIconPressed,
                      child: Icon(
                        suffixIcon,
                        color: suffixColor ?? secondaryColor,
                      ),
                    )
                  : null,
              prefixIcon: preffixIcon != null
                  ? Icon(
                      preffixIcon,
                      color: secondaryColor,
                    )
                  : null,
              iconColor: suffixColor,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor ?? primaryColor),
                borderRadius: borderRadius,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor ?? primaryColor),
                borderRadius: borderRadius,
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor ?? primaryColor),
                borderRadius: borderRadius,
              ),
              labelText: labelText,
              labelStyle: blackTextStyle.copyWith(
                color: borderColor ?? primaryColor,
                fontWeight: FontWeight.w300,
                fontSize: 17,
              ),
              contentPadding: padding,
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
