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
import 'package:movie_library_app/app/models/movie_response_model.dart';
import 'package:movie_library_app/app/screens/common_widgets/common_rounded_button.dart';
import 'package:movie_library_app/app/screens/common_widgets/common_search_widget.dart';
import 'package:movie_library_app/app/screens/common_widgets/loading_widget.dart';
import 'package:movie_library_app/app/screens/search/widgets/search_movie_list.dart';
import 'package:movie_library_app/resources/app_%20colors.dart';
import 'package:movie_library_app/resources/images.dart';

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
    _searchBloc.add(ResetStatesEvent());
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
                      } else if (state is ErrorSearchState) {
                        return Center(
                          child: Text(
                            "oops! Something went wrong",
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryVariantColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
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

class CreatePlaylistDialog extends StatefulWidget {
  const CreatePlaylistDialog({Key? key}) : super(key: key);
  @override
  State<CreatePlaylistDialog> createState() => _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState extends State<CreatePlaylistDialog> {
  final TextEditingController nameController=TextEditingController();
  bool isPrivate=false;


  late PlaylistBloc _playlistBloc;
  @override
  void initState() {
    _playlistBloc = BlocProvider.of<PlaylistBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      backgroundColor: AppColors.primaryColor,
      content: BlocConsumer<PlaylistBloc,PlaylistsStates>(
        listener: (BuildContext context,PlaylistsStates states){
          if(states is PlaylistCreatedAndAddedMovieState){
            Navigator.pop(context,true);
          }else if(states is FailedCreatingPlaylistState){
            Fluttertoast.showToast(msg: 'Failed to create playlist.');
          }
        },
        buildWhen: (prev,curr){
          return curr is CreatePlaylistStates;
        },
        builder: (BuildContext context,PlaylistsStates states){
          if(states is CreatingPlaylistAndAddMovieState){
            return const SizedBox(
                height: 200,
                width: 240,
                child:  Center(child: CircularProgressIndicator(),));
          }
          return SizedBox(
            height: 200,
            width: 240,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(decoration: InputDecoration(hintText: 'Playlist Name',hintStyle:GoogleFonts.poppins(
                  color: AppColors.greyLight,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryVariantColor))),
                  controller: nameController,style:GoogleFonts.poppins(
                    color: AppColors.primaryVariantColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: Colors.white,
                      ),
                      child: Checkbox(value: isPrivate, onChanged: (value){
                        isPrivate = value??false;
                        setState(() {

                        });
                      }),
                    ),
                    const SizedBox(width: 5,),
                    Text(
                      'Private',
                      style: GoogleFonts.poppins(
                        color: AppColors.primaryVariantColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30,),
                Row(
                  children: [
                    Expanded(child: CommonRoundedButton(buttonText: 'cancel', isDark: true, onTap: (){
                      Navigator.pop(context,false);
                    })),
                    const SizedBox(width: 5,),
                    Expanded(child: CommonRoundedButton(buttonText: 'ok', isDark: false, onTap: (){
                      if(nameController.text.isNotEmpty){
                        _playlistBloc.createPlaylistAndAddMovie(nameController.text, isPrivate);
                      }else{
                        Fluttertoast.showToast(msg: 'Playlist name can not be empty.');
                      }
                    })),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}


class UserPlaylistsWidgets extends StatefulWidget {
  const UserPlaylistsWidgets({Key? key}) : super(key: key);
  @override
  State<UserPlaylistsWidgets> createState() => _UserPlaylistsWidgetsState();
}

class _UserPlaylistsWidgetsState extends State<UserPlaylistsWidgets> {
  late PlaylistBloc _playlistBloc;
  @override
  void initState() {
    _playlistBloc = BlocProvider.of<PlaylistBloc>(context);
    _playlistBloc.loadUserPlaylist();
    super.initState();
  }

  Future<bool> _showCreatePlaylistDialog()async{
    var isComplete = await showDialog(context: context, builder: (BuildContext context){
      return const CreatePlaylistDialog();
    });
    return isComplete==true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.primaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  onTap: () async{
                   bool isComplete = await _showCreatePlaylistDialog();
                   if(isComplete){
                     Navigator.pop(context);
                   }
                  },
                  child: Text(
                    'Create Playlist',
                    style: GoogleFonts.poppins(
                      color: AppColors.primaryVariantColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                InkWell(
                    onTap: () {
                     Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.clear,
                      color: AppColors.primaryVariantColor,
                    ))
              ],
            ),
          ),
          const Divider(
            color: AppColors.primaryVariantColor,
          ),
          Expanded(
            child: BlocConsumer<PlaylistBloc,PlaylistsStates>(
              listener: (context,states){
                if(states is FailedAddMovieToPlaylistState){
                  LoadingAlert.remove(context);
                  Navigator.pop(context);
                  if(states.errorMessage!=null){
                    Fluttertoast.showToast(msg: states.errorMessage!,gravity: ToastGravity.CENTER);
                  }
                }else if(states is AddedMovieToPlaylistState){
                  LoadingAlert.remove(context);
                  Navigator.pop(context);
                }else if(states is AddingMovieToPlaylistState){
                  LoadingAlert.show(context);
                }
              },
              buildWhen: (prev,curr){
                return curr is GetUserPlaylistState;
              },
              builder: (context,states) {
                if(states is LoadingUserPlaylist){
                  return const Center(child: CircularProgressIndicator(),);
                }else if(states is LoadedUserPlaylist){
                  return ListView.builder(
                      itemCount: states.playlists.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: (){
                            _playlistBloc.addMovieToExistingPlaylist(states.playlists[index].playlistId);
                          },
                          title: Text(
                            states.playlists[index].name,
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryVariantColor,
                              fontSize: 19,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      });
                }else if(states is FailedLoadingUserPlaylist){
                  return Center(
                    child: Text(
                      "Failed to load playlists!",
                      style: GoogleFonts.poppins(
                        color: AppColors.primaryVariantColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }else{
                  return Center(
                    child: Text(
                      "No playlist found",
                      style: GoogleFonts.poppins(
                        color: AppColors.primaryVariantColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              }
            ),
          ),
        ],
      ),
    );
  }
}