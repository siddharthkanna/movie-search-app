import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moviesearch/models/movie.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../widgets/movie_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Movie> _searchResults = [];
  bool _isSearching = false;
  bool _showNoMoviesFound = false;

  void searchMovie() async {
    setState(() {
      _isSearching = true;
      _showNoMoviesFound = false;
      _searchResults.clear();
    });

    const apiKey = movieApi;
    const baseUrl = 'https://api.themoviedb.org/3';
    final query = _searchController.text;

    if (query.isNotEmpty) {
      final response = await http.get(Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query'));

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
            posterUrl: 'https://image.tmdb.org/t/p/w500${movieJson['poster_path']}',
          );
        }).toList();

        setState(() {
          _searchResults.addAll(searchResults);
          _isSearching = false;
          if (_searchResults.isEmpty) {
            _showNoMoviesFound = true;
          }
        });
      } else {
        setState(() {
          _isSearching = false;
        });
        // Handle error
        // ignore: avoid_print
        print('Failed to load search results');
      }
    } else {
      setState(() {
        _isSearching = false;
        _showNoMoviesFound = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          TextField(
            controller: _searchController,
            onSubmitted: (_) => searchMovie(),
            decoration: InputDecoration(
              hintText: 'Search for a movie',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              filled: true,
              fillColor: Colors.grey[200],
              hintStyle: const TextStyle(color: Colors.black54),
              prefixIcon: const Icon(Icons.search, color: Colors.black54),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _searchController.clear(),
              ),
            ),
            style: const TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 20),
          _isSearching
              ? const CircularProgressIndicator()
              : _searchResults.isEmpty && _showNoMoviesFound
                  ? const Text('No movies found for the given title.')
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final movie = _searchResults[index];
                          return MovieTile(movie: movie);
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}
