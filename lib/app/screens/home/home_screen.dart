import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_library_app/app/bloc/authentication/auth_bloc.dart';
import 'package:movie_library_app/app/bloc/authentication/auth_states.dart';
import 'package:movie_library_app/app/bloc/playlist/playlist_bloc.dart';
import 'package:movie_library_app/app/bloc/playlist/playlist_states.dart';
import 'package:movie_library_app/app/models/movie_response_model.dart';
import 'package:movie_library_app/app/models/playlist_response_model.dart';
import 'package:movie_library_app/resources/app_%20colors.dart';
import 'package:movie_library_app/resources/images.dart';
import 'package:movie_library_app/services/navigation/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AuthBloc _authBloc;
  late PlaylistBloc _playlistBloc;
  late ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _playlistBloc = BlocProvider.of<PlaylistBloc>(context);
    _playlistBloc.reset();
    _playlistBloc.getPlaylists();
    _authBloc.getUserDetails();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener(){
    if (_scrollController.position.pixels + 10 >=
        _scrollController.position.maxScrollExtent &&
        !_playlistBloc.isDataFinished && _playlistBloc.state is! LoadingPlaylistsState) {
        _playlistBloc.getPlaylists();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          context.push(Routes.kSearch);
        },
        child: const Icon(Icons.search,color: AppColors.primaryVariantColor,),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: BlocListener<AuthBloc,AuthStates>(
          listener: (BuildContext context,AuthStates states){
            if(states is UserLogoutSuccess){
              context.replace(Routes.kInitial);
            }
          },
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BlocBuilder<AuthBloc,AuthStates>(
                      buildWhen: (prev,curr){
                        return curr is LoadedUserDetails || curr is FailedLoadingUserDetails;
                      },
                      builder: (context,state) {
                        if(state is LoadedUserDetails){
                          return Text(
                            "Welcome \n${_authBloc.userDetails?.name ?? ''}!",
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryVariantColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.start,
                          );
                        }
                        return SizedBox();
                      }
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: (){
                      _authBloc.logout();
                    },
                    child: Text(
                      "Logout",
                      style: GoogleFonts.poppins(
                        color: AppColors.greyLight,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Expanded(
                  child:
              BlocBuilder<PlaylistBloc, PlaylistsStates>(
                buildWhen: (prev,curr){
                  return curr is PlaylistState;
                },
                builder: (BuildContext context, PlaylistsStates states) {
                  if (states is EmptyPlaylistsState) {
                    return Center(
                      child: Text(
                        "oops!\nPlaylist not available \nPlease create one",
                        style: GoogleFonts.poppins(
                          color: AppColors.primaryVariantColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (states is LoadingPlaylistsState) {
                    if (states.playlist.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return PlaylistListView(playlist: states.playlist,scrollController: _scrollController,addLoadingIndicator: true,);
                  } else if (states is PlaylistsLoadedState) {
                    return PlaylistListView(playlist: states.playlist,scrollController: _scrollController,);
                  }
                  return const SizedBox.shrink();
                },
              ))
            ],
          ),
        ),
      )),
    );
  }
}

class PlaylistListView extends StatelessWidget {
  const PlaylistListView(
      {required this.playlist,
      required this.scrollController,
      this.addLoadingIndicator = false,
      Key? key})
      : super(key: key);
  final List<PlayListResponseModel> playlist;
  final ScrollController scrollController;
  final bool addLoadingIndicator;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: (){
      BlocProvider.of<PlaylistBloc>(context).refreshHomeScreenPlaylists();
      return Future.delayed(const Duration(milliseconds: 400));
    },
      child: ListView.builder(
        itemCount: addLoadingIndicator ? playlist.length + 1 : playlist.length,
        itemBuilder: (BuildContext context, int index) {
          if (index >= playlist.length) {
            return const Align(
              child: CircularProgressIndicator(),
            );
          }
          return PlaylistWidget(
            playListResponseModel: playlist[index],
          );
        },
      ),
    );
  }
}

class PlaylistWidget extends StatelessWidget {
  const PlaylistWidget({required this.playListResponseModel, Key? key})
      : super(key: key);
  final PlayListResponseModel playListResponseModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            playListResponseModel.playlistName,
            style: GoogleFonts.poppins(
              color: AppColors.primaryVariantColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: playListResponseModel.playlist.length,
              itemBuilder: (BuildContext context, int index) {
                return PlaylistListItem(
                    movie: playListResponseModel.playlist[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlaylistListItem extends StatelessWidget {
  const PlaylistListItem({required this.movie, Key? key}) : super(key: key);
  final Search movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 200,
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                movie.poster,
                width: 100,
                fit: BoxFit.fill,
                errorBuilder: (context,_,stack){
                  return Image.asset(AppImages.placeholder,
                    width: 100,
                    fit: BoxFit.fitWidth,);
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  movie.title,
                  style: GoogleFonts.poppins(
                    color: AppColors.primaryVariantColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
