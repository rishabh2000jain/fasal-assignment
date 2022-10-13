import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_library_app/resources/app_%20colors.dart';

typedef SearchValue = void Function(String);
typedef ClearValue =  Function();


class SearchTextField extends StatefulWidget {
  final bool readOnly;
  final bool autoFocus;
  final Function()? onTap;
  final Function(String text) onChange;
  final SearchValue onSubmit;
  final ClearValue onClear;
  final TextEditingController? controller;
  const SearchTextField({Key? key, this.readOnly=false,this.onTap,this.autoFocus=false,required this.onSubmit,required this.onClear,this.controller,required this.onChange}) : super(key: key);

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
   bool showTrailing=false;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.primaryVariantColor,
          borderRadius: BorderRadius.circular(6)
      ),
      child: TextField(
        controller: widget.controller,
        autofocus: widget.autoFocus,
        onTap: widget.onTap,
        readOnly: widget.readOnly,
        onSubmitted: (value){
            widget.onSubmit(value);
          },
        onChanged: (value){
          if(value.isNotEmpty){
            if(!showTrailing){
              setState(() {
                showTrailing = true;
              });
            }
          }else{
            if(showTrailing){
              setState(() {
                showTrailing = false;
              });
            }
          }
          widget.onChange(value);
        },
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'search',
            hintStyle: GoogleFonts.poppins(
              color: AppColors.greyLight,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: const Icon(Icons.search,color: AppColors.primaryColor,)),
            suffixIcon: showTrailing?GestureDetector(
                onTap: (){
                  if(showTrailing){
                    setState(() {
                      showTrailing = false;
                    });
                  }
                  widget.controller?.clear();
                  widget.onClear();
                },
                child:const Icon(Icons.clear,size: 24,color: AppColors.primaryColor,)): Container(height: 1,width: 1,)
        ),
        cursorHeight: 20,
        style: GoogleFonts.poppins(
          color: AppColors.primaryColor,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}