import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter3/providers/movie_provider.dart';
import 'package:flutter3/models/movie.dart';

class MovieDetailScreen extends StatelessWidget {
  final int movieId;

  MovieDetailScreen({required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Film'),
      ),
      body: FutureBuilder(
        future: Provider.of<MovieProvider>(context, listen: false).fetchMovieDetail(movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading movie details'));
          } else {
            final movie = Provider.of<MovieProvider>(context).selectedMovie!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network('https://image.tmdb.org/t/p/w500${movie.backdropPath}'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Release Date: ${movie.releaseDate}'),
                        SizedBox(height: 8),
                        Text('Rating: ${movie.voteAverage}'),
                        SizedBox(height: 8),
                        Text(movie.overview),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (Provider.of<MovieProvider>(context, listen: false).isFavorite(movie)) {
                              Provider.of<MovieProvider>(context, listen: false).removeFavorite(movie);
                            } else {
                              Provider.of<MovieProvider>(context, listen: false).addFavorite(movie);
                            }
                          },
                          child: Consumer<MovieProvider>(
                            builder: (context, movieProvider, child) {
                              return Text(
                                  movieProvider.isFavorite(movie) ? 'Remove from Favorites' : 'Add to Favorites');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}