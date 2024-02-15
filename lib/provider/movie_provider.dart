// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:moviesearch/api/movie_api.dart';
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

      final List<Movie> newMovies = await MovieApi.fetchTopRatedMovies(page);
      _sortMovies(newMovies);
      movies.addAll(newMovies);
      page++;
    } catch (error) {
      print('Error fetching top-rated movies: $error');
    } finally {
      isLoading = false;
      notifyListeners();
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
