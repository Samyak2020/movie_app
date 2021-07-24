
import 'package:movie_watchlist_app/data/models/movieslistmodels/popular_movies_model.dart';

import 'base_repo.dart';

class SearchMoviesRepository extends BaseRepo{

  Future<List<MoviesPaginationList>> fetchSearchQuery(String query) async{
    final response = await getSearchResult(searchQuery: query);
    final result = MoviesPagination.fromJson(response).results;
    return result;
  }
}


final SearchMoviesRepository searchMoviesRepository = SearchMoviesRepository();
