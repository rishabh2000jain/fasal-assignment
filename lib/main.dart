import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_library_app/app/bloc/authentication/auth_bloc.dart';
import 'package:movie_library_app/app/bloc/movie_search/search_bloc.dart';
import 'package:movie_library_app/resources/app_%20colors.dart';
import 'package:movie_library_app/services/dependency_injection/dependency_config.dart';
import 'package:movie_library_app/services/navigation/navigator.dart';

import 'app/bloc/playlist/playlist_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context)=>getIt<AuthBloc>()),
        BlocProvider(create: (BuildContext context)=>getIt<PlaylistBloc>()),
        BlocProvider(create: (BuildContext context)=>getIt<SearchBloc>())
      ],
      child: MaterialApp.router(
        title: 'Movie Playlist App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.primaryColor,
        ),
        routeInformationParser: getIt<NavigationService>().goRouter.routeInformationParser,
        routeInformationProvider: getIt<NavigationService>().goRouter.routeInformationProvider,
        routerDelegate: getIt<NavigationService>().goRouter.routerDelegate,
      ),
    );
  }
}


