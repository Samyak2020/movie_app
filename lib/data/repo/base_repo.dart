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
}