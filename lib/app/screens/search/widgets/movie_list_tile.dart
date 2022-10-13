import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_library_app/app/bloc/playlist/playlist_bloc.dart';
import 'package:movie_library_app/app/models/movie_response_model.dart';
import 'package:movie_library_app/resources/app_colors.dart';
import 'package:movie_library_app/resources/images.dart';

class SearchListItem extends StatelessWidget {
  const SearchListItem({required this.movie, Key? key}) : super(key: key);
  final Search movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 80,
      color: AppColors.primaryDarkColor,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Image.network(
              movie.poster,
              fit: BoxFit.fitWidth,
              errorBuilder: (context,_,stack){
                return Image.asset(AppImages.placeholder, fit: BoxFit.fitWidth,);
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      color: AppColors.primaryVariantColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${movie.type} | ${movie.year}',
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          color: AppColors.primaryVariantColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          BlocProvider.of<PlaylistBloc>(context).openPlaylistSheetToAddMovie(movie);
                        },
                        child: const Icon(
                          Icons.library_add,
                          color: AppColors.primaryVariantDarkColor,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
