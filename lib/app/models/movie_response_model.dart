import 'package:json_annotation/json_annotation.dart';

part 'movie_response_model.g.dart';


@JsonSerializable()
class MovieResponseModel extends Object {

  @JsonKey(name: 'Search')
  List<Search>? search;

  @JsonKey(name: 'totalResults')
  String? totalResults;

  @JsonKey(name: 'Response')
  String response;

  @JsonKey(name: 'Error')
  String? error;

  MovieResponseModel(this.search,this.totalResults,this.response,this.error);

  factory MovieResponseModel.fromJson(Map<String, dynamic> srcJson) => _$MovieResponseModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MovieResponseModelToJson(this);

}


@JsonSerializable()
class Search extends Object {

  @JsonKey(name: 'Title')
  String title;

  @JsonKey(name: 'Year')
  String year;

  @JsonKey(name: 'imdbID')
  String imdbID;

  @JsonKey(name: 'Type')
  String type;

  @JsonKey(name: 'Poster')
  String poster;

  Search(this.title,this.year,this.imdbID,this.type,this.poster,);

  factory Search.fromJson(Map<String, dynamic> srcJson) => _$SearchFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SearchToJson(this);

}


