import 'package:movie_watchlist_app/data/models/trailer_model.dart';

import '../cast_list_model.dart';

class MovieModel {
  String originalLanguage;
  String originalTitle;
  String posterPath;
  bool video;
  double voteAverage;
  int id;
  String releaseDate;
  int voteCount;
  String title;
  String name;
  String fistAirDate;
  bool adult;
  String backdropPath;
  String overview;
  List<int> genreIds;
  double popularity;
  String mediaType;
  List<CastList> cast;
  String trailerId;

  MovieModel(
      {this.originalLanguage,
        this.originalTitle,
        this.posterPath,
        this.video,
        this.voteAverage,
        this.id,
        this.releaseDate,
        this.voteCount,
        this.title,
        this.name,
        this.fistAirDate,
        this.adult,
        this.backdropPath,
        this.overview,
        this.genreIds,
        this.popularity,
        this.mediaType,
        this.trailerId,
      });

  MovieModel.fromJson(Map<String, dynamic> json) {
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    posterPath = json['poster_path'];
    video = json['video'];
    voteAverage = json['vote_average'];
    id = json['id'];
    releaseDate = json['release_date'];
    voteCount = json['vote_count'];
    title = json['title'];
    name = json['name'];
    fistAirDate = json['first_air_date'];
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    overview = json['overview'];
    genreIds = json['genre_ids'].cast<int>();
    popularity = json['popularity'];
    mediaType = json['media_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['original_language'] = this.originalLanguage;
    data['original_title'] = this.originalTitle;
    data['poster_path'] = this.posterPath;
    data['video'] = this.video;
    data['vote_average'] = this.voteAverage;
    data['id'] = this.id;
    data['release_date'] = this.releaseDate;
    data['vote_count'] = this.voteCount;
    data['title'] = this.title;
    data['first_air_date'] = this.fistAirDate;
    data['name'] = this.name;
    data['adult'] = this.adult;
    data['backdrop_path'] = this.backdropPath;
    data['overview'] = this.overview;
    data['genre_ids'] = this.genreIds;
    data['popularity'] = this.popularity;
    data['media_type'] = this.mediaType;
    return data;
  }
}