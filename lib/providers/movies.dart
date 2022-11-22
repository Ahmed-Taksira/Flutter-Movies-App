import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:http/http.dart' as http;

class Movies with ChangeNotifier {
  List<Movie> _movies = [
    // Movie(
    //     id: '1',
    //     imageUrl:
    //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //     rating: '3.5',
    //     title: 'My Movuie',
    //     overview:
    //         'Awesme Plotdszjkhfgeaihaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadsailuhduioehfadfaedsadwefsdfefwfdsfefsdfhgsfgtagdfafg',
    //     releaseDate: '2022-10-22',
    //     voteCount: '6969'),
    // Movie(
    //     id: '2',
    //     imageUrl:
    //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //     rating: '3.5',
    //     title: 'My Movuie',
    //     overview:
    //         'Awesme Plotdszjkhfgeaihdsailuhduioehfadfaedsadwefsdfefwfdsfefsdfhgsfgtagdfafg',
    //     releaseDate: '2022-10-22',
    //     voteCount: '6969'),
    // Movie(
    //     id: '3',
    //     imageUrl:
    //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //     rating: '3.5',
    //     title: 'My Movuie',
    //     overview:
    //         'Awesme Plotdszjkhfgeaihdsailuhduioehfadfaedsadwefsdfefwfdsfefsdfhgsfgtagdfafg',
    //     releaseDate: '2022-10-22',
    //     voteCount: '6969'),
  ];

  List<Movie> get movies {
    return [..._movies];
  }

  Movie getById(String id) {
    final result = _movies.firstWhere((movie) => movie.id == id);

    return result;
  }

  Future<void> fetchMovies() {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=521ba0e90a4812223258ac9c62c75f94');
    return http.get(url).then((res) {
      final returnedMovies = json.decode(res.body)['results'] as List<dynamic>;
      if (returnedMovies == null) return;
      final List<Movie> loadedMovies = [];
      returnedMovies.forEach((data) {
        loadedMovies.add(Movie(
          id: data['id'].toString(),
          imageUrl:
              'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
          rating: data['vote_average'].toString(),
          title: data['title'],
          overview: data['overview'],
          releaseDate: data['release_date'] as String,
          voteCount: data['vote_count'].toString(),
        ));
      });
      _movies = loadedMovies;
      notifyListeners();
    }).catchError((e) => print(e));
  }
}
