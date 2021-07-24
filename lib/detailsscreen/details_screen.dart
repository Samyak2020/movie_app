import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_watchlist_app/data/models/cast_list_model.dart';
import 'package:movie_watchlist_app/data/models/corousellistmodel/movie_model.dart';
import 'package:movie_watchlist_app/data/models/movieslistmodels/popular_movies_model.dart';
import 'package:movie_watchlist_app/bloc/bloc_collection.dart';
import 'package:movie_watchlist_app/db/movie_modelDB.dart';
import 'package:movie_watchlist_app/db/movies_db.dart';
import 'package:movie_watchlist_app/homescreen/home_screen.dart';
import 'package:movie_watchlist_app/utilities/colors.dart';
import 'package:movie_watchlist_app/utilities/connectivity.dart';
import 'package:movie_watchlist_app/widgets/snack_bar_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatefulWidget {

  DetailsScreen({this.isMovieModel,@required this.overView,@required this.language,@required this.voteAverage,@required this.backDropPath,
  @required this.movieId,@required this.title,@required this.releaseDate,@required this.trailerId,
  this.isTrailerIdNull = false,this.isWishListed = false,@required this.posterPath, this.hasConnection = true});


  bool isMovieModel;
  int movieId;
  String title;
  String releaseDate;
  String trailerId;
  bool isTrailerIdNull;
  bool isWishListed;
  String backDropPath;
  String posterPath;
  String language;
  double voteAverage;
  String overView;
  bool hasConnection;


  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}


class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Future<void> _launched;
  String uid = auth.currentUser.uid;
  String _youtubeUrlConstant = 'https://www.youtube.com/embed/';

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return const Text('');
    }
  }


  void initState() {
    // TODO: implement initState
    super.initState();
      if(widget.hasConnection == true) {
        homeScreenBloc.fetchCastList(widget.movieId);
        homeScreenBloc.movieIsInTheDb(movieId: widget.movieId);
      }
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery
        .of(context)
        .size;
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
      ),
      body: SingleChildScrollView(
        //children: [
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: screenSize.height / 2.5,
              child: CachedNetworkImage(
                                imageUrl: 'https://image.tmdb.org/t/p/w200${widget.backDropPath}',
                imageBuilder: (context, imageProvider) {
                  return Container(
                    width: screenSize.width / 2.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                placeholder: (context, url) =>
                    Container(
                      width: screenSize.width / 2.5,
                      child: Center(
                        child: Platform.isAndroid
                            ? CircularProgressIndicator()
                            : CupertinoActivityIndicator(),
                      ),
                    ),
                errorWidget: (context, url, error) =>
                    Container(
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
            Container(
              width: screenSize.width,
              height: screenSize.height / 2.5,
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                gradient: LinearGradient(
                  colors: [
                    Colors.black38,
                    Colors.transparent,
                    Colors.transparent,
                    Colors.transparent
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 1, 1, 1],
                ),
              ),
            ),
            Positioned(
              top:  screenSize.height / 6,
              left: screenSize.width / 2.35,
              child: GestureDetector(
                onTap: () async {
                  if(widget.isTrailerIdNull != true){
                    _launched = _launchInBrowser(
                        _youtubeUrlConstant + widget.trailerId);
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(customSnackBarWidget(text: "Cant play Trailer"));
                  }
                },
                child: widget.isTrailerIdNull ? Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(borderRadius:
                  BorderRadius.circular(50.0),
                    border: Border.all(
                        color: AppColors.blue,
                        width: 5.0
                    ),
                    color: AppColors.blue,),
                  child: Icon(
                    Icons.image_not_supported_sharp,
                    color: AppColors.white,
                    size: 60.0,
                  ),
                ):Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(borderRadius:
                  BorderRadius.circular(50.0),
                    border: Border.all(
                        color: AppColors.blue,
                        width: 5.0
                    ),
                    color: AppColors.blue,),
                  child: Icon(
                    Icons.play_arrow,
                    color: AppColors.white,
                    size: 60.0,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // ),
                SizedBox(
                  height: screenSize.height / 2.4,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10),
                    ),
                    color: AppColors.black,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.025, horizontal: screenSize.width * 0.05),
                          child: Text(
                            widget.title,
                            style: theme.textTheme.headline2.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              //widget.movieModel.title ?? widget.moviesPaginationList.title ?? "",
                              widget.releaseDate,
                              style: theme.textTheme.subtitle2,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              //widget.movieModel.title ?? widget.moviesPaginationList.title ?? "",
                              "|",
                              style: theme.textTheme.subtitle2,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              //widget.movieModel.title ?? widget.moviesPaginationList.title ?? "",
                              widget.language
                                  .toUpperCase(),
                              style: theme.textTheme.subtitle2,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              //widget.movieModel.title ?? widget.moviesPaginationList.title ?? "",
                              "|",
                              style: theme.textTheme.subtitle2,
                              textAlign: TextAlign.center,
                            ),
                            Row(
                              children: [
                                Icon(Icons.star, color: AppColors.yellow,
                                  size: 18.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    //widget.movieModel.title ?? widget.moviesPaginationList.title ?? "",
                                    widget.voteAverage
                                        .toString(),
                                    style: theme.textTheme.subtitle2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.0, screenSize.width * 0.1, 16.0, 0),
                        child: Text(
                          //widget.movieModel.title ?? widget.moviesPaginationList.title ?? "",
                          "Summary",
                          style: theme.textTheme.subtitle1.copyWith(
                              color: AppColors.white),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(screenSize.width * 0.06, 10.0, screenSize.width * 0.05, 0),
                        child: Text(
                          //widget.movieModel.title ?? widget.moviesPaginationList.title ?? "",
                          widget.overView,
                          style: theme.textTheme.bodyText1,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 24.0, 23.0, 0),
                        child: Text(
                          //widget.movieModel.title ?? widget.moviesPaginationList.title ?? "",
                          widget.hasConnection ? "Cast" : "",
                          style: theme.textTheme.subtitle1.copyWith(
                              color: AppColors.white),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      buildCastList(screenSize: screenSize,
                          theme: theme,
                          stream: homeScreenBloc.castListResponseStream),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
                top:  screenSize.height / 2.8,
                left: screenSize.width / 1.25,
                child: buildIconButton(theme)),
          ],
        ),
        //],
      ),
    );
  }

  Widget buildIconButton(ThemeData theme) {
    return  StreamBuilder(
      stream: homeScreenBloc.movieIsInDb,
      builder: (context, snapshot) {
        MovieDBModel movie = snapshot.data;
        if( snapshot.connectionState == ConnectionState.waiting){
          Center(child: CircularProgressIndicator());
        }// if(movieDBModel != null && movieDBModel.movieId == widget.movieId){

          if(movie != null && movie.movieId == widget.movieId && movie.isWishListed == 1){
            return GestureDetector(
              onTap: () async {
                await MovieDB.db.deleteMovie(id : widget.movieId);
                ScaffoldMessenger.of(context).showSnackBar(customSnackBarWidget(text: "Removed from Watchlist"));
                homeScreenBloc.movieIsInTheDb();
              },
              child: Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(borderRadius:
                BorderRadius.circular(50.0),
                  border: Border.all(
                      color: AppColors.blue,
                      width: 5.0
                  ),
                  color: AppColors.blue,),
                child: Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: 50.0,
                ),
              ),
            );
          }else {
            return GestureDetector(
              onTap: () async{
                await MovieDB.db.insertData(
                  MovieDBModel(
                      posterPath:  widget.posterPath,
                      title :  widget.title,
                      movieId:  widget.movieId,
                      uid: uid,
                      backDropPath: widget.backDropPath,
                      language: widget.language,
                      overview: widget.overView,
                      voteAverage: widget.voteAverage,
                      releaseDate:  widget.releaseDate,
                      isWishListed: 1,
                    trailerId: widget.trailerId
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(customSnackBarWidget(text: "Added To Watchlist"));
                homeScreenBloc.movieIsInTheDb(movieId: widget.movieId);
                // }
              },
              child: Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(borderRadius:
                BorderRadius.circular(50.0),
                  border: Border.all(
                    color: AppColors.blue,
                    width: 5.0
                  ),
                  color: AppColors.blue
                ),
                child: Icon(
                  Icons.add,
                  color: AppColors.white,
                  size: 50.0,
                ),
              ),
            );
          }
      }
    );
  }

  StreamBuilder<List<Cast>> buildCastList(
      {Size screenSize, Stream stream, ThemeData theme}) {
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          List<Cast> castList = snapshot.data;
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return Container(
            padding: EdgeInsets.only(left: screenSize.width * 0.04),
            height: screenSize.height * 0.4,
            child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: castList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Cast cast = castList[index];
                  return Stack(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                screenSize.width * 0.025, 0.0, 0.0, 0.0),
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                        ),
                                        elevation: 3,
                                        child: ClipRRect(
                                          child: CachedNetworkImage(
                                            imageUrl: 'https://image.tmdb.org/t/p/w200${cast
                                                .profilePath}',
                                            imageBuilder: (context,
                                                imageProvider) {
                                              return Container(
                                                width: screenSize.width / 3,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(10),
                                                  ),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            },
                                            placeholder: (context, url) =>
                                                Container(
                                                  width: screenSize.width / 3,
                                                  child: Center(
                                                    child: Platform.isAndroid
                                                        ? CircularProgressIndicator()
                                                        : CupertinoActivityIndicator(),
                                                  ),
                                                ),
                                            errorWidget: (context, url,
                                                error) =>
                                                Container(
                                                  width: screenSize.width / 3,
                                                  decoration:
                                                  BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/img_not_found.jpg'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: screenSize.width / 3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Text(
                                              //person.name
                                              cast.name ?? "",
                                              style: theme.textTheme.subtitle1
                                                  .copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.secondWhite,
                                              ),
                                            ),
                                            Text(
                                              cast.character ?? "",
                                              style: theme.textTheme.subtitle2
                                                  .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.secondWhite),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
            ),
          );
          }else{
            return SizedBox();
          }
        }
    );
  }
}