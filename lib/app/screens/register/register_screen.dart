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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _password = TextEditingController();
  late AuthBloc _authBloc;
  final RegExp _regExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _number.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc,AuthStates>(
          listener: (BuildContext context,AuthStates states){
            if(states is UserRegisterFailed){
              Fluttertoast.showToast(msg: 'Failed to create account',backgroundColor: Colors.red);
              LoadingAlert.remove(context);
            }else if(states is UserRegisterSuccess){
              context.go(Routes.kHome);
              LoadingAlert.remove(context);
            }else if(states is UserRegisterLoading){
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
                            "Register",
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
                            "Let's create your own space.",
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
                            textInputType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              hintText: 'name',
                              controller: _name,),
                          const SizedBox(
                            height: 20,
                          ),
                          CommonTextField(
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.number,
                              hintText: 'number',
                              controller: _number,),
                          const SizedBox(
                            height: 20,
                          ),
                          CommonTextField(
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.emailAddress,
                            hintText: 'email',
                            controller: _email,),
                          const SizedBox(
                            height: 20,
                          ),
                          CommonTextField(
                            textInputAction: TextInputAction.done,
                            textInputType: TextInputType.visiblePassword,
                            hintText: 'password',
                            obscureText: true,
                            controller: _password,),
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
                      text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Already have an account?",
                              style: GoogleFonts.poppins(
                                color: AppColors.primaryVariantDarkColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                                text: 'Login',
                                recognizer: TapGestureRecognizer()..onTap=(){
                                  context.replace(Routes.kLogin);
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
                    if(_number.text.length!=10){
                      Fluttertoast.showToast(msg: 'Invalid number',backgroundColor: Colors.black);
                    }else if(_name.text.isEmpty){
                      Fluttertoast.showToast(msg: 'Name cannot be empty',backgroundColor: Colors.black);
                    }else if(_email.text.isNotEmpty && _regExp.hasMatch(_email.text) && _password.text.length > 5){
                      _authBloc.register(_email.text, _password.text,_name.text,_number.text);
                    }else{
                      Fluttertoast.showToast(msg: 'Invalid email or password',backgroundColor: Colors.black);
                    }
                  },
                  buttonText: 'Register',
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
