import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/providers/auth.dart';
import 'package:movies/providers/movies.dart';
import 'package:movies/widgets/movie_item.dart';
import 'package:provider/provider.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    _isLoading = true;
    Provider.of<Movies>(context, listen: false).fetchMovies().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final moviesProv = Provider.of<Movies>(context);
    List<Movie> movies = moviesProv.movies;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () =>
                  Provider.of<Auth>(context, listen: false).logOut(),
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColorLight,
              ),
            )
          : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (ctx, i) => MovieItem(movies[i])),
    );
  }
}
