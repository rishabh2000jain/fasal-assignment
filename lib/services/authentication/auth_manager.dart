
abstract class AuthManager<T>{
  Future<T?> loginUser(String email,String password);
  Future<T?> registerUser(String email,String password,Map<String,dynamic> extraParams);
  Future<T?> getCurrentUser();
  Future<void> logoutCurrentUser();
  Future<bool> isRegistered();
}