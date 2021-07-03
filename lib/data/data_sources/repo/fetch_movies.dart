import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_watchlist_app/data/data_sources/repo/base_repo.dart';
import 'package:movie_watchlist_app/data/models/movie_model.dart';
import 'package:movie_watchlist_app/data/models/movies_result_model.dart';
import 'package:movie_watchlist_app/utilities/constants.dart';


class MoviesRepository extends BaseRepo{

  Future<List<MovieModel>> fetchTrendingMovies() async{
    final response = await getItems(ApiConstants.trendingUrl);
    final movies = MovieResultModel.fromJson(response).results;
    return movies;
  }

  Future<List<MovieModel>> fetchPopularMovies() async{
    final response = await getItems(ApiConstants.popularUrl);
    final movies = MovieResultModel.fromJson(response).results;
    return movies;
  }

  Future<List<MovieModel>> fetchUpcomingMovies() async{
    final response = await getItems(ApiConstants.upcomingUrl);
    final movies = MovieResultModel.fromJson(response).results;
    return movies;
  }
}

final MoviesRepository moviesRepository = MoviesRepository();



