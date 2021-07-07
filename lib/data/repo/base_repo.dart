import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_watchlist_app/utilities/constants.dart';

class BaseRepo{

  dynamic getItems(String url) async {
    final response = await http.get(Uri.parse('${ApiConstants.BASE_URL}$url${ApiConstants.API_KEY}'),
      headers: {
        'Content-Type' : 'application/json'
      },
    );
    if(response.statusCode == 200){
      return json.decode(response.body);
  }else{
      throw Exception("ERROR REASON IS THIS ${response.reasonPhrase}");
    }
  }


  dynamic getCasts(int movieId) async {
    final response = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/$movieId/credits?api_key=${ApiConstants.API_KEY}'),
      headers: {
        'Content-Type' : 'application/json'
      },
    );
    if(response.statusCode == 200){
      return json.decode(response.body);
    }else{
      throw Exception("ERROR REASON IS THIS ${response.reasonPhrase}");
    }
  }

  dynamic getTrailers(int movieId) async {
    final response = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/$movieId/videos?api_key=${ApiConstants.API_KEY}'),
      headers: {
        'Content-Type' : 'application/json'
      },
    );
    if(response.statusCode == 200){
      return json.decode(response.body);
    }else{
      throw Exception("ERROR REASON IS THIS ${response.reasonPhrase}");
    }
  }

  dynamic getSearchResult({String searchQuery = ""}) async {
    final response = await http.get(Uri.parse('https://api.themoviedb.org/3/search/movie?api_key=${ApiConstants.API_KEY}&query=$searchQuery'),
      headers: {
        'Content-Type' : 'application/json'
      },
    );
    if(response.statusCode == 200){
      return json.decode(response.body);
    }else{
      throw Exception("ERROR REASON IS THIS ${response.reasonPhrase}");
    }
  }

  // dynamic get(String path, {Map<dynamic, dynamic> params}) async {
  //   final response = await http.get(
  //     //2
  //     getPath(path, params),
  //     //...
  //     //...
  //   );
  //
  //   //...
  //   //...
  // }
  //
  // String getPath(String path, Map<dynamic, dynamic> params) {
  //   //3
  //   var paramsString = '';
  //   //4
  //   if (params?.isNotEmpty ?? false) {
  //     //5
  //     params.forEach((key, value) {
  //       //6
  //       paramsString += '&$key=$value';
  //     });
  //   }
  //
  //   //7
  //   return '${ApiConstants.BASE_URL}$path?api_key=${ApiConstants.API_KEY}$paramsString';
  // }
}