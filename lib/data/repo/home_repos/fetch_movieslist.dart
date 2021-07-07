import 'package:movie_watchlist_app/data/models/movieslistmodels/popular_movies_model.dart';
import 'package:movie_watchlist_app/data/repo/base_repo.dart';
import 'package:movie_watchlist_app/homescreen/home_screen_bloc.dart';
import 'package:movie_watchlist_app/utilities/constants.dart';


class MoviesListRepository extends BaseRepo{

  Future<List<MoviesPaginationList>> fetchPopularMovies() async{
    final response = await getItems(ApiConstants.popularUrl);
    final movies = MoviesPagination.fromJson(response).results;
    return movies;
  }

  Future<List<MoviesPaginationList>> fetchTopRatedMovies() async{
    final response = await getItems(ApiConstants.topRatedUrl);
    final movies = MoviesPagination.fromJson(response).results;
    print("Movies at repo $movies");
    return movies;
  }
}

final MoviesListRepository moviesListRepository = MoviesListRepository();



