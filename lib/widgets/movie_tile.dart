import 'package:flutter/material.dart';
import 'package:moviesearch/util/custom_snackbar.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../provider/movie_provider.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;

  const MovieTile({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              movie.posterUrl ?? '',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 500,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () {
                  // Handle card tap if needed
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end, // Align at bottom
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              movie.name ?? '',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              movie.isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: movie.isLiked ? Colors.red : Colors.white,
                            ),
                            onPressed: () {
                              final movieProvider = Provider.of<MovieProvider>(
                                  context,
                                  listen: false);
                              movieProvider.toggleLike(movie);
                              final snackBarMessage = movie.isLiked
                                  ? 'Added to favorites'
                                  : 'Removed from favorites';
                              final snackBarColor =
                                  movie.isLiked ? Colors.green : Colors.red;
                              showCustomSnackBar(
                                  context, snackBarMessage, snackBarColor);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Year: ${movie.year ?? ''}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'IMDb Rating: ${movie.rating ?? ''}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
