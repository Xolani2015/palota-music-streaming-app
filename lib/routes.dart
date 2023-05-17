import 'package:flutter/material.dart';
import 'package:flutter_spotify_africa_assessment/features/about/presentation/pages/about.dart';
import 'package:flutter_spotify_africa_assessment/features/landing/presentation/pages/landing.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/presentation/pages/spotify_category.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/presentation/pages/spotify_playlist.dart';
import 'package:flutter_spotify_africa_assessment/models/category_model.dart';
import 'package:flutter_spotify_africa_assessment/models/context_playlist_model.dart';
import 'package:flutter_spotify_africa_assessment/models/playlists_model.dart';

class AppRoutes {
  /// App start up (loading) page
  static const String startUp = '/';

  /// App start up (loading) page
  static const String about = '/about';

  /// Spotify Category Page
  static const String spotifyCategory = '/spotify/category';

  /// Spotify Category Page
  static const String stotifyPlaylist = '/spotify/playlist';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case startUp:
        return MaterialPageRoute(
          builder: (BuildContext context) => const LandingPage(),
          settings: settings,
        );
      case about:
        return MaterialPageRoute(
          builder: (BuildContext context) => const AboutPage(),
          settings: settings,
        );
      case stotifyPlaylist:
        final Set passedArguments = settings.arguments as Set;
        var passedArgumentsList = passedArguments.toList();
        String playlistId = passedArgumentsList[0];
        ContextPlaylistModel contextPlaylist = passedArgumentsList[1];

        return MaterialPageRoute(
          builder: (BuildContext context) => SpotifyPlaylistPage(
            playlist: playlistId,
            contextPlaylist: contextPlaylist,
          ),
        );
      case spotifyCategory:
        final Set passedArguments = settings.arguments as Set;
        var passedArgumentsList = passedArguments.toList();
        CategoryModel category = passedArgumentsList[0];
        PlaylistsModel playlists = passedArgumentsList[1];

        print('transion to page');

        return MaterialPageRoute(
          builder: (BuildContext context) => SpotifyCategoryConnector(
            categoryId: '',
            category: category,
            playlists: playlists,
          ),
          settings: settings,
        );
      /* TODO: handle other routes
      you can extract parameters from settings.arguments if necessary 
      https://flutter.dev/docs/cookbook/navigation/navigate-with-arguments#alternatively-extract-the-arguments-using-ongenerateroute*/
      default:
        throw UnimplementedError();
    }
  }
}
