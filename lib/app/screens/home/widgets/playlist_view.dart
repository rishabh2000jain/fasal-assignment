import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_library_app/app/bloc/playlist/playlist_bloc.dart';
import 'package:movie_library_app/app/models/playlist_response_model.dart';
import 'package:movie_library_app/app/screens/home/widgets/playlist_listview.dart';

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