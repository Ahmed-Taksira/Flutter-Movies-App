import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/screens/movie_detail_screen.dart';

class MovieItem extends StatelessWidget {
  final Movie movie;

  MovieItem(this.movie);

  void selectMovie(context) {
    Navigator.of(context)
        .pushNamed(MovieDetailScreen.routeName, arguments: movie.id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => selectMovie(context),
      child: Container(
        height: 270,
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
            footer: GridTileBar(
              title: Text(
                movie.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                movie.releaseDate,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              backgroundColor: Colors.black87,
              trailing: Row(
                children: [
                  const Icon(Icons.star),
                  const SizedBox(width: 5),
                  Text(
                    'Rating: ${movie.rating}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            child: Image.network(
              movie.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
