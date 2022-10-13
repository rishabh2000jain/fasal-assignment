import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_library_app/app/screens/common_widgets/common_rounded_button.dart';
import 'package:movie_library_app/resources/app_%20colors.dart';
import 'package:movie_library_app/resources/images.dart';
import 'package:movie_library_app/services/navigation/routes.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.watchingTv,
                height: size.height * 0.5,
                width: size.width,
              ),
              Text(
                'Create & Share Movies Playlist',
                style: GoogleFonts.poppins(
                  color: AppColors.primaryVariantColor,
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Bring together all your liked movies and share with others and also see what others like',
                style: GoogleFonts.poppins(
                  color: AppColors.primaryVariantDarkColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: CommonRoundedButton(
                      onTap: () {
                        context.push(Routes.kLogin);
                      },
                      buttonText: 'Login',
                      isDark: true,
                    ),
                  ),
                  Expanded(
                    child: Transform.translate(
                      offset: const Offset(-15,0),
                      child: CommonRoundedButton(
                        onTap: () {
                          context.push(Routes.kRegister);
                        },
                        buttonText: 'Register',
                        isDark: false,
                      ),
                    ),
                  ),

                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

