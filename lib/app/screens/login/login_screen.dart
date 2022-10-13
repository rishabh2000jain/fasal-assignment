import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_library_app/app/bloc/authentication/auth_bloc.dart';
import 'package:movie_library_app/app/bloc/authentication/auth_states.dart';
import 'package:movie_library_app/app/screens/common_widgets/common_rounded_button.dart';
import 'package:movie_library_app/app/screens/common_widgets/common_text_field.dart';
import 'package:movie_library_app/app/screens/common_widgets/loading_widget.dart';
import 'package:movie_library_app/resources/app_%20colors.dart';
import 'package:movie_library_app/services/navigation/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final RegExp _regExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  late AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _password.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc,AuthStates>(
          listener: (BuildContext context,AuthStates states){
            if(states is UserLoginFailed){
              Fluttertoast.showToast(msg: 'Failed to log you in',backgroundColor: Colors.red);
              LoadingAlert.remove(context);
            }else if(states is UserLoginSuccess){
              context.go(Routes.kHome);
              LoadingAlert.remove(context);
            }else if(states is UserLoginLoading){
              LoadingAlert.show(context);
            }
          },
          child: Container(
            height: size.height,
            width: size.width,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Let's log you in.",
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryVariantColor,
                              fontSize: 35,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Welcome back.\nYou've been missed!",
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryVariantColor,
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          CommonTextField(
                            hintText: 'email',
                            controller: _email,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.emailAddress,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CommonTextField(
                            hintText: 'password',
                            controller: _password,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            textInputType: TextInputType.visiblePassword,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Don't have account?",
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryVariantDarkColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                            text: "Register",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.replace(Routes.kRegister);
                              },
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryVariantColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ))
                      ])),
                ),
                const SizedBox(
                  height: 20,
                ),
                CommonRoundedButton(
                  onTap: () {
                    if(_email.text.isNotEmpty && _regExp.hasMatch(_email.text) && _password.text.length > 5){
                        _authBloc.login(_email.text, _password.text);
                    }else{
                      Fluttertoast.showToast(msg: 'Invalid email or password',backgroundColor: Colors.black);
                    }
                  },
                  buttonText: 'Login',
                  isDark: false,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
