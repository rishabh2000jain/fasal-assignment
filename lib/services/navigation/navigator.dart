import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_library_app/app/models/user_data.dart';
import 'package:movie_library_app/app/screens/home/home_screen.dart';
import 'package:movie_library_app/app/screens/login/login_screen.dart';
import 'package:movie_library_app/app/screens/onboarding/startup_screen.dart';
import 'package:movie_library_app/app/screens/register/register_screen.dart';
import 'package:movie_library_app/app/screens/search/search_screen.dart';
import 'package:movie_library_app/services/authentication/auth_manager.dart';
import 'package:movie_library_app/services/navigation/routes.dart';

@singleton
@Injectable()
class NavigationService {
  final AuthManager<UserData> userAuth;
  late GoRouter goRouter;

  NavigationService(this.userAuth) {
   _initRoutes();
  }



  Future<String?> _handleRedirect(BuildContext context,
      GoRouterState state) async {
    bool isRegistered = await userAuth.isRegistered();
    if (!isRegistered) {
      bool isInitial = state.subloc == Routes.kInitial;
      bool isLoggingIn = state.subloc == Routes.kLogin;
      bool isRegisteringIn = state.subloc == Routes.kRegister;
      if(!isInitial && !isLoggingIn && !isRegisteringIn){
        return Routes.kInitial;
      }
    }
    return null;
  }

 void _initRoutes(){
   goRouter = GoRouter(
        redirectLimit: 5,
       initialLocation: Routes.kHome,
       redirect: _handleRedirect,
       routes: [
         GoRoute(
           path: Routes.kHome,
           builder: (BuildContext context, GoRouterState state) =>
           const HomeScreen(),
         ),
         GoRoute(
           path: Routes.kInitial,
           builder: (BuildContext context, GoRouterState state) =>
           const StartupScreen(),
         ),
         GoRoute(
           path: Routes.kRegister,
           builder: (BuildContext context, GoRouterState state) =>
           const RegisterScreen(),
         ),

         GoRoute(
           path: Routes.kLogin,
           builder: (BuildContext context, GoRouterState state) =>
           const LoginScreen(),
         ),
         GoRoute(
           path: Routes.kSearch,
           builder: (BuildContext context, GoRouterState state) =>
           const SearchScreen(),
         ),
       ],
   );
 }

}
