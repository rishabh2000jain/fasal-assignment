import 'package:equatable/equatable.dart';
import 'package:movie_library_app/app/models/playlist_response_model.dart';
import 'package:movie_library_app/app/models/user_playlist_model.dart';

abstract class PlaylistsStates extends Equatable{}

abstract class PlaylistState extends PlaylistsStates{}

class InitialPlaylistsState extends PlaylistState{
  @override
  List<Object?> get props => [];
}

class EmptyPlaylistsState extends PlaylistState{
  @override
  List<Object?> get props => [];
}
class LoadingPlaylistsState extends PlaylistState{
  final List<PlayListResponseModel> playlist;
  LoadingPlaylistsState(this.playlist);
  @override
  List<Object?> get props => [playlist];
}

class PlaylistsLoadedState extends PlaylistState{
  final List<PlayListResponseModel> playlist;
  PlaylistsLoadedState(this.playlist);
  @override
  List<Object?> get props => [playlist];
}

class ErrorLoadingPlaylistsState extends PlaylistState{
   ErrorLoadingPlaylistsState();
  @override
  List<Object?> get props => [];
}

abstract class GetUserPlaylistState extends PlaylistsStates{}

class OpenUserPlaylistSheet extends GetUserPlaylistState{
  @override
  List<Object?> get props => [];
}

class LoadingUserPlaylist extends GetUserPlaylistState{
  @override
  List<Object?> get props => [];
}

class LoadedUserPlaylist extends GetUserPlaylistState{
  final List<Playlist> playlists;
  LoadedUserPlaylist(this.playlists);
  @override
  List<Object?> get props => [];
}

class FailedLoadingUserPlaylist extends GetUserPlaylistState{
  FailedLoadingUserPlaylist();
  @override
  List<Object?> get props => [];
}
class EmptyUserPlaylist extends GetUserPlaylistState{
  EmptyUserPlaylist();
  @override
  List<Object?> get props => [];
}

abstract class CreatePlaylistStates extends PlaylistsStates{}

class CreatingPlaylistAndAddMovieState extends CreatePlaylistStates{
  @override
  List<Object?> get props => [];
}
class FailedCreatingPlaylistState extends CreatePlaylistStates{
  @override
  List<Object?> get props => [];
}

class PlaylistCreatedAndAddedMovieState extends CreatePlaylistStates{
  @override
  List<Object?> get props => [];
}

abstract class AddMovieToPlaylistStates extends PlaylistsStates{}

class AddingMovieToPlaylistState extends AddMovieToPlaylistStates{
  @override
  List<Object?> get props => [];
}

class FailedAddMovieToPlaylistState extends AddMovieToPlaylistStates{
  final String? errorMessage;
  FailedAddMovieToPlaylistState(this.errorMessage);
  @override
  List<Object?> get props => [];
}

class AddedMovieToPlaylistState extends AddMovieToPlaylistStates{
  @override
  List<Object?> get props => [];
}
