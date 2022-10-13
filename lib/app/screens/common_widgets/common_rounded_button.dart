
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_library_app/resources/app_colors.dart';

class CommonRoundedButton extends StatelessWidget {
  const CommonRoundedButton(
      {required this.buttonText,
        required this.isDark,
        required this.onTap,
        this.width,
        Key? key})
      : super(key: key);
  final double? width;
  final String buttonText;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: isDark
                ? AppColors.primaryLightColor
                : AppColors.primaryVariantColor),
        width: width,
        child: Text(
          buttonText,
          style: GoogleFonts.poppins(
            color: isDark
                ? AppColors.primaryVariantColor
                : AppColors.primaryLightColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}