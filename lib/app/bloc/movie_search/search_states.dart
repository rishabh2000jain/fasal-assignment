import 'package:equatable/equatable.dart';
import 'package:movie_library_app/app/models/movie_response_model.dart';

abstract class MovieSearchStates extends Equatable{}

class InitialSearchState extends MovieSearchStates{
  @override
  List<Object?> get props => [];
}

class EmptySearchState extends MovieSearchStates{
  @override
  List<Object?> get props => [];
}

class LoadingSearchState extends MovieSearchStates{
  final List<Search> movies;
  LoadingSearchState(this.movies);
  @override
  List<Object?> get props => [movies];
}

class MoviesLoadedState extends MovieSearchStates{
  final List<Search> movies;
  MoviesLoadedState(this.movies);
  @override
  List<Object?> get props => [movies];
}
