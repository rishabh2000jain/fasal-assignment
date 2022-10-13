import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_library_app/app/bloc/authentication/auth_states.dart';
import 'package:movie_library_app/app/models/user_data.dart';
import 'package:movie_library_app/services/authentication/auth_manager.dart';

@injectable
class AuthBloc extends Cubit<AuthStates>{
  final AuthManager<UserData> _authManager;
  UserData? _userData;
  AuthBloc(this._authManager) : super(InitialAuthState());

  UserData? get userDetails => _userData;

  void resetBloc()async{
    _userData = null;
    emit(InitialAuthState());
  }

  Future<void> getUserDetails()async{
    try{
      if(userDetails!=null){
        emit(LoadedUserDetails());
      }else {
        UserData? userData = await _authManager.getCurrentUser();
        _userData = userData;
        if (userData != null) {
          emit(LoadedUserDetails());
        } else {
          emit(FailedLoadingUserDetails());
        }
      }
    }catch(error){
      log(error.toString());
      emit(FailedLoadingUserDetails());
    }
      }


  Future<void> login(String email,String password)async {
    emit(UserLoginLoading());
    try{
     UserData? userData =  await _authManager.loginUser(email, password);
     _userData = userData;
     if(userData!=null){
       emit(UserLoginSuccess());
     }else{
       emit(UserLoginFailed());
     }
    }catch(error){
      log(error.toString());
      emit(UserLoginFailed());
    }
  }
  Future<void> register(String email,String password,String name,String number)async {
    emit(UserRegisterLoading());
    try{
      UserData? userData =  await _authManager.registerUser(email, password,{ 'phone': number, 'name': name});
      _userData = userData;
      if(userData!=null){
        emit(UserRegisterSuccess());
      }else{
        emit(UserRegisterFailed());
      }
    }catch(error){
      log(error.toString());
      emit(UserRegisterFailed());
    }
  }
  Future<void> logout()async {
    try{
      await _authManager.logoutCurrentUser();
      resetBloc();
      emit(UserLogoutSuccess());
    }catch(error){
      log(error.toString());
    }
  }


}