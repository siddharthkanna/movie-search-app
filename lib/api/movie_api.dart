import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/movie.dart';

class MovieApi {
  static Future<List<Movie>> fetchTopRatedMovies(int page) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$movieBaseUrl/movie/top_rated?api_key=$movieApiKey&page=$page'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> movieList = jsonResponse['results'];

        final List<Movie> movies = movieList.take(5).map((movieJson) {
          return Movie(
            name: movieJson['title'],
            year: movieJson['release_date'],
            rating: (movieJson['vote_average'] as num).toDouble(),
            posterUrl:
                'https://image.tmdb.org/t/p/w500${movieJson['poster_path']}',
          );
        }).toList();

        return movies;
      } else {
        throw Exception('Failed to load top-rated movies');
      }
    } catch (error) {
      throw Exception('Error fetching top-rated movies: $error');
    }
  }

  static Future<List<Movie>> searchMovie(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$movieBaseUrl/search/movie?api_key=$movieApiKey&query=$query'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> movieList = jsonResponse['results'];

        final List<Movie> searchResults = movieList
            .where((movieJson) => movieJson['poster_path'] != null)
            .map((movieJson) {
          return Movie(
            name: movieJson['title'],
            year: movieJson['release_date'],
            rating: (movieJson['vote_average'] as num).toDouble(),
            posterUrl:
                'https://image.tmdb.org/t/p/w500${movieJson['poster_path']}',
          );
        }).toList();

        return searchResults;
      } else {
        throw Exception('Failed to search movies');
      }
    } catch (error) {
      throw Exception('Error searching movies: $error');
    }
  }
}
