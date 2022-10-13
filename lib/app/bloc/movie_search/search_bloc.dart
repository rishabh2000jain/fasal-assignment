import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_library_app/api_response_wrapper.dart';
import 'package:movie_library_app/app/bloc/movie_search/search_events.dart';
import 'package:movie_library_app/app/bloc/movie_search/search_states.dart';
import 'package:movie_library_app/app/models/movie_response_model.dart';
import 'package:movie_library_app/app/repository/playlist_repository.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class SearchBloc extends Bloc<SearchMovieEvents,MovieSearchStates>{
  final MoviesRepository _repository;
  final List<Search> movies=[];
  bool _isDataFinished=false;
  int currPage=1,totalItems=0;
  String? lastQuery;
  SearchBloc(this._repository) : super(InitialSearchState()){
    on<SearchMovieEvent>(searchMovies,transformer:debounceSequential(const Duration(milliseconds: 300)));
    on<ResetStatesEvent>(reset);
  }
  bool get isDataFinished => _isDataFinished;

  EventTransformer<SearchMovieEvents> debounceSequential<SearchMovieEvents>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).asyncExpand(mapper);
  }

  void _resetVariables(){
    lastQuery = null;
    movies.clear();
    _isDataFinished=false;
    currPage=1;
  }

  void reset(ResetStatesEvent event,Emitter emit){
    _resetVariables();
    totalItems=0;
    emit(InitialSearchState());
  }

  Future<void> searchMovies(SearchMovieEvent event,Emitter emit)async{
    String? searchQuery = event.searchQuery;

    if(lastQuery!=searchQuery){
      _resetVariables();
    }
    if(searchQuery==null || searchQuery.isEmpty || isDataFinished){
      return;
    }

    lastQuery = searchQuery;
    emit(LoadingSearchState(movies));
    ApiResponseWrapper <MovieResponseModel> responseWrapper= await _repository.searchMovies(searchQuery, currPage);
    if(responseWrapper.hasData && responseWrapper.data!.search!=null){
      totalItems = int.parse(responseWrapper.data!.totalResults??'0');
      movies.addAll(responseWrapper.data!.search!);
      if(movies.length>=totalItems){
        _isDataFinished = true;
      }
      currPage++;
      emit(MoviesLoadedState(movies));
    }else{
      emit(EmptySearchState());
    }
  }

}