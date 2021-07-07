import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_watchlist_app/homescreen/home_screen.dart';
import 'package:movie_watchlist_app/utilities/colors.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen();

  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {

  bool isHomeScreen = false;

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
      drawer: buildDrawer(screenSize, theme,context, isHomeScreen),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, builder){
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
              ),
            ),
            Stack(
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
                              imageUrl: 'assets/images/img_not_found.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right:screenSize.width * 0.06,),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Movie Name",
                                  //  popularMovies.voteAverage.toString(),
                                  style: theme.textTheme.subtitle1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "Movie Name",
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
                                  "OVERview sjafhas bjasfj ajlf lksabfjk asbjf bsalfbla bjfb jbs jkasb fjkasjglj aiohifjj lkahkfasj fhakb jflasbfou iahfjalsbfk jasbf hajsbf lakbsk fja0,",
                                  style: theme.textTheme.bodyText1,
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: screenSize.height * 0.01),
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
                                        "Rating",
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
          ]
        );
    },
      ),
    );
}}