import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_library_app/app/models/movie_response_model.dart';
import 'package:movie_library_app/resources/app_colors.dart';
import 'package:movie_library_app/resources/images.dart';

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
                    fit: BoxFit.fill,);
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
