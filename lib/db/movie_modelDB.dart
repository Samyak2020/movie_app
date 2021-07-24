

import 'package:flutter/cupertino.dart';

class MovieDBModel{
  final String uid;
  final int movieId;
  final String title;
  final String trailerId;
  final String overview;
  final String releaseDate;
  final double voteAverage;
  final String posterPath;
  final int isWishListed;
  final String backDropPath;
  final String language;

  MovieDBModel({ @required this.uid, @required this.movieId, @required this.title, @required this.trailerId,
  @required this.overview,@required this.releaseDate,@required this.voteAverage,@required this.posterPath,
    this.isWishListed = 0,@required this.backDropPath, this.language});

  factory MovieDBModel.fromMap(Map<String, dynamic> json) =>
      MovieDBModel(uid : json["uid"],
          movieId: json["movie_id"],
          title: json["title"],
          trailerId: json["trailer_id"],
          overview: json["overview"],
          releaseDate: json["release_date"],
          voteAverage: json["vote_average"],
          posterPath: json["poster_path"],
          backDropPath: json["backdrop_path"],
          language: json["language"],
          isWishListed: json["is_wishlisted"
          ]
      );

  Map<String, dynamic> toMap()=>{
    "movie_id": movieId,
    "uid": uid,
    "title" : title,
    "trailer_id" : trailerId,
    "overview" : overview,
    "release_date" : releaseDate,
    "vote_average" : voteAverage,
    "poster_path" : posterPath,
    "backdrop_path" : backDropPath,
    "language" : language,
    "is_wishlisted" : isWishListed
  };
}