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

  dynamic getPaginatedItems(String url, int pageNo) async {
    final response = await http.get(Uri.parse('${ApiConstants.BASE_URL}$url${ApiConstants.API_KEY}&page=$pageNo'),
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