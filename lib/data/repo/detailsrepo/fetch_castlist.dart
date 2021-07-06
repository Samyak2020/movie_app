import 'dart:convert';
import 'package:movie_watchlist_app/data/models/cast_list_model.dart';
import 'package:movie_watchlist_app/data/repo/base_repo.dart';
import 'package:http/http.dart' as http;
import 'package:movie_watchlist_app/utilities/constants.dart';


class CastListRepository extends BaseRepo{

  Future<List<Cast>> fetchCastsList(int movieId) async{
    final response = await getCasts(movieId);
    final cast = CastList.fromJson(response).cast;
    return cast;
  }
}


final CastListRepository castListRepository = CastListRepository();
