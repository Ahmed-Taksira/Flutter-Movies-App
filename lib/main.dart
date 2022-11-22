import 'package:flutter/material.dart';
import 'package:movies/providers/auth.dart';
import 'package:movies/providers/movies.dart';
import 'package:movies/screens/auth_screen.dart';
import 'package:movies/screens/movies_screen.dart';
import 'package:movies/screens/movie_detail_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProvider.value(value: Movies()),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Movies',
            theme: ThemeData(
                primarySwatch: Colors.red,
                fontFamily: 'Quicksand',
                textTheme: ThemeData.light().textTheme.copyWith(
                      bodyMedium: const TextStyle(color: Colors.white60),
                      titleMedium: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
            home: !auth.isAuth ? AuthScreen() : MoviesScreen(),
            routes: {
              MovieDetailScreen.routeName: (ctx) => MovieDetailScreen(),
            },
          ),
        ));
  }
}
