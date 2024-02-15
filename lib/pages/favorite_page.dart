import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/movie_provider.dart';
import '../widgets/movie_list.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = Provider.of<MovieProvider>(context).likedMovies;

    return Scaffold(
      body: MovieList(movies: favoriteMovies),
    );
  }
}
