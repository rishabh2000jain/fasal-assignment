abstract class SearchMovieEvents{}

class SearchMovieEvent extends SearchMovieEvents{
  final String? searchQuery;
  SearchMovieEvent(this.searchQuery);
}

class ResetStatesEvent extends SearchMovieEvents{
  ResetStatesEvent();
}