import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_library_app/api_response_wrapper.dart';
import 'package:movie_library_app/app/models/movie_response_model.dart';
import 'package:movie_library_app/app/models/playlist_response_model.dart';
import 'package:movie_library_app/app/models/user_playlist_model.dart';
import 'package:movie_library_app/app_constants.dart';

@Injectable()
class MoviesRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;
  Dio dio = Dio(BaseOptions(
      baseUrl: AppConstants.kBaseUrl,
      queryParameters: {'apikey': AppConstants.kApiKey}));

  MoviesRepository(this._firebaseFirestore, this._firebaseAuth);

  Future<ApiResponseWrapper<List<PlayListResponseModel>>> getPlaylistsFromFirestore(DocumentSnapshot? lastPlaylistSnap) async {
    List<PlayListResponseModel> playlists=[];
    ApiResponseWrapper<List<PlayListResponseModel>> _responseWrapper =
        ApiResponseWrapper();
    try {
      if(lastPlaylistSnap == null){
        QuerySnapshot snapshot = await _firebaseFirestore.collection('Playlists').where('userId',isEqualTo: _firebaseAuth.currentUser!.uid).get();
        snapshot.docs.forEach((element) {
          playlists.add(PlayListResponseModel.fromJson(element.data() as Map<String,dynamic>, element));
        });
      }
      Query query = _firebaseFirestore.collection('Playlists');
      if (lastPlaylistSnap != null) {
        query = query.startAfterDocument(lastPlaylistSnap);
      }
      query = query.orderBy('userId').where('userId',isNotEqualTo: _firebaseAuth.currentUser!.uid,).where('isPrivate',isEqualTo: false).limit(2);
      QuerySnapshot snapshot = await query.get();


      snapshot.docs.forEach((element) {
        playlists.add(PlayListResponseModel.fromJson(element.data() as Map<String,dynamic>, element));
      });
      _responseWrapper.apiResponse = playlists;
    } on Exception catch (error) {
      log(error.toString());
      _responseWrapper.apiError = error;
    }
    return _responseWrapper;
  }

  Future<ApiResponseWrapper<bool>> addToPlaylist(String playlistId, Search movie) async {
    ApiResponseWrapper<bool> _responseWrapper =
    ApiResponseWrapper();
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
          .collection('Playlists')
          .doc(playlistId)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        List<dynamic> movies = data['movies'];
        bool existSame = movies.any((element) =>
        ((element as Map<String, dynamic>)['imdbID'] == movie.imdbID));
        if (!existSame) {
          movies.add(movie.toJson());
          await _firebaseFirestore
              .collection('Playlists')
              .doc(playlistId)
              .update({'movies': movies});
          _responseWrapper.apiResponse = true;
        }else{
          _responseWrapper.apiResponse = false;
          _responseWrapper.displayMessage = 'Movie is already present';
        }
      }
    } on Exception catch (error) {
      log(error.toString());
      _responseWrapper.apiResponse =  false;
    }
    return _responseWrapper;
  }

  Future<ApiResponseWrapper<bool>> createPlaylistAndAddMovie(
      {required String name,
      required bool isPrivate,
      required Search movie}) async {
    ApiResponseWrapper<bool> responseWrapper = ApiResponseWrapper();
    try {
      List<Map<String, dynamic>> movies = [];
      movies.add(movie.toJson());
      DocumentReference reference =
          _firebaseFirestore.collection('Playlists').doc();
      await createUserIfRequiredAndAddPlaylistIds(
          name: name, isPrivate: isPrivate, playlistId: reference.id);
      await reference.set({
        'userId': _firebaseAuth.currentUser!.uid,
        'movies': movies,
        'isPrivate': isPrivate,
        'createdAt': DateTime.now().toUtc(),
        'playlistName':name
      });
      responseWrapper.responseData = true;
    } on Exception catch (error) {
      log(error.toString());
      responseWrapper.responseData = false;
    }
    return responseWrapper;
  }

  Future<ApiResponseWrapper<MovieResponseModel>> searchMovies(
      String searchQuery, int page) async {
    ApiResponseWrapper<MovieResponseModel> responseWrapper =
        ApiResponseWrapper();
    try {
      Response<Map<String, dynamic>> response =
          await dio.get('/', queryParameters: {'page': page,'s':searchQuery});
      if (response.statusCode == 200 && response.data != null) {
        MovieResponseModel responseModel =
            MovieResponseModel.fromJson(response.data!);
        responseWrapper.apiResponse = responseModel;
      }
    } on DioError catch (error) {
      responseWrapper.apiError = error;
    } on Exception catch (error) {
      responseWrapper.apiError = error;
    }
    return responseWrapper;
  }

  Future<bool> createUserIfRequiredAndAddPlaylistIds(
      {required String name,
      required bool isPrivate,
      required String playlistId}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> document = await _firebaseFirestore
          .collection('userPlaylists')
          .where('userId', isEqualTo: _firebaseAuth.currentUser!.uid)
          .get();
      if (document.docs.isEmpty) {
        DocumentReference reference = _firebaseFirestore
            .collection('userPlaylists')
            .doc(_firebaseAuth.currentUser!.uid);
        Map<String, dynamic> userData = {};
        Map<String, dynamic> playlist = {};
        userData['userId'] = _firebaseAuth.currentUser!.uid;
        playlist['name'] = name;
        playlist['playlistId'] = playlistId;

        userData['playlists']=[playlist];
        await reference.set(userData);
      }else{
        Map<String, dynamic> userData = document.docs.first.data();
        List<dynamic> tempJson= userData['playlists'];
        Map<String, dynamic> playlist = {};
        playlist['playlistId'] = playlistId;
        playlist['name'] = name;
        tempJson.add(playlist);
        await document.docs.first.reference.update({'playlists':tempJson});
      }
      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }

  Future<ApiResponseWrapper<UserPlaylistModel>> getUsersPlaylists()async{
    ApiResponseWrapper<UserPlaylistModel> responseWrapper = ApiResponseWrapper();
    try {
      QuerySnapshot<Map<String, dynamic>> document = await _firebaseFirestore
          .collection('userPlaylists')
          .where('userId', isEqualTo: _firebaseAuth.currentUser!.uid)
          .get();
      if (document.docs.isNotEmpty) {
          Map<String,dynamic> userData = document.docs.first.data();
          UserPlaylistModel userPlaylistModel = UserPlaylistModel.fromJson(userData);
          responseWrapper.apiResponse = userPlaylistModel;
      }
    } on Exception catch (error) {
      responseWrapper.apiError = error;
      log(error.toString());
    }
    return responseWrapper;
  }

}
