import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_library_app/app/bloc/playlist/playlist_bloc.dart';
import 'package:movie_library_app/app/bloc/playlist/playlist_states.dart';
import 'package:movie_library_app/app/screens/common_widgets/common_rounded_button.dart';
import 'package:movie_library_app/resources/app_colors.dart';

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
