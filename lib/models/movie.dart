class Movie {
  final String id;
  final String imageUrl;
  final String title;
  final String rating;
  final String releaseDate;
  final String voteCount;
  final String overview;

  Movie({
    required this.id,
    required this.imageUrl,
    required this.rating,
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.voteCount,
  });
}
