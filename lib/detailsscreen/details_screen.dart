import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_watchlist_app/data/models/cast_list_model.dart';
import 'package:movie_watchlist_app/data/models/corousellistmodel/movie_model.dart';
import 'package:movie_watchlist_app/data/models/movieslistmodels/popular_movies_model.dart';
import 'package:movie_watchlist_app/homescreen/home_screen_bloc.dart';
import 'package:movie_watchlist_app/utilities/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatefulWidget {

  DetailsScreen({this.isMovieModel, this.moviesPaginationList, this.movieModel,  this.movieId,this.title, this.releaseDate,this.trailerId});

  MovieModel movieModel;
  MoviesPaginationList moviesPaginationList;
  bool isMovieModel;
  int movieId;
  String title;
  String releaseDate;
  String trailerId;

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}


class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Future<void> _launched;
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
    homeScreenBloc.fetchCastList(widget.movieId);
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
        actions: <Widget>[
          IconButton(
            iconSize: 24.0,
            icon: Icon(
              Icons.add_box_outlined,
              color: AppColors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        //children: [
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: screenSize.height / 2.5,
              child: CachedNetworkImage(
                                imageUrl: 'https://image.tmdb.org/t/p/w200${widget.isMovieModel
                    ? widget.movieModel.backdropPath
                    : widget.moviesPaginationList.backdropPath}',
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
              top:  screenSize.height / 5.6,
              left: screenSize.width / 2.4,
              child: GestureDetector(
                onTap: () async {
                  _launched = _launchInBrowser(
                      _youtubeUrlConstant + widget.trailerId);
                },
                child: Icon(
                  Icons.play_circle_outline,
                  color: AppColors.white,
                  size: 80,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // builderTrailer(
                //   screenSize: screenSize,
                //   theme: theme,
                //   stream: homeScreenBloc.trailerListResponseStream,
                // ),
                SizedBox(
                  height: screenSize.height / 2.5,
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
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            //widget.movieModel.title ?? widget.moviesPaginationList.title ?? "",
                            widget.isMovieModel ? widget.title : widget
                                .moviesPaginationList.title,
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
                              widget.isMovieModel ? widget.releaseDate : widget
                                  .moviesPaginationList.releaseDate,
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
                              widget.isMovieModel ? widget.movieModel
                                  .originalLanguage.toUpperCase() : widget
                                  .moviesPaginationList.originalLanguage
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
                                    widget.isMovieModel ? widget.movieModel
                                        .voteAverage.toString() : widget
                                        .moviesPaginationList.voteAverage
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
                        padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0),
                        child: Text(
                          //widget.movieModel.title ?? widget.moviesPaginationList.title ?? "",
                          "Summary",
                          style: theme.textTheme.subtitle1.copyWith(
                              color: AppColors.white),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0),
                        child: Text(
                          //widget.movieModel.title ?? widget.moviesPaginationList.title ?? "",
                          widget.isMovieModel
                              ? widget.movieModel.overview
                              : widget.moviesPaginationList.overview,
                          style: theme.textTheme.bodyText1,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 24.0, 23.0, 0),
                        child: Text(
                          //widget.movieModel.title ?? widget.moviesPaginationList.title ?? "",
                          "Cast",
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
                FutureBuilder<void>(future: _launched, builder: _launchStatus),
              ],
            ),
          ],
        ),
        //],
      ),
    );
  }

  StreamBuilder<List<Cast>> buildCastList(
      {Size screenSize, Stream stream, ThemeData theme}) {
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          List<Cast> castList = snapshot.data;
          return snapshot.connectionState == ConnectionState.waiting ?
          CircularProgressIndicator() : Container(
            padding: EdgeInsets.only(left: screenSize.width * 0.03),
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
                              // crossAxisAlignment: CrossAxisAlignment.start,
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
        }
    );
  }
}