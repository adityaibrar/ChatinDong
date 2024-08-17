import '../../../../core/theme.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Color titleColor;
  final Color backgroundColor;
  final Size? size;
  final VoidCallback onPressed;
  const CustomButton({
    super.key,
    required this.title,
    required this.titleColor,
    required this.backgroundColor,
    required this.onPressed,
    this.size = const Size(double.infinity, 60),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: size,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      child: Text(
        title,
        style: whiteTextStyle.copyWith(
          color: titleColor,
          fontWeight: semiBold,
          fontSize: 18,
        ),
        maxLines: 1,
      ),
    );
  }
}
