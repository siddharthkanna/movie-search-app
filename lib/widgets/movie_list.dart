import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'movie_tile.dart';

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 0.7,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MovieTile(movie: movies[index]);
      },
    );
  }
}
