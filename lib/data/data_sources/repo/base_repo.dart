import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_watchlist_app/utilities/constants.dart';

class BaseRepo{

  dynamic getItems(String url) async {
    final response = await http.get(Uri.parse('${ApiConstants.BASE_URL}${ApiConstants.trendingUrl}${ApiConstants.API_KEY}'),
      headers: {
        'Content-Type' : 'application/json'
      },
    );
    if(response.statusCode == 200){
      return json.decode(response.body);
  }else{
      throw Exception("${response.reasonPhrase}");
    }
  }
}