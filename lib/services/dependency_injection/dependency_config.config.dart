// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i4;
import 'package:firebase_auth/firebase_auth.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../app/bloc/authentication/auth_bloc.dart' as _i13;
import '../../app/bloc/movie_search/search_bloc.dart' as _i8;
import '../../app/bloc/playlist/playlist_bloc.dart' as _i7;
import '../../app/models/user_data.dart' as _i10;
import '../../app/repository/playlist_repository.dart' as _i6;
import '../authentication/auth_manager.dart' as _i9;
import '../authentication/firebase_auth_manager.dart' as _i11;
import '../firebase_services.dart' as _i5;
import '../navigation/navigator.dart' as _i12;
import 'di_modules/firebase_module.dart'
    as _i14; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final firebaseModule = _$FirebaseModule();
  gh.factory<_i3.FirebaseAuth>(() => firebaseModule.firebaseAuth);
  gh.factory<_i4.FirebaseFirestore>(() => firebaseModule.firebaseFirestore);
  await gh.factoryAsync<_i5.FirebaseService>(
    () => firebaseModule.firebaseService,
    preResolve: true,
  );
  gh.factory<_i6.MoviesRepository>(() => _i6.MoviesRepository(
        get<_i4.FirebaseFirestore>(),
        get<_i3.FirebaseAuth>(),
      ));
  gh.factory<_i7.PlaylistBloc>(
      () => _i7.PlaylistBloc(get<_i6.MoviesRepository>()));
  gh.factory<_i8.SearchBloc>(() => _i8.SearchBloc(get<_i6.MoviesRepository>()));
  gh.factory<_i9.AuthManager<_i10.UserData>>(() => _i11.FirebaseAuthManager(
        get<_i3.FirebaseAuth>(),
        get<_i4.FirebaseFirestore>(),
      ));
  gh.singleton<_i12.NavigationService>(
      _i12.NavigationService(get<_i9.AuthManager<_i10.UserData>>()));
  gh.factory<_i13.AuthBloc>(
      () => _i13.AuthBloc(get<_i9.AuthManager<_i10.UserData>>()));
  return get;
}

class _$FirebaseModule extends _i14.FirebaseModule {}
