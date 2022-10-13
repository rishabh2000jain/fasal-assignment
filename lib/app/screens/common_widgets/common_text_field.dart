import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_library_app/resources/app_colors.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField(
      {required this.hintText, required this.controller, this.textInputType=TextInputType.text,this.textInputAction,this.obscureText=false,Key? key})
      : super(key: key);
  final String hintText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      style: GoogleFonts.poppins(
        color: AppColors.primaryVariantColor,
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 1.50,
      ),
      keyboardType: textInputType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        filled: true,
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          color: AppColors.primaryVariantDarkColor,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        fillColor: AppColors.primaryLightColor,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: AppColors.primaryVariantColor,
              width: 2,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: AppColors.primaryVariantDarkColor,
              width: 2,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(16),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
              color: AppColors.primaryVariantDarkColor,
              width: 2,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}