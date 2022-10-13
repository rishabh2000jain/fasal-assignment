import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_library_app/app/models/playlist_response_model.dart';
import 'package:movie_library_app/app/screens/home/widgets/playlist_list_item.dart';
import 'package:movie_library_app/resources/app_colors.dart';

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