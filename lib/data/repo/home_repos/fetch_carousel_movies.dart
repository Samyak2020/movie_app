import 'package:movie_watchlist_app/data/models/cast_list_model.dart';
import 'package:movie_watchlist_app/data/models/corousellistmodel/movie_model.dart';
import 'package:movie_watchlist_app/data/models/corousellistmodel/movies_result_model.dart';
import 'package:movie_watchlist_app/data/repo/base_repo.dart';
import 'package:movie_watchlist_app/utilities/constants.dart';


class CarouselListRepository extends BaseRepo{

  Future<List<MovieModel>> fetchTrendingMovies() async{
    final response = await getItems(ApiConstants.trendingUrl);
    final movies = MovieResultModel.fromJson(response).results;
    return movies;
  }

  Future<List<MovieModel>> fetchTvCarousel() async{
    final response = await getItems(ApiConstants.tvCarouselUrl);
    final movies = MovieResultModel.fromJson(response).results;
    return movies;
  }
}

final CarouselListRepository carouselListRepository = CarouselListRepository();



