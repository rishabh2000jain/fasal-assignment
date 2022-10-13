import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_library_app/app/bloc/playlist/playlist_bloc.dart';
import 'package:movie_library_app/app/bloc/playlist/playlist_states.dart';
import 'package:movie_library_app/app/screens/common_widgets/loading_widget.dart';
import 'package:movie_library_app/app/screens/search/widgets/create_playlist_dialog.dart';
import 'package:movie_library_app/resources/app_colors.dart';
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
