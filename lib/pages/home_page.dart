import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import '../provider/movie_provider.dart';
import '../widgets/movie_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<MovieProvider>(context, listen: false).fetchTopRatedMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MovieProvider>.value(
      value: Provider.of<MovieProvider>(context),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: LazyLoadScrollView(
                onEndOfPage: () {
                  final movieProvider = context.read<MovieProvider>();
                  if (!movieProvider.isLoading) {
                    movieProvider.fetchTopRatedMovies();
                  }
                },
                child: MovieList(movies: context.watch<MovieProvider>().movies),
              ),
            ),
          ],
        ),
      ),
    );
  }
}