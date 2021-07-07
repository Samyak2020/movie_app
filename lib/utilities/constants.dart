

class ScreenName {
  static const String SplashScreen = "SplashScreen";
  static const String LoginScreen = "LoginScreen";
  static const String SignUpScreen = "SignUpScreen";
  static const String HomeScreen = "HomeScreen";
  static const String DetailsScreen = "DetailsScreen";
  static const String WatchlistScreen = "WatchlistScreen";
  static const String SearchScreen = "SearchScreen";
}

class ApiConstants{
  ApiConstants._();

  static const String BASE_URL = "https://api.themoviedb.org/3/";
  static const String BASE_IMAGE_URL = "https://image.tmdb.org/t/p/w500";
  static const String API_KEY = "09ab17ecc38aa58012fb3e67057880f4";

  static const String trendingUrl = "trending/movie/day?api_key=";
  static const String tvCarouselUrl = "trending/tv/day?api_key=";
  static const String popularUrl = "movie/popular?api_key=";
  static const String topRatedUrl = "movie/top_rated?api_key=";
  static const String searchUrl = "search/movie?api_key=09ab17ecc38aa58012fb3e67057880f4&query=avenger";
}