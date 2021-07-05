import 'package:movie_watchlist_app/data/models/moviespaginationmodel/movies_pagination.dart';
import 'package:movie_watchlist_app/data/repo/base_repo.dart';
import 'package:movie_watchlist_app/utilities/constants.dart';


class MoviesListRepository extends BaseRepo{

  Future<List<MoviesPaginationList>> fetchPopularMovies() async{
    final response = await getItems(ApiConstants.popularUrl);
    final movies = MoviesPagination.fromJson(response).results;
    return movies;
  }
}

final MoviesListRepository moviesListRepository = MoviesListRepository();



