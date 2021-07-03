import 'package:movie_watchlist_app/bloc/base_bloc.dart';
import 'package:movie_watchlist_app/data/data_sources/repo/fetch_movies.dart';
import 'package:movie_watchlist_app/data/models/movie_model.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreenBloc extends BaseBloc {
  final trendingMoviesController = BehaviorSubject<List<MovieModel>>();
  final popularMoviesController = BehaviorSubject<List<MovieModel>>();
  final upcomingMoviesController = BehaviorSubject<List<MovieModel>>();
  final showSelectedCategoryController = BehaviorSubject<String>();

  Stream<List<MovieModel>> get trendingMoviesResponseStream => trendingMoviesController.stream;
  Stream<List<MovieModel>> get popularMoviesResponseStream => popularMoviesController.stream;
  Stream<List<MovieModel>> get upcomingMoviesResponseStream => upcomingMoviesController.stream;
  Stream<String> get showSelectedCategoryControllerStream => showSelectedCategoryController.stream;

  Function(List<MovieModel>) get addTrendingMoviesResponseToStream => trendingMoviesController.sink.add;
  Function(List<MovieModel>) get addPopularMoviesResponseToStream => popularMoviesController.sink.add;
  Function(List<MovieModel>) get addUpcomingMoviesResponseToStream => upcomingMoviesController.sink.add;
  Function(String) get addShowSelectedCategoryToStream => showSelectedCategoryController.sink.add;



  fetchMoviesStream()async{

    List trendingImages = [];
    List<MovieModel> trendingMovies = await moviesRepository.fetchTrendingMovies();
    print("TRENDING MOVIES $trendingMovies");
    addTrendingMoviesResponseToStream(trendingMovies);

    List<MovieModel> popularMovies = await moviesRepository.fetchPopularMovies();
    addPopularMoviesResponseToStream(popularMovies);

    List<MovieModel> upcomingMovies = await moviesRepository.fetchPopularMovies();
    addUpcomingMoviesResponseToStream(upcomingMovies);
  }

  showSelectedCategory({String category}){
    if(category == "trending"){

    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    trendingMoviesController.close();
    popularMoviesController.close();
    upcomingMoviesController.close();
  }
}
final HomeScreenBloc homeScreenBloc = HomeScreenBloc();
