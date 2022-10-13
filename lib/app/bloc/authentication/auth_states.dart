
import 'package:equatable/equatable.dart';

abstract class AuthStates extends Equatable{}

 class InitialAuthState extends AuthStates{
   @override
   List<Object?> get props => [];
 }

class UserLoginFailed extends AuthStates{
  UserLoginFailed();
  @override
  List<Object?> get props => [];
}

class UserLoginSuccess extends AuthStates{
  @override
  List<Object?> get props => [];
}
class UserLoginLoading extends AuthStates{
  @override
  List<Object?> get props => [];
}

class UserRegisterFailed extends AuthStates{
  UserRegisterFailed();
  @override
  List<Object?> get props => [];
}

class UserRegisterSuccess extends AuthStates{
  @override
  List<Object?> get props => [];
}
class UserRegisterLoading extends AuthStates{
  @override
  List<Object?> get props => [];
}

class UserLogoutSuccess extends AuthStates{
  @override
  List<Object?> get props => [];
}

class LoadedUserDetails extends AuthStates{
  @override
  List<Object?> get props => [];
}

class FailedLoadingUserDetails extends AuthStates{
  @override
  List<Object?> get props => [];
}