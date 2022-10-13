import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_library_app/api_response_wrapper.dart';
import 'package:movie_library_app/app/bloc/playlist/playlist_states.dart';
import 'package:movie_library_app/app/models/movie_response_model.dart';
import 'package:movie_library_app/app/models/playlist_response_model.dart';
import 'package:movie_library_app/app/models/user_playlist_model.dart';
import 'package:movie_library_app/app/repository/playlist_repository.dart';

@injectable
class PlaylistBloc extends Cubit<PlaylistsStates>{
  final MoviesRepository _repository;
  List<PlayListResponseModel> playlists=[];
  List<UserPlaylistModel> userPlaylists = [];

  bool _isDataFinished=false;
  PlaylistBloc(this._repository) : super(InitialPlaylistsState());

  bool get isDataFinished => _isDataFinished;
  Search? _movieToAdd;

  void reset(){
    _isDataFinished = false;
    playlists.clear();
    emit(InitialPlaylistsState());
  }

  void refreshHomeScreenPlaylists(){
    reset();
    getPlaylists();
  }

  Future<void> getPlaylists()async {
    emit(LoadingPlaylistsState(playlists));
    DocumentSnapshot? lastPlaylistSnap = playlists.isNotEmpty?playlists.last.snapshot:null;
    ApiResponseWrapper<List<PlayListResponseModel>> _responseWrapper = await _repository.getPlaylistsFromFirestore(lastPlaylistSnap);
    if(_responseWrapper.hasData){
      if(_responseWrapper.data!.isNotEmpty){
        playlists.addAll(_responseWrapper.data!);
      }else {
        _isDataFinished = true;
      }
      if(playlists.isEmpty){
        emit(EmptyPlaylistsState());
      }else{
        emit(PlaylistsLoadedState(playlists));
      }
    }else if(playlists.isEmpty){
      emit(ErrorLoadingPlaylistsState());
    }
  }


  void openPlaylistSheetToAddMovie(Search search)async{
    _movieToAdd = search;
    emit(OpenUserPlaylistSheet());
  }

  void loadUserPlaylist()async{
    emit(LoadingUserPlaylist());
    ApiResponseWrapper<UserPlaylistModel> responseWrapper = await _repository.getUsersPlaylists();
    if(responseWrapper.hasData){
      emit(LoadedUserPlaylist(responseWrapper.data!.playlists));
    }else if(responseWrapper.hasError){
      emit(FailedLoadingUserPlaylist());
    }else{
      emit(EmptyUserPlaylist());
    }
  }

  void createPlaylistAndAddMovie(String name,bool isPrivate)async{
    emit(CreatingPlaylistAndAddMovieState());
    ApiResponseWrapper<bool> responseWrapper = await _repository.createPlaylistAndAddMovie(name: name, isPrivate: isPrivate, movie: _movieToAdd!);
    if(responseWrapper.data!){
      emit(PlaylistCreatedAndAddedMovieState());
      refreshHomeScreenPlaylists();
    }else{
      emit(FailedCreatingPlaylistState());
    }
  }

  void addMovieToExistingPlaylist(String playlistId)async{
    emit(AddingMovieToPlaylistState());
    ApiResponseWrapper<bool> responseWrapper = await _repository.addToPlaylist(playlistId,_movieToAdd!);
    if(responseWrapper.data!){
      emit(AddedMovieToPlaylistState());
      refreshHomeScreenPlaylists();
    }else{
        emit(FailedAddMovieToPlaylistState(responseWrapper.displayMessage??''));
    }
  }
}