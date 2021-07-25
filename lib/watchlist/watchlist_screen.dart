import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_watchlist_app/bloc/bloc_collection.dart';
import 'package:movie_watchlist_app/data/models/movieslistmodels/popular_movies_model.dart';
import 'package:movie_watchlist_app/data/models/trailer_model.dart';
import 'package:movie_watchlist_app/data/repo/detailsrepo/fetch_castlist.dart';
import 'package:movie_watchlist_app/data/repo/detailsrepo/fetch_trailer.dart';
import 'package:movie_watchlist_app/db/movie_modelDB.dart';
import 'package:movie_watchlist_app/db/movies_db.dart';
import 'package:movie_watchlist_app/homescreen/home_screen.dart';
import 'package:movie_watchlist_app/utilities/colors.dart';
import 'package:movie_watchlist_app/utilities/connectivity.dart';
import 'package:movie_watchlist_app/widgets/snack_bar_widget.dart';
import 'package:movie_watchlist_app/detailsscreen/details_screen.dart';
import 'package:tap_debouncer/tap_debouncer.dart';


class WatchlistScreen extends StatefulWidget {
  WatchlistScreen( {this.uid});

  String uid;

  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {

  bool isHomeScreen = false;
  String userEmail = auth.currentUser.email;
  String userId = auth.currentUser.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeScreenBloc.fetchOfflineWatchListMovies();
  }




  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.black,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "WATCH LIST",
          style: theme.textTheme.headline2.copyWith(
              color:  AppColors.secondWhite),
        ),
      ),
      drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black.withOpacity(0.7),
          ),
          child: buildDrawer(screenSize, theme,context, isHomeScreen, loggedInAsEmail: userEmail)),
      body: StreamBuilder(
        stream: homeScreenBloc.offlineWatchListStream,
        builder: (context, snapshot) {
          List<MovieDBModel> movies = snapshot.data;
          List<MoviesPaginationList> moviePagniationListItems;
          return snapshot.connectionState == ConnectionState.waiting ?
          Center(child: CircularProgressIndicator()):
          ListView.builder(
            itemCount: movies.length,
            shrinkWrap: true,
            itemBuilder: (context, index){
              MovieDBModel movie = movies[index];
             // MoviesPaginationList moviesPaginationList = moviePagniationListItems[index];
              if(movie.uid == userId){
                return Stack(
                    alignment: Alignment.bottomLeft,
                    children:[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.045, ),
                        child: Container(
                          height: screenSize.height / 5.5,
                          margin: const EdgeInsets.only(bottom: 4.0), //Same as `blurRadius` i guess
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
                        Icon(Icons.cancel_outlined,
                          color:AppColors.red,),
                          onPressed: () async{
                            await MovieDB.db.deleteMovie(id : movie.movieId);
                            await homeScreenBloc.fetchOfflineWatchListMovies();
                            homeScreenBloc.movieIsInTheDb();
                            ScaffoldMessenger.of(context).showSnackBar(customSnackBarWidget(text: "Deleted from WatchList"));
                          },
                        ),
                      ),
                      TapDebouncer(
                          onTap: () async{
                            await internetConnectionUtils.checkConnection().then((isConnected) async{
                              if(isConnected == false){
                                if(movie.trailerId != null){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return DetailsScreen(isMovieModel: false,movieId: movie.movieId,trailerId: movie.trailerId,
                                      isTrailerIdNull: false, backDropPath: movie.backDropPath,language: movie.language,
                                      title: movie.title, releaseDate: movie.releaseDate, posterPath: movie.posterPath,
                                      voteAverage: movie.voteAverage, overView: movie.overview, hasConnection: false,
                                    );
                                  }));
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(customSnackBarWidget(text: "Cant play Trailer"));
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return DetailsScreen(isMovieModel: false,movieId: movie.movieId,
                                      isTrailerIdNull: true, backDropPath: movie.backDropPath,language: movie.language,
                                      title: movie.title, releaseDate: movie.releaseDate, posterPath: movie.posterPath,
                                      voteAverage: movie.voteAverage, overView: movie.overview, hasConnection: false,);
                                  }));
                                }
                              }else{
                                await castListRepository.fetchCastsList(movie.movieId);
                                List<Trailer> trailerId = await trailerListRepository.fetchTrailers(movie.movieId);
                                if(trailerId != null){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return DetailsScreen(isMovieModel: false,movieId: movie.movieId,trailerId: movie.trailerId,
                                      isTrailerIdNull: false, backDropPath: movie.backDropPath,language: movie.language,
                                      title: movie.title, releaseDate: movie.releaseDate, posterPath: movie.posterPath,
                                      voteAverage: movie.voteAverage, overView: movie.overview,
                                    );
                                  }));
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(customSnackBarWidget(text: "Cant play Trailer"));
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return DetailsScreen(isMovieModel: false,movieId: movie.movieId,
                                      isTrailerIdNull: true, backDropPath: movie.backDropPath,language: movie.language,
                                      title: movie.title, releaseDate: movie.releaseDate, posterPath: movie.posterPath,
                                      voteAverage: movie.voteAverage, overView: movie.overview,);
                                  }));
                                }
                              }
                            }
                            );
                          },
                          builder: (BuildContext context, TapDebouncerFunc onTap) {
                            return GestureDetector(
                              onTap: onTap,
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
                                                imageUrl: 'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(right:screenSize.width * 0.15),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    movie.title,
                                                    style: theme.textTheme.subtitle1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    movie.releaseDate,
                                                    style: theme.textTheme.subtitle2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: screenSize.height * 0.01),
                                                  Text(
                                                    movie.overview,
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
                                                          movie.voteAverage.toString(),
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
                            );
                          })
                    ]
                );
              }else{
                return SizedBox();
              }
              },
          );
        }
      ),
    );
}}
