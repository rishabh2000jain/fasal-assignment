import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_library_app/app/models/movie_response_model.dart';

class PlayListResponseModel{
  List<Search> playlist;
  String playlistName;
  DocumentSnapshot? snapshot;
  PlayListResponseModel(this.playlist,this.playlistName,this.snapshot);

  factory PlayListResponseModel.fromJson(Map<String,dynamic> json,DocumentSnapshot snapshot){
    List<dynamic> movies = json['movies'];
    List<Search> playlist=[];
    movies.forEach((element) {
      playlist.add(Search.fromJson(element as Map<String,dynamic>));
    });
    return PlayListResponseModel(playlist,json['playlistName'],snapshot);
  }
}