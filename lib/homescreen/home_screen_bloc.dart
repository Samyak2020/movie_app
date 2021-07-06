import 'package:movie_watchlist_app/bloc/base_bloc.dart';
import 'package:movie_watchlist_app/data/models/cast_list_model.dart';
import 'package:movie_watchlist_app/data/models/corousellistmodel/movie_model.dart';
import 'package:movie_watchlist_app/data/models/moviespaginationmodel/movies_pagination.dart';
import 'package:movie_watchlist_app/data/models/trailer_model.dart';
import 'package:movie_watchlist_app/data/repo/detailsrepo/fetch_trailer.dart';
import 'package:movie_watchlist_app/data/repo/home_repos/fetch_carousel_movies.dart';
import 'package:movie_watchlist_app/data/repo/detailsrepo/fetch_castlist.dart';
import 'package:movie_watchlist_app/data/repo/home_repos/fetch_movieslist.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreenBloc extends BaseBloc {
  final trendingMoviesController = BehaviorSubject<List<MovieModel>>();
  final popularMoviesController = BehaviorSubject<List<MoviesPaginationList>>();
  final tvController = BehaviorSubject<List<MovieModel>>();
  final showSelectedCategoryController = BehaviorSubject<List<MovieModel>>();
  final castListController = BehaviorSubject<List<Cast>>();
  final trailerListController = BehaviorSubject<List<Trailer>>();

  Stream<List<MovieModel>> get trendingMoviesResponseStream => trendingMoviesController.stream;
  Stream<List<MoviesPaginationList>> get popularMoviesResponseStream => popularMoviesController.stream;
  Stream<List<MovieModel>> get tvResponseStream => tvController.stream;
  Stream<List<MovieModel>> get showSelectedCategoryControllerStream => showSelectedCategoryController.stream;
  Stream<List<Cast>> get castListResponseStream => castListController.stream;
  Stream<List<Trailer>> get trailerListResponseStream => trailerListController.stream;

  Function(List<MovieModel>) get addTrendingMoviesResponseToStream => trendingMoviesController.sink.add;
  Function(List<MoviesPaginationList>) get addPopularMoviesResponseToStream => popularMoviesController.sink.add;
  Function(List<MovieModel>) get addTvResponseToStream => tvController.sink.add;
  Function(List<MovieModel>) get addShowSelectedCategoryToStream => showSelectedCategoryController.sink.add;
  Function(List<Cast>) get addCastListToStream => castListController.sink.add;
  Function(List<Trailer>) get addTrailerListToStream => trailerListController.sink.add;



  fetchCarouselListStream()async{
    List<MovieModel> trendingMovies = await carouselListRepository.fetchTrendingMovies();
    print("TRENDING MOVIES $trendingMovies");
    addTrendingMoviesResponseToStream(trendingMovies);

    List<MovieModel> tvCarousel = await carouselListRepository.fetchTvCarousel();
    addTvResponseToStream(tvCarousel);
  }

  showSelectedCategory({String category}) async{
    if(category == "trending"){
      List<MovieModel> trendingMovies = await carouselListRepository.fetchTrendingMovies();
      addShowSelectedCategoryToStream(trendingMovies);
    }else{
      List<MovieModel> tvCarousel = await carouselListRepository.fetchTvCarousel();
      addShowSelectedCategoryToStream(tvCarousel);
    }
  }

  fetchMoviesListStream() async{
    List<MoviesPaginationList> popularMovies = await moviesListRepository.fetchPopularMovies();
    addPopularMoviesResponseToStream(popularMovies);
  }

  fetchCastList(int movieId) async{
    List<Cast> cast =  await castListRepository.fetchCastsList(movieId);
    addCastListToStream(cast);
  }

  fetchTrailerList(int movieId) async{
    List<Trailer> trailers =  await trailerListRepository.fetchTrailers(movieId);
    addTrailerListToStream(trailers);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    trendingMoviesController.close();
    popularMoviesController.close();
    tvController.close();
    showSelectedCategoryController.close();
    castListController.close();
    trailerListController.close();
  }
}
final HomeScreenBloc homeScreenBloc = HomeScreenBloc();
