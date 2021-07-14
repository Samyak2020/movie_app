

class MovieDBModel{
  final int id;
  final String uid;
  final int movieId;
  final String title;
  final String name;
  final String overview;
  final String releaseDate;
  final double voteAverage;
  final String posterPath;
  final int isWishListed;

  MovieDBModel({this.uid,this.movieId, this.id, this.title, this.name,
    this.overview, this.releaseDate, this.voteAverage, this.posterPath, this.isWishListed = 0});

  factory MovieDBModel.fromMap(Map<String, dynamic> json) =>
      MovieDBModel(uid : json["uid"],
          id: json["id"],
          movieId: json["movie_id"],
          title: json["title"],
          name: json["name"],
          overview: json["overview"],
          releaseDate: json["release_date"],
          voteAverage: json["vote_average"],
          posterPath: json["poster_path"],
          isWishListed: json["is_wishlisted"
          ]
      );

  Map<String, dynamic> toMap()=>{
    "movie_id": movieId,
    "uid": uid,
    "id": id,
    "title" : title,
    "name" : name,
    "overview" : overview,
    "release_date" : releaseDate,
    "vote_average" : voteAverage,
    "poster_path" : posterPath,
    "is_wishlisted" : isWishListed
  };
}