import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:movie_watchlist_app/bloc/base_bloc.dart';
import 'package:movie_watchlist_app/data/models/cast_list_model.dart';
import 'package:movie_watchlist_app/data/models/corousellistmodel/movie_model.dart';
import 'package:movie_watchlist_app/data/models/movieslistmodels/popular_movies_model.dart';
import 'package:movie_watchlist_app/data/repo/home_repos/fetch_carousel_movies.dart';
import 'package:movie_watchlist_app/data/repo/detailsrepo/fetch_castlist.dart';
import 'package:movie_watchlist_app/data/repo/home_repos/fetch_movieslist.dart';
import 'package:movie_watchlist_app/data/repo/search_repo.dart';
import 'package:movie_watchlist_app/db/movie_modelDB.dart';
import 'package:movie_watchlist_app/db/movies_db.dart';
import 'package:rxdart/rxdart.dart';

class BlocCollection extends BaseBloc {
  final popularMoviesController = BehaviorSubject<List<MoviesPaginationList>>();
  final topRatedMoviesController = BehaviorSubject<List<MoviesPaginationList>>();
  final searchMoviesController = BehaviorSubject<List<MoviesPaginationList>>();
  final tvController = BehaviorSubject<List<MovieModel>>();
  final showSelectedCategoryController = BehaviorSubject<List<MovieModel>>();
  final castListController = BehaviorSubject<List<Cast>>();
  final offlineWatchListController = BehaviorSubject<List<MovieDBModel>>();
  final movieIsInDbController = BehaviorSubject<MovieDBModel>();
  final checkInternetConnectivityController = BehaviorSubject<bool>();

  Stream<List<MoviesPaginationList>> get popularMoviesResponseStream => popularMoviesController.stream;
  Stream<List<MoviesPaginationList>> get topRatedMoviesResponseStream => topRatedMoviesController.stream;
  Stream<List<MoviesPaginationList>> get searchMoviesResponseStream => searchMoviesController.stream;
  Stream<List<MovieModel>> get showSelectedCategoryControllerStream => showSelectedCategoryController.stream;
  Stream<List<Cast>> get castListResponseStream => castListController.stream;
  Stream<List<MovieDBModel>> get offlineWatchListStream => offlineWatchListController.stream;
  Stream<bool> get checkInternetConnectivityStream => checkInternetConnectivityController.stream;
  Stream<MovieDBModel> get movieIsInDb => movieIsInDbController.stream;

  Function(List<MoviesPaginationList>) get addPopularMoviesResponseToStream => popularMoviesController.sink.add;
  Function(List<MoviesPaginationList>) get addTopRatedMoviesResponseToStream => topRatedMoviesController.sink.add;
  Function(List<MoviesPaginationList>) get addsearchMoviesResponseToStream => searchMoviesController.sink.add;
  Function(List<MovieModel>) get addTvResponseToStream => tvController.sink.add;
  Function(List<MovieModel>) get addShowSelectedCategoryToStream => showSelectedCategoryController.sink.add;
  Function(List<Cast>) get addCastListToStream => castListController.sink.add;
  Function(List<MovieDBModel>) get addOfflineWatchListToStream => offlineWatchListController.sink.add;
  Function(bool) get addCheckInternetConnectivityToStream => checkInternetConnectivityController.sink.add;
  Function(MovieDBModel) get addMovieIsInDb => movieIsInDbController.sink.add;


  showSelectedCategory({String category}) async{
    if(category == "trending"){
      List<MovieModel> trendingMovies = await carouselListRepository.fetchTrendingMovies();
      addShowSelectedCategoryToStream(trendingMovies);
    }else{
      List<MovieModel> tvCarousel = await carouselListRepository.fetchTvCarousel();
      addShowSelectedCategoryToStream(tvCarousel);
    }
  }

  fetchMoviesListStream({bool isWishlistedFlag = false, int movieId, MoviesPaginationList moviesPaginationList}) async{
    List<MoviesPaginationList> popularMovies = await moviesListRepository.fetchPopularMovies();
    List<MovieDBModel> movies =  await MovieDB.db.getData();
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



  fetchSearchMovies({String searchQuery = ""}) async{
    List<MoviesPaginationList> movies =  await searchMoviesRepository.fetchSearchQuery(searchQuery);
    addsearchMoviesResponseToStream(movies);
  }


  fetchOfflineWatchListMovies({String uid}) async{
    List<MovieDBModel> movies =  await MovieDB.db.getData();
    addOfflineWatchListToStream(movies);
  }


  checkInternetConnection({bool result = true}) async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    try {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a network.
        result = true;
        addCheckInternetConnectivityToStream(result);
        return result;
      } else {
        result = false;
        addCheckInternetConnectivityToStream(result);
        return result;
      }
    } on SocketException catch (_) {result = true;
    result = false;
    addCheckInternetConnectivityToStream(result);
    return result;
    }
  }


  movieIsInTheDb({int movieId, bool movieIsInDB = false}) async{
    MovieDBModel movie =  await MovieDB.db.isWishListed(movieId: movieId);
    if(movie != null && movie.movieId == movieId){
      movieIsInDB = true;
      addMovieIsInDb(movie);
    }else{
      addMovieIsInDb(null);
    }
  }



  @override
  void dispose() {
    // TODO: implement dispose
    popularMoviesController.close();
    topRatedMoviesController.close();
    tvController.close();
    showSelectedCategoryController.close();
    castListController.close();
    searchMoviesController.close();
    offlineWatchListController.close();
    movieIsInDbController.close();
    checkInternetConnectivityController.close();
  }
}
final BlocCollection homeScreenBloc = BlocCollection();
