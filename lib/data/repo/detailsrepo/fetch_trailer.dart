import 'package:movie_watchlist_app/data/models/trailer_model.dart';
import 'package:movie_watchlist_app/data/repo/base_repo.dart';


class TrailerListRepository extends BaseRepo{

  Future<List<Trailer>> fetchTrailers(int movieId) async{
    final response = await getTrailers(movieId);
    final trailer = TrailerList.fromJson(response).results;
    print("trailers at repo >> $trailer");
    return trailer;
  }
}


final TrailerListRepository trailerListRepository = TrailerListRepository();
