import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_library_app/app/bloc/authentication/auth_bloc.dart';
import 'package:movie_library_app/app/bloc/authentication/auth_states.dart';
import 'package:movie_library_app/app/bloc/playlist/playlist_bloc.dart';
import 'package:movie_library_app/app/bloc/playlist/playlist_states.dart';
import 'package:movie_library_app/app/screens/home/widgets/playlist_view.dart';
import 'package:movie_library_app/resources/app_colors.dart';
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





