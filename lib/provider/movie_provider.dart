// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import '../models/movie.dart';

enum MovieSorting {
  year,
  popularity,
}

class MovieProvider with ChangeNotifier {
  List<Movie> movies = [];
  List<Movie> likedMovies = [];
  bool isLoading = false;
  int page = 1;
  MovieSorting _currentSorting = MovieSorting.popularity;

  MovieSorting get currentSorting => _currentSorting;

  Future<void> fetchTopRatedMovies() async {
    try {
      isLoading = true;
      notifyListeners();

      const apiKey = movieApi;
      const baseUrl = 'https://api.themoviedb.org/3';
      final response = await http.get(
        Uri.parse('$baseUrl/movie/top_rated?api_key=$apiKey&page=$page'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> movieList = jsonResponse['results'];

        final List<Movie> newMovies = movieList.take(5).map((movieJson) {
          return Movie(
            name: movieJson['title'],
            year: movieJson['release_date'],
            rating: (movieJson['vote_average'] as num).toDouble(),
            posterUrl: 'https://image.tmdb.org/t/p/w500${movieJson['poster_path']}',
          );
        }).toList();

        _sortMovies(newMovies); 
        movies.addAll(newMovies);
        page++;
      } else {
        print('Failed to load top-rated movies');
      }
    } catch (error) {
      print('Error fetching top-rated movies: $error');
    } finally {
      isLoading = false;
      Future.delayed(Duration.zero, () {
        notifyListeners();
      });
    }
  }

  void toggleLike(Movie movie) {
    movie.isLiked = !movie.isLiked;
    if (movie.isLiked) {
      likedMovies.add(movie);
    } else {
      likedMovies.remove(movie);
    }
    notifyListeners();
  }

  void changeSorting(MovieSorting newSorting) {
    if (_currentSorting != newSorting) {
      _currentSorting = newSorting;
      _sortMovies(movies);
      notifyListeners();
    }
  }

  void _sortMovies(List<Movie> movieList) {
    switch (_currentSorting) {
      case MovieSorting.year:
        movieList.sort((a, b) => a.year.compareTo(b.year));
        break;
      case MovieSorting.popularity:
        movieList.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
  }
}