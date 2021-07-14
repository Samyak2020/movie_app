import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_watchlist_app/bloc/bloc_collection.dart';
import 'package:movie_watchlist_app/db/movie_modelDB.dart';
import 'package:movie_watchlist_app/db/movies_db.dart';
import 'package:movie_watchlist_app/homescreen/home_screen.dart';
import 'package:movie_watchlist_app/utilities/colors.dart';
import 'package:movie_watchlist_app/widgets/snack_bar_widget.dart';


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
      backgroundColor: AppColors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Watch List",
          //  popularMovies.voteAverage.toString(),
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
          return snapshot.connectionState == ConnectionState.waiting ?
          Center(child: CircularProgressIndicator()):
          ListView.builder(
            itemCount: movies.length,
            shrinkWrap: true,
            itemBuilder: (context, index){
              MovieDBModel offlineMovies = movies[index];
              if(offlineMovies.uid == userId){
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
                            await MovieDB.db.deleteMovie(id : offlineMovies.id);
                            await homeScreenBloc.fetchOfflineWatchListMovies();
                            ScaffoldMessenger.of(context).showSnackBar(customSnackBarWidget(text: "Deleted from WatchList"));
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{
                          //       await castListRepository.fetchCastsList(popularMovies.id);
                          //       List<Trailer> trailerId = await trailerListRepository.fetchTrailers(popularMovies.id);
                          //       // String trailerId = await trailerListRepository.fetchTrailersId(popularMovies.id);
                          //
                          // if( popularMovies.trailerId != null){
                          //   popularMovies.trailerId = trailerId.first.key;
                          //   Navigator.push(context, MaterialPageRoute(builder: (context){
                          //     return DetailsScreen(isMovieModel: false,moviesPaginationList: popularMovies,movieId: popularMovies.id,trailerId: popularMovies.trailerId,isTrailerIdNull: false,);
                          //   }));
                          // }else{
                          //   ScaffoldMessenger.of(context).showSnackBar(customSnackBarWidget(text: "Cant play Trailer"));
                          //   Navigator.push(context, MaterialPageRoute(builder: (context){
                          //     return DetailsScreen(isMovieModel: false,moviesPaginationList: popularMovies,movieId: popularMovies.id,isTrailerIdNull: true,);
                          //   }));
                          // }
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
                                          imageUrl: 'https://image.tmdb.org/t/p/w200${offlineMovies.posterPath}',
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
                                              offlineMovies.title,
                                              style: theme.textTheme.subtitle1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              offlineMovies.releaseDate,
                                              style: theme.textTheme.subtitle2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: screenSize.height * 0.01),
                                            Text(
                                              //widget.movieModel.title ?? widget.moviesPaginationList.title ?? "",
                                              // widget.isMovieModel
                                              //     ? widget.movieModel.overview
                                              //     : widget.moviesPaginationList.overview,
                                              //"OVERview sjafhas bjasfj ajlf lksabfjk asbjf bsalfbla bjfb jbs jkasb fjkasjglj aiohifjj lkahkfasj fhakb jflasbfou iahfjalsbfk jasbf hajsbf lakbsk fja0,",
                                              offlineMovies.overview,
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
                                                    offlineMovies.voteAverage.toString(),
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
