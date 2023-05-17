// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spotify_africa_assessment/main.dart';
import 'package:flutter_spotify_africa_assessment/models/context_playlist_model.dart';
import 'package:flutter_spotify_africa_assessment/models/playlists_model.dart';
import 'package:flutter_spotify_africa_assessment/routes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spotify_africa_assessment/models/category_model.dart';

// TODO: fetch and populate playlist info and allow for click-through to detail
// Feel free to change this to a stateful widget if necessary

class SpotifyPlaylistPage extends StatefulWidget {
  String playlist;

  ContextPlaylistModel contextPlaylist;
  SpotifyPlaylistPage({
    Key? key,
    required this.playlist,
    required this.contextPlaylist,
  }) : super(key: key);

  @override
  State<SpotifyPlaylistPage> createState() => _SpotifyCategoryState();
}

class ColorScheme {
  var secondaryColor = const Color.fromARGB(255, 62, 62, 62);
  ColorScheme();
}

class _SpotifyCategoryState extends State<SpotifyPlaylistPage> {
  ColorScheme colors = ColorScheme();

  Future<void> fetchPlaylists(CategoryModel category) async {
    Map<String, String> requestHeader = {
      'x-functions-key':
          '_q6Qaip9V-PShHzF8q9l5yexp-z9IqwZB_o_6x882ts3AzFuo0DxuQ==',
    };
    final url =
        'https://palota-jobs-africa-spotify-fa.azurewebsites.net/api/playlists/37i9dQZF1DX6036iaZ2MYP';
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: requestHeader);
    final body = response.body;
    final json = jsonDecode(body);
    var playlist = PlaylistsModel.fromJson(json);
    _navigateToSpotifyContextPLaylistPage(context, category, playlist);
  }

  @override
  Widget build(BuildContext context) => StoreProvider<int>(
      store: store,
      child: Scaffold(
        appBar: AppBar(
          title: InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.startUp,
                  arguments: null,
                );
              },
              child: Icon(Icons.arrow_back_rounded)),
          backgroundColor: Color.fromARGB(42, 57, 57, 57),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.about),
            ),
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(),
          ),
        ),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              padding: const EdgeInsets.symmetric(
                vertical: 5,
              ),
              width: 50,
              decoration: BoxDecoration(
                  color: colors.secondaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(7))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 200,
                          width: 200,
                          child: widget.contextPlaylist.images![0].image ??
                              Container()),
                    ],
                  ),
                  const Text(
                    'Name of playlist',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  decoration: BoxDecoration(color: colors.secondaryColor),
                ))
              ],
            )
          ],
        ),
      ));

  void _navigateToSpotifyContextPLaylistPage(BuildContext context,
      CategoryModel category, PlaylistsModel playlistsModel) {
    Set categoryPlayLists = {category, playlistsModel};
    // replace because we don't want to navigate back to the landing screen
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.spotifyCategory,
      arguments: categoryPlayLists,
    );
  }
}

class IncrementAction extends ReduxAction<int> {
  final int amount;

  IncrementAction({required this.amount});

  @override
  int reduce() => state + amount;
}
