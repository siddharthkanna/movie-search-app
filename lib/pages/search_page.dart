import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/movie_tile.dart';
import '../api/movie_api.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchResults = [];
  bool _isSearching = false;
  bool _showNoMoviesFound = false;

  Future<void> searchMovie() async {
    setState(() {
      _isSearching = true;
      _showNoMoviesFound = false;
      _searchResults.clear();
    });

    try {
      final List<Movie> searchResults =
          await MovieApi.searchMovie(_searchController.text);
      setState(() {
        _searchResults.addAll(searchResults);
        _isSearching = false;
        _showNoMoviesFound = _searchResults.isEmpty;
      });
    } catch (error) {
      setState(() {
        _isSearching = false;
        _showNoMoviesFound = true;
      });
      print('Error searching for movies: $error');
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
