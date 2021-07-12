import 'package:movie_watchlist_app/bloc/base_bloc.dart';
import 'package:movie_watchlist_app/data/models/cast_list_model.dart';
import 'package:movie_watchlist_app/data/models/corousellistmodel/movie_model.dart';
import 'package:movie_watchlist_app/data/models/movieslistmodels/popular_movies_model.dart';
import 'package:movie_watchlist_app/data/models/trailer_model.dart';
import 'package:movie_watchlist_app/data/repo/detailsrepo/fetch_trailer.dart';
import 'package:movie_watchlist_app/data/repo/home_repos/fetch_carousel_movies.dart';
import 'package:movie_watchlist_app/data/repo/detailsrepo/fetch_castlist.dart';
import 'package:movie_watchlist_app/data/repo/home_repos/fetch_movieslist.dart';
import 'package:movie_watchlist_app/data/repo/search_repo.dart';
import 'package:movie_watchlist_app/db/movie_modelDB.dart';
import 'package:movie_watchlist_app/db/movies_db.dart';
import 'package:rxdart/rxdart.dart';

class BlocCollection extends BaseBloc {
  final trendingMoviesController = BehaviorSubject<List<MovieModel>>();
  final popularMoviesController = BehaviorSubject<List<MoviesPaginationList>>();
  final topRatedMoviesController = BehaviorSubject<List<MoviesPaginationList>>();
  final searchMoviesController = BehaviorSubject<List<MoviesPaginationList>>();
  final tvController = BehaviorSubject<List<MovieModel>>();
  final showSelectedCategoryController = BehaviorSubject<List<MovieModel>>();
  final castListController = BehaviorSubject<List<Cast>>();
  final trailerListController = BehaviorSubject<List<Trailer>>();
  final offlineWatchListController = BehaviorSubject<List<MovieDBModel>>();

  Stream<List<MovieModel>> get trendingMoviesResponseStream => trendingMoviesController.stream;
  Stream<List<MoviesPaginationList>> get popularMoviesResponseStream => popularMoviesController.stream;
  Stream<List<MoviesPaginationList>> get topRatedMoviesResponseStream => topRatedMoviesController.stream;
  Stream<List<MoviesPaginationList>> get searchMoviesResponseStream => searchMoviesController.stream;
  Stream<List<MovieModel>> get tvResponseStream => tvController.stream;
  Stream<List<MovieModel>> get showSelectedCategoryControllerStream => showSelectedCategoryController.stream;
  Stream<List<Cast>> get castListResponseStream => castListController.stream;
  Stream<List<Trailer>> get trailerListResponseStream => trailerListController.stream;
  Stream<List<MovieDBModel>> get offlineWatchListStream => offlineWatchListController.stream;

  Function(List<MovieModel>) get addTrendingMoviesResponseToStream => trendingMoviesController.sink.add;
  Function(List<MoviesPaginationList>) get addPopularMoviesResponseToStream => popularMoviesController.sink.add;
  Function(List<MoviesPaginationList>) get addTopRatedMoviesResponseToStream => topRatedMoviesController.sink.add;
  Function(List<MoviesPaginationList>) get addsearchMoviesResponseToStream => searchMoviesController.sink.add;
  Function(List<MovieModel>) get addTvResponseToStream => tvController.sink.add;
  Function(List<MovieModel>) get addShowSelectedCategoryToStream => showSelectedCategoryController.sink.add;
  Function(List<Cast>) get addCastListToStream => castListController.sink.add;
  Function(List<Trailer>) get addTrailerListToStream => trailerListController.sink.add;
  Function(List<MovieDBModel>) get addOfflineWatchListToStream => offlineWatchListController.sink.add;


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

  fetchTopRatedMoviesListStream() async{
    List<MoviesPaginationList> topRatedMovies = await moviesListRepository.fetchTopRatedMovies();
    addTopRatedMoviesResponseToStream(topRatedMovies);
  }

  fetchCastList(int movieId) async{
    List<Cast> cast =  await castListRepository.fetchCastsList(movieId);
    addCastListToStream(cast);
  }

  fetchTrailerList(int movieId) async{
    List<Trailer> trailers =  await trailerListRepository.fetchTrailers(movieId);
    addTrailerListToStream(trailers);
  }

  fetchSearchMovies({String searchQuery = ""}) async{
    List<MoviesPaginationList> movies =  await searchMoviesRepository.fetchSearchQuery(searchQuery);
    print("Search query at Bloc $movies");
    addsearchMoviesResponseToStream(movies);
  }

  fetchOfflineWatchListMovies({String uid}) async{
    List<MovieDBModel> movies =  await MovieDB.db.getData();
    print("offline movies at Bloc $movies");
    addOfflineWatchListToStream(movies);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    trendingMoviesController.close();
    popularMoviesController.close();
    topRatedMoviesController.close();
    tvController.close();
    showSelectedCategoryController.close();
    castListController.close();
    trailerListController.close();
    searchMoviesController.close();
    offlineWatchListController.close();
  }
}
final BlocCollection homeScreenBloc = BlocCollection();
