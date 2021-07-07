import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_watchlist_app/data/models/corousellistmodel/movie_model.dart';
import 'package:movie_watchlist_app/data/models/movieslistmodels/popular_movies_model.dart';
import 'package:movie_watchlist_app/data/models/trailer_model.dart';
import 'package:movie_watchlist_app/data/repo/detailsrepo/fetch_castlist.dart';
import 'package:movie_watchlist_app/data/repo/detailsrepo/fetch_trailer.dart';
import 'package:movie_watchlist_app/detailsscreen/details_screen.dart';
import 'package:movie_watchlist_app/bloc/bloc_collection.dart';
import 'package:movie_watchlist_app/utilities/colors.dart';
import 'package:movie_watchlist_app/utilities/constants.dart';
import 'package:movie_watchlist_app/widgets/snack_bar_widget.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isTrendingSelected = true;
  bool isHomeScreen = true;




  @override
  void initState() {
    // TODO: implement initState
   // moviesRepository.fetchTrendingMovies();
    //homeScreenBloc.fetchMoviesStream();
   // homeScreenBloc.fetchMoviesStream();
    homeScreenBloc.showSelectedCategory(category: "trending");
    homeScreenBloc.fetchMoviesListStream();
    homeScreenBloc.fetchTopRatedMoviesListStream();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.black,
        actions: <Widget>[
          IconButton(
            iconSize: 30.0,
            icon: Icon(
              Icons.search,
              color: AppColors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(ScreenName.SearchScreen);
            },
          ),
        ],
      ),
      drawer: buildDrawer(screenSize, theme,context, isHomeScreen),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      child: Text("Trending",
                        style: theme.textTheme.subtitle2.copyWith(
                            fontSize: isTrendingSelected ? 16 : 14,
                            fontWeight: isTrendingSelected ?FontWeight.w900 : FontWeight.w500,
                            color: isTrendingSelected ? AppColors.white : AppColors.grey),
                      ),
                      onTap: () {
                        setState(() {
                          isTrendingSelected = true;
                          homeScreenBloc.showSelectedCategory(category: "trending");
                        });

                      }
                  ),
                  SizedBox(
                    width: screenSize.width * 0.2,
                  ),
                  // GestureDetector(
                  //   child: Text("Upcoming",
                  //     style: theme.textTheme.subtitle2.copyWith(fontWeight: FontWeight.w700, color: AppColors.secondWhite),),
                  //   onTap: (){
                  //     homeScreenBloc.showSelectedCategory(category: "upcoming");
                  //   },
                  // ),
                  GestureDetector(
                    child: Text("TV",
                      style: theme.textTheme.subtitle2.copyWith(
                          fontSize: isTrendingSelected ? 14 : 16,
                          fontWeight:isTrendingSelected ? FontWeight.w500 : FontWeight.w900,
                          color: isTrendingSelected ?  AppColors.grey : AppColors.white),),
                    onTap: (){
                      setState(() {
                        isTrendingSelected = false;
                        homeScreenBloc.showSelectedCategory(category: "tv");
                      });

                    },
                  ),

                ],
              ),
              SizedBox(
                height: screenSize.height * 0.02,
              ),
              buildCarousel(screenSize: screenSize,
                  stream: homeScreenBloc.showSelectedCategoryControllerStream,
              theme: theme,
              ),
              SizedBox(
                height: screenSize.width * 0.06,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.035,),
                child: Text("Popular",
                  style: theme.textTheme.subtitle2.copyWith(
                      fontSize:  16 ,
                      fontWeight:  FontWeight.w700,
                      color:  AppColors.secondWhite),
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.01,
              ),
              buildPopularMovies(screenSize: screenSize,
                  stream: homeScreenBloc.popularMoviesResponseStream,
              theme: theme,
              ),
              SizedBox(
                height: screenSize.width * 0.06,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.035,),
                child: Text("Top Rated",
                  style: theme.textTheme.subtitle2.copyWith(
                      fontSize:  16 ,
                      fontWeight:  FontWeight.w700,
                      color:  AppColors.secondWhite),
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.01,
              ),
              buildTopRatedMovies(screenSize: screenSize,theme: theme,
                  stream: homeScreenBloc.topRatedMoviesResponseStream,),
              SizedBox(
                height: screenSize.height * 0.025,
              ),
            ],
          ),
        ],
      ),
    );
  }

  StreamBuilder<List<MovieModel>> buildCarousel({Size screenSize, Stream stream, ThemeData theme} ) {
    return StreamBuilder(
            stream: stream,
            builder: (context, snapshot){
              List<MovieModel> movies = snapshot.data;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (!snapshot.hasData) {
                return SizedBox();
              }
                return ListView(
                shrinkWrap: true,
                children: [
                  CarouselSlider(
                    items: movies.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Stack(
                            children: [
                              GestureDetector(
                                onTap : () async{
                                  // await castListRepository.fetchCastsList(i.id);
                                  // List<Trailer> trailerId = await trailerListRepository.fetchTrailers(i.id);
                                  // i.trailerId = trailerId.first.key;
                                  // Navigator.push(context, MaterialPageRoute(builder: (context){
                                  //   return DetailsScreen(isMovieModel: true,
                                  //     movieModel: i,
                                  //     title: isTrendingSelected ? i.title :  i.name,
                                  //   releaseDate: isTrendingSelected ? i.releaseDate :  i.fistAirDate,
                                  //     movieId: i.id,
                                  //       trailerId: i.trailerId
                                  //   );
                                  // }));

                                  await castListRepository.fetchCastsList(i.id);
                                  List<Trailer> trailerId = await trailerListRepository.fetchTrailers(i.id);
                                  if(trailerId != null){
                                    i.trailerId = trailerId.first.key;
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return DetailsScreen(isMovieModel: true,
                                          movieModel: i,
                                          title: isTrendingSelected ? i.title :  i.name,
                                          releaseDate: isTrendingSelected ? i.releaseDate :  i.fistAirDate,
                                          movieId: i.id,
                                          trailerId: i.trailerId,
                                        isTrailerIdNull: false,
                                      );
                                    }));
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(customSnackBarWidget(text: "Cant play Trailer"));
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return DetailsScreen(isMovieModel: true,
                                          movieModel: i,
                                          title: isTrendingSelected ? i.title :  i.name,
                                          releaseDate: isTrendingSelected ? i.releaseDate :  i.fistAirDate,
                                          movieId: i.id,
                                          trailerId: i.trailerId,
                                          isTrailerIdNull: true,
                                      );
                                    }));
                                  }


                                  // await castListRepository.fetchCastsList(i.id);
                                  // List<Trailer> trailerId = await trailerListRepository.fetchTrailers(i.id);
                                  // if( i.trailerId != null){
                                  //   i.trailerId = trailerId.first.key;
                                  //   Navigator.push(context, MaterialPageRoute(builder: (context){
                                  //     return DetailsScreen(isMovieModel: true,movieId: i.id,trailerId: i.trailerId,isTrailerIdNull: false,);
                                  //   }));
                                  // }else{
                                  //   ScaffoldMessenger.of(context).showSnackBar(customSnackBarWidget(text: "Cant play Trailer"));
                                  //   Navigator.push(context, MaterialPageRoute(builder: (context){
                                  //     return DetailsScreen(isMovieModel: true,movieId: i.id,isTrailerIdNull: true,);
                                  //   }));
                                  // }

                                },
                                child: Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        width: MediaQuery.of(context).size.width,
                                        imageUrl: '${ApiConstants.BASE_IMAGE_URL}${i.posterPath}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      foregroundDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                        gradient: LinearGradient(
                                          colors: [Colors.black54, Colors.transparent, Colors.transparent, Colors.black54],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0, 0.25, 0.75, 1],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 15,
                                        left: 15,
                                      ),
                                      child: Text(
                                        isTrendingSelected ? i.title ?? ""  : i.name ?? "",
                                        style: theme.textTheme.subtitle2.copyWith(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold ,
                                            color: AppColors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 12.0,
                                right: 12.0,
                                child: GestureDetector(
                                  child: Icon(Icons.add_box_outlined,
                                    color: AppColors.secondWhite,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                            ]
                          );
                        },
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: screenSize.height / 3.2,
                      viewportFraction: 0.8,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 1500),
                      autoPlayCurve: Curves.easeInOut,
                      enlargeCenterPage: true,
                      // onPageChanged: callbackFunction,
                      scrollDirection: Axis.horizontal,
                    ),),
                ],
              );
            }
            );
  }

  StreamBuilder<List<MoviesPaginationList>> buildPopularMovies({Size screenSize, Stream stream, ThemeData theme} ){
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot){
          List<MoviesPaginationList> movies = snapshot.data;
          return snapshot.connectionState == ConnectionState.waiting ?
          CircularProgressIndicator():
          Container(
            padding: EdgeInsets.only(left: screenSize.width * 0.03),
            height: screenSize.height * 0.35,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              shrinkWrap: true,
               itemBuilder: (context, index){
                 MoviesPaginationList popularMovies = movies[index];
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap : () async{
                          await castListRepository.fetchCastsList(popularMovies.id);
                          List<Trailer> trailerId = await trailerListRepository.fetchTrailers(popularMovies.id);
                          // String trailerId = await trailerListRepository.fetchTrailersId(popularMovies.id);
                          if( popularMovies.trailerId != null){
                            popularMovies.trailerId = trailerId.first.key;
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return DetailsScreen(isMovieModel: false,moviesPaginationList: popularMovies,movieId: popularMovies.id,trailerId: popularMovies.trailerId,isTrailerIdNull: false,);
                            }));
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(customSnackBarWidget(text: "Cant play Trailer"));
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return DetailsScreen(isMovieModel: false,moviesPaginationList: popularMovies,movieId: popularMovies.id,isTrailerIdNull: true,);
                            }));
                          }

                        },
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  screenSize.width * 0.025, 0.0, 0.0, 0.0),
                              child: Stack(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                alignment: Alignment.bottomLeft,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Card(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),
                                          ),
                                          elevation: 3,
                                          child: ClipRRect(
                                            child: CachedNetworkImage(
                                              imageUrl: 'https://image.tmdb.org/t/p/w200${popularMovies.posterPath}',
                                              imageBuilder: (context, imageProvider) {
                                                return Container(
                                                  width: screenSize.width / 2.5,
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10),
                                                  ),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                );
                                              },
                                              placeholder: (context, url) => Container(
                                                width: screenSize.width / 2.5,
                                                child: Center(
                                                  child: Platform.isAndroid
                                                      ? CircularProgressIndicator()
                                                      : CupertinoActivityIndicator(),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => Container(
                                                width: screenSize.width / 2.5,
                                                decoration:
                                                BoxDecoration(image: DecorationImage(
                                                  image: AssetImage('assets/images/img_not_found.jpg'),
                                                  fit: BoxFit.cover,
                                                ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: screenSize.width / 2.5,
                                        child: Text(
                                          //person.name
                                          popularMovies.title ?? "",
                                          style: theme.textTheme.subtitle1.copyWith(
                                            fontWeight:  FontWeight.w500,
                                            color:  AppColors.secondWhite,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.star, color: AppColors.yellow,
                                            size: 18.0,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 5.0),
                                            child: Text(
                                              // person//     .knowForDepartment
                                              popularMovies.voteAverage.toString(),
                                              style: theme.textTheme.subtitle2.copyWith(
                                                  fontWeight:  FontWeight.w400,
                                                  color:  AppColors.secondWhite),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: 3.2,
                                    left: 4,
                                    child: Container(
                                      height:50.0,
                                      width: screenSize.width / 2.5,
                                      foregroundDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        gradient: LinearGradient(
                                          colors: [Colors.black54, Colors.transparent, Colors.transparent, Colors.transparent],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0, 0.9, 0.75, 1],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10.0,
                        right: 10.0,
                        child: GestureDetector(
                          child: Icon(Icons.add_box_outlined,
                            color: AppColors.secondWhite,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ],
                  );
               }
            ),
          );
        }
    );
  }


  StreamBuilder<List<MoviesPaginationList>> buildTopRatedMovies({Size screenSize, Stream stream, ThemeData theme} ){
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot){
          List<MoviesPaginationList> movies = snapshot.data;
          return snapshot.connectionState == ConnectionState.waiting ?
          CircularProgressIndicator():
          Container(
            padding: EdgeInsets.only(left: screenSize.width * 0.03),
            height: screenSize.height * 0.35,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              shrinkWrap: true,
               itemBuilder: (context, index){
                 MoviesPaginationList popularMovies = movies[index];
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap : () async{
                          await castListRepository.fetchCastsList(popularMovies.id);
                          List<Trailer> trailerId = await trailerListRepository.fetchTrailers(popularMovies.id);
                         // String trailerId = await trailerListRepository.fetchTrailersId(popularMovies.id);
                          if( popularMovies.trailerId != null){
                            popularMovies.trailerId = trailerId.first.key;
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return DetailsScreen(isMovieModel: false,moviesPaginationList: popularMovies,movieId: popularMovies.id,trailerId: popularMovies.trailerId,isTrailerIdNull: false,);
                            }));
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(customSnackBarWidget(text: "Cant play Trailer"));
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return DetailsScreen(isMovieModel: false,moviesPaginationList: popularMovies,movieId: popularMovies.id,isTrailerIdNull: true,);
                            }));
                          }

                        },
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  screenSize.width * 0.025, 0.0, 0.0, 0.0),
                              child: Stack(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                alignment: Alignment.bottomLeft,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Card(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),
                                          ),
                                          elevation: 3,
                                          child: ClipRRect(
                                            child: CachedNetworkImage(
                                              imageUrl: 'https://image.tmdb.org/t/p/w200${popularMovies.posterPath}',
                                              imageBuilder: (context, imageProvider) {
                                                return Container(
                                                  width: screenSize.width / 2.5,
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10),
                                                  ),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                );
                                              },
                                              placeholder: (context, url) => Container(
                                                width: screenSize.width / 2.5,
                                                child: Center(
                                                  child: Platform.isAndroid
                                                      ? CircularProgressIndicator()
                                                      : CupertinoActivityIndicator(),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => Container(
                                                width: screenSize.width / 2.5,
                                                decoration:
                                                BoxDecoration(image: DecorationImage(
                                                  image: AssetImage('assets/images/img_not_found.jpg'),
                                                  fit: BoxFit.cover,
                                                ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: screenSize.width / 2.5,
                                        child: Text(
                                          //person.name
                                          popularMovies.title ?? "",
                                          style: theme.textTheme.subtitle1.copyWith(
                                            fontWeight:  FontWeight.w500,
                                            color:  AppColors.secondWhite,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.star, color: AppColors.yellow,
                                            size: 18.0,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 5.0),
                                            child: Text(
                                              // person//     .knowForDepartment
                                              popularMovies.voteAverage.toString(),
                                              style: theme.textTheme.subtitle2.copyWith(
                                                  fontWeight:  FontWeight.w400,
                                                  color:  AppColors.secondWhite),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: 3.2,
                                    left: 4,
                                    child: Container(
                                      height:50.0,
                                      width: screenSize.width / 2.5,
                                      foregroundDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        gradient: LinearGradient(
                                          colors: [Colors.black54, Colors.transparent, Colors.transparent, Colors.transparent],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0, 0.9, 0.75, 1],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10.0,
                        right: 10.0,
                        child: GestureDetector(
                          child: Icon(Icons.add_box_outlined,
                            color: AppColors.secondWhite,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ],
                  );
               }
            ),
          );
        }
    );
  }
}
Drawer buildDrawer(Size screenSize, ThemeData theme, BuildContext context, bool isHomeScreen) {
  return Drawer(
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.black,
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(height: screenSize.height * 0.05),
          Align(
            alignment: Alignment.centerRight,
              child: IconButton(icon:
              Icon(Icons.arrow_back_ios,
                color:AppColors.white,),
                onPressed: () => Navigator.pop(context),
              ),
          ),

          SizedBox(height: screenSize.height * 0.075),
          Padding(
            padding: EdgeInsets.only(left: screenSize.width * 0.035),
            child: Text('Logged in as,',
              style: theme.textTheme.subtitle2
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(screenSize.width * 0.035,8.0,0,screenSize.height * 0.05),
            child: Text('User logged in info',
              style: theme.textTheme.headline2,
            ),
          ),
          Container(
            //  width: screenSize.width * 0.01,
            width: 5,
            height: 1.0,
            color: AppColors.grey,
          ),
          Padding(
            padding: EdgeInsets.only(top: screenSize.height * 0.05),
            child: ListTile(
              title: Text('Home',
                style: theme.textTheme.subtitle1),
              onTap: () {
                isHomeScreen ? Navigator.pop(context) : Navigator.of(context).pushNamed(ScreenName.HomeScreen);
                // Update the state of the app
                // ...s
                // Then close the drawer
              },
            ),
          ),
          SizedBox(height: screenSize.height * 0.03),
          ListTile(
            title: Text("Watch List",
              style: theme.textTheme.subtitle1),
            onTap: () {
              isHomeScreen ?  Navigator.of(context).pushNamed(ScreenName.WatchlistScreen): Navigator.pop(context);
            },
          ),
          SizedBox(height: screenSize.height * 0.05),
          Container(
            padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.04,),
            //  width: screenSize.width * 0.01,
            width: 5,
            height: 1.0,
            color: AppColors.grey,
          ),
          SizedBox(height: screenSize.height * 0.075),
          ListTile(
            title: Text("Logout",
              style: theme.textTheme.subtitle1.copyWith(
                  color:  AppColors.red),),
            trailing: Icon(Icons.logout, color:AppColors.red,),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
             // Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}
