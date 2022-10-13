class UserPlaylistModel {
  String userId;
  List<Playlist> playlists;

  UserPlaylistModel(this.playlists,this.userId);

  factory UserPlaylistModel.fromJson(Map<String, dynamic> json) {
    List<Playlist> temp=[];
    List<dynamic> tempJson= json['playlists'];
    tempJson.forEach((element) {
      temp.add(Playlist.fromJson(element as Map<String, dynamic>));
    });
    return UserPlaylistModel(temp,json['userId']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'playlists': playlists,
      'userId': userId
    };
  }
}

class Playlist{
  String name, playlistId;
  Playlist(this.name, this.playlistId);

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(json['name'], json['playlistId']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'playlistId': playlistId,
    };
  }
}