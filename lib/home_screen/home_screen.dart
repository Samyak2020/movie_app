import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_watchlist_app/data/data_sources/repo/fetch_movies.dart';
import 'package:movie_watchlist_app/data/models/movie_model.dart';
import 'package:movie_watchlist_app/data/models/movies_result_model.dart';
import 'package:movie_watchlist_app/home_screen/home_screen_bloc.dart';
import 'package:movie_watchlist_app/utilities/colors.dart';
import 'package:movie_watchlist_app/utilities/constants.dart';


enum MovieCategory{Trending, Popular, Upcoming}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //MoviesRepository moviesRepository = MoviesRepository();


  @override
  void initState() {
    // TODO: implement initState
   // moviesRepository.fetchTrendingMovies();
    homeScreenBloc.fetchMoviesStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        actions: <Widget>[
          IconButton(
            iconSize: 30.0,
            icon: Icon(
              Icons.search,
              color: AppColors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: AppColors.black,
            ),
            Expanded(
              child: Container(
                // color: AppColors.black,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0xffAA70F4).withOpacity(0.15),
                      AppColors.black.withOpacity(0),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 50,
                          child: ClipOval(
                              child: Image(
                                  fit: BoxFit.cover,
                                  height: screenSize.height * 0.25,
                                  width: screenSize.width * 0.25,
                                  image: AssetImage("assets/userimage.jpg"))
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]
        ),
      ),
      body: Column(
        children: [

          Padding(
            padding: EdgeInsets.symmetric(vertical : screenSize.height * 0.025),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Text("Trending",
                    style: theme.textTheme.subtitle2.copyWith(fontWeight: FontWeight.w700, color: AppColors.secondWhite),),
                ),
              ],
            ),
          ),
          buildTrending(screenSize: screenSize, stream: homeScreenBloc.trendingMoviesResponseStream),
        ],
      ),
    );
  }

  StreamBuilder<List<MovieModel>> buildTrending({Size screenSize, Stream stream} ) {
    return StreamBuilder(
            stream: stream,
            builder: (context, snapshot){
              if(snapshot.hasData){
                List<MovieModel> movies = snapshot.data;
               // List movies = snapshot.data;
                print("Is this moviesssss???????? WTFFF $movies");
                return ListView(
                  shrinkWrap: true,
                  children: [
                    CarouselSlider(
                      items: movies.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: CachedNetworkImage(
                                    imageUrl: '${ApiConstants.BASE_IMAGE_URL}${i.posterPath}',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                            );
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: screenSize.height * 0.42,
                        viewportFraction: 0.8,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 5),
                        autoPlayAnimationDuration: Duration(milliseconds: 1500),
                        autoPlayCurve: Curves.ease,
                        enlargeCenterPage: true,
                        // onPageChanged: callbackFunction,
                        scrollDirection: Axis.horizontal,
                      ),),
                  ],
                );
                } else {
                  return Center(
                    child: Text('No data found !!'.toUpperCase()),
                  );
                }
              }
            );
  }
}

