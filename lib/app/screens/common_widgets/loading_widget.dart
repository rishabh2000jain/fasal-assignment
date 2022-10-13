import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_library_app/resources/app_colors.dart';

class LoadingAlert {
  LoadingAlert._();
  static bool _isLoadingAlertVisible = false;
// Function to show loader
  static void show(BuildContext context,{bool barrierDismissible=false,double height = 150,double width=150}) {
    _isLoadingAlertVisible = true;
    showGeneralDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        pageBuilder: (BuildContext context,_,__){
          return WillPopScope(
            onWillPop: () async{
              _isLoadingAlertVisible = false;
              return true;
            },
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: LoadingWidget(height: height,width:width,),
              ),
            ),
          );
        });
  }

  // Function to remove loader
  static void remove(BuildContext context) {
    if( _isLoadingAlertVisible) {
      Navigator.of(context).pop();
      _isLoadingAlertVisible = false;
    }
  }
}



class LoadingWidget extends StatelessWidget {
  const LoadingWidget({this.width = 150, this.height = 150, Key? key})
      : super(key: key);
  final double height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                color: AppColors.secondaryColor,
              )),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Loading...',
            style: GoogleFonts.poppins(
              color: AppColors.primaryVariantColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
