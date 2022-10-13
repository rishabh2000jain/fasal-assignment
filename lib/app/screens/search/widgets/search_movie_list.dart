import 'package:flutter/material.dart';
import 'package:movie_library_app/app/models/movie_response_model.dart';
import 'package:movie_library_app/app/screens/search/widgets/movie_list_tile.dart';

class MovieSearchList extends StatelessWidget {
  const MovieSearchList({required this.scrollController,required this.searchList,this.isLoading=false,Key? key}) : super(key: key);
  final List<Search> searchList;
  final ScrollController scrollController;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          controller: scrollController,
          itemCount: isLoading?searchList.length+1:searchList.length,
          itemBuilder: (BuildContext context, int index) {
            if(index>=searchList.length){
              return const Align(child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator()),);
            }
            return SearchListItem(movie: searchList[index]);
          }),
    );
  }
}
