import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_library_app/app/bloc/movie_search/search_bloc.dart';
import 'package:movie_library_app/app/bloc/movie_search/search_events.dart';
import 'package:movie_library_app/app/bloc/movie_search/search_states.dart';
import 'package:movie_library_app/app/bloc/playlist/playlist_bloc.dart';
import 'package:movie_library_app/app/bloc/playlist/playlist_states.dart';
import 'package:movie_library_app/app/screens/common_widgets/common_rounded_button.dart';
import 'package:movie_library_app/app/screens/common_widgets/common_search_widget.dart';
import 'package:movie_library_app/app/screens/common_widgets/loading_widget.dart';
import 'package:movie_library_app/app/screens/search/widgets/search_movie_list.dart';
import 'package:movie_library_app/app/screens/search/widgets/user_playlists_widget.dart';
import 'package:movie_library_app/resources/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchBloc _searchBloc;
  late ScrollController _scrollController;
  String? query;

  @override
  void initState() {
    _scrollController = ScrollController();
    _searchBloc = BlocProvider.of<SearchBloc>(context);
    _scrollController.addListener(_scrollListener);
    _searchBloc.add(ResetStatesEvent());
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels + 10 >=
            _scrollController.position.maxScrollExtent &&
        !_searchBloc.isDataFinished &&
        _searchBloc.state is! LoadingSearchState) {
      _searchBloc.add(SearchMovieEvent(query));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: BlocListener<PlaylistBloc, PlaylistsStates>(
            listenWhen: (prev, curr) {
              return curr is OpenUserPlaylistSheet;
            },
            listener: (BuildContext context, PlaylistsStates state) {
              if (state is OpenUserPlaylistSheet) {
                _showPlaylistSheet();
              }
            },
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SearchTextField(
                          controller: TextEditingController(),
                          onChange: (String query) {
                            this.query = query;
                            _searchBloc.add(SearchMovieEvent(query));
                          },
                          onClear: () {
                            query = null;
                            _searchBloc.add(ResetStatesEvent());
                          },
                          onSubmit: (String query) {
                            query = query;
                          },
                          autoFocus: true),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        onTap: () {
                          context.pop();
                        },
                        child: Text(
                          'close',
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryVariantColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: BlocBuilder<SearchBloc, MovieSearchStates>(
                    builder: (BuildContext context, MovieSearchStates state) {
                      if (state is EmptySearchState) {
                        return Center(
                          child: Text(
                            "No results found!",
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryVariantColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else if (state is LoadingSearchState) {
                        if (state.movies.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return MovieSearchList(
                            scrollController: _scrollController,
                            searchList: state.movies,
                            isLoading: true,
                          );
                        }
                      } else if (state is MoviesLoadedState) {
                        return MovieSearchList(
                          scrollController: _scrollController,
                          searchList: state.movies,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPlaylistSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return const UserPlaylistsWidgets();
        },);
  }


}



