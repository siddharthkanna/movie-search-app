class Movie {
  final String name;
  final String year;
  final double rating;
  final String posterUrl;
  bool isLiked = false;

  Movie({
    required this.name,
    required this.year,
    required this.rating,
    required this.posterUrl,
    this.isLiked = false,
  });
}
