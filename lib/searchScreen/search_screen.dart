import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_watchlist_app/bloc/bloc_collection.dart';
import 'package:movie_watchlist_app/data/models/movieslistmodels/popular_movies_model.dart';
import 'package:movie_watchlist_app/data/models/trailer_model.dart';
import 'package:movie_watchlist_app/data/repo/detailsrepo/fetch_castlist.dart';
import 'package:movie_watchlist_app/data/repo/detailsrepo/fetch_trailer.dart';
import 'package:movie_watchlist_app/detailsscreen/details_screen.dart';
import 'package:movie_watchlist_app/homescreen/home_screen.dart';
import 'package:movie_watchlist_app/utilities/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen();

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  bool isHomeScreen = false;
  final _searchQuery = new TextEditingController();
  Function onTextChanged;
  Timer _debounce;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // _searchQuery.addListener(_onSearchChanged);
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          iconSize: 24.0,
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(
              screenSize.width * 0.05,
              screenSize.height * 0.02,
              screenSize.width * 0.05,
              0.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: AppColors.black,
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondWhite.withOpacity(0.15),
                  offset: Offset(0.0, 1), //(x,y)
                  blurRadius: 3.0,
                ),
              ],
            ),
            child: TextField(
              onChanged: (value){
                print(value);
                homeScreenBloc.fetchSearchMovies(searchQuery: value);
              },
              textAlignVertical: TextAlignVertical.center,
              style: theme.textTheme.subtitle1.copyWith(color: AppColors.white,),
               controller: _searchQuery,
              cursorColor: AppColors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search',
                hintStyle: theme.textTheme.subtitle1
                    .copyWith(color: AppColors.grey),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child:  Icon(
                    Icons.search,
                    size: MediaQuery.of(context).size.width * 0.06,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<MoviesPaginationList>>(
              stream: homeScreenBloc.searchMoviesResponseStream,
              builder: (context, snapshot) {
                List<MoviesPaginationList> movies = snapshot.data;
                print("search result in streambuilder ${snapshot.data}");
                return snapshot.connectionState == ConnectionState.waiting ?
               SizedBox():
                ListView.builder(
                  itemCount: movies.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    MoviesPaginationList searchedMovies = movies[index];
                    return Column(
                      children: [
                        Stack(
                            alignment: Alignment.bottomLeft,
                            children:[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.045, ),
                                child: Container(
                                  height: screenSize.height / 5.5,
                                  margin: const EdgeInsets.only(bottom: 4.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: AppColors.black,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.secondWhite.withOpacity(0.15),
                                        offset: Offset(0.0, 1), //(x,y)
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                right: screenSize.width * 0.04,
                                top: screenSize.height * 0.075,
                                child: IconButton(icon:
                                Icon(Icons.add_box_outlined,
                                  color:AppColors.white,),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async{
                                  await castListRepository.fetchCastsList(searchedMovies.id);
                                  List<Trailer> trailerId = await trailerListRepository.fetchTrailers(searchedMovies.id);
                                  // String trailerId = await trailerListRepository.fetchTrailersId(popularMovies.id);
                                  searchedMovies.trailerId = trailerId.first.key;
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return DetailsScreen(isMovieModel: false,moviesPaginationList: searchedMovies,movieId: searchedMovies.id,trailerId: searchedMovies.trailerId,);
                                  }));
                                },
                                child: Stack(
                                    children: [
                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  screenSize.width * 0.045,
                                                  screenSize.height * 0.04,
                                                  screenSize.width * 0.025,
                                                  2.0),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(15),
                                                child: CachedNetworkImage(
                                                  height: screenSize.height / 4.5,
                                                  width: screenSize.width / 3,
                                                  imageUrl: "https://image.tmdb.org/t/p/w200${searchedMovies.posterPath}",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(right:screenSize.width * 0.15,),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      searchedMovies.title,
                                                      //  popularMovies.voteAverage.toString(),
                                                      style: theme.textTheme.subtitle1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      searchedMovies.releaseDate,
                                                      //  popularMovies.voteAverage.toString(),
                                                      style: theme.textTheme.subtitle2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(height: screenSize.height * 0.01),
                                                    Text(
                                                      //widget.movieModel.title ?? widget.moviesPaginationList.title ?? "",
                                                      // widget.isMovieModel
                                                      //     ? widget.movieModel.overview
                                                      //     : widget.moviesPaginationList.overview,
                                                      searchedMovies.overview,
                                                      style: theme.textTheme.bodyText1,
                                                      textAlign: TextAlign.left,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(height: screenSize.height * 0.012),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.star, color: AppColors.yellow,
                                                          size: 18.0,
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.only(left: 5.0),
                                                          child: Text(
                                                            // person//     .knowForDepartment
                                                            // popularMovies.voteAverage.toString(),
                                                            searchedMovies.voteAverage.toString(),
                                                            style: theme.textTheme.subtitle2.copyWith(
                                                                color:  AppColors.secondWhite),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: screenSize.height * 0.02),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]
                                      ),
                                    ]
                                ),
                              ),
                            ]
                        ),
                      ],
                    );
                  },
                );
              }
            ),
          ),
        ],
      ),
    );
  }
  // _onSearchChanged() {
  //   if (_debounce?.isActive ?? false) _debounce.cancel();
  //   _debounce = Timer(const Duration(milliseconds: 500), () {
  //     // do something with _searchQuery.text
  //     onTextChanged(_searchQuery.text);
  //     print('CustomSearchBar : ' + _searchQuery.text);
  //   });
  // }
}
