import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/movie_provider.dart';

class SortDropdown extends StatelessWidget {
  const SortDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MovieSorting>(
      icon: const Icon(Icons.sort , color: Colors.white),
      onSelected: (newSorting) {
        Provider.of<MovieProvider>(context, listen: false).changeSorting(newSorting);
      },
      itemBuilder: (BuildContext context) {
        return MovieSorting.values.map((sorting) {
          return PopupMenuItem<MovieSorting>(
            value: sorting,
            child: Text(
              _getSortingText(sorting),
              style: const TextStyle(fontSize: 16),
            ),
          );
        }).toList();
      },
    );
  }

  String _getSortingText(MovieSorting sorting) {
    switch (sorting) {
      case MovieSorting.popularity:
        return 'Popularity';
      case MovieSorting.year:
        return 'Year';
      
    }
  }
}
