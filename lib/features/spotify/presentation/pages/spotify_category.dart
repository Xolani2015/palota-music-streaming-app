import 'dart:convert';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spotify_africa_assessment/colors.dart';
import 'package:flutter_spotify_africa_assessment/main.dart';
import 'package:flutter_spotify_africa_assessment/models/context_playlist_model.dart';
import 'package:flutter_spotify_africa_assessment/models/playlists_model.dart';
import 'package:flutter_spotify_africa_assessment/routes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spotify_africa_assessment/models/category_model.dart';

// TODO: fetch and populate playlist info and allow for click-through to detail
// Feel free to change this to a stateful widget if necessary

class SpotifyCategoryConnector extends StatefulWidget {
  final String categoryId;
  final CategoryModel category;
  final PlaylistsModel playlists;

  const SpotifyCategoryConnector(
      {Key? key,
      required this.categoryId,
      required this.category,
      required this.playlists})
      : super(key: key);

  @override
  State<SpotifyCategoryConnector> createState() => _SpotifyCategoryState();
}

class ColorScheme {
  var secondaryColor = const Color.fromARGB(255, 62, 62, 62);
  ColorScheme();
}

class _SpotifyCategoryState extends State<SpotifyCategoryConnector> {
  ColorScheme colors = ColorScheme();

  Future<void> fetchContextPlaylist(String playlistId, String playlistName,
      String playlistDescription) async {
    Map<String, String> requestHeader = {
      'x-functions-key':
          '_q6Qaip9V-PShHzF8q9l5yexp-z9IqwZB_o_6x882ts3AzFuo0DxuQ==',
    };
    final url =
        'https://palota-jobs-africa-spotify-fa.azurewebsites.net/api/playlists/$playlistId';
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: requestHeader);
    final body = response.body;
    final json = jsonDecode(body);
    var contextPlaylist = ContextPlaylistModel.fromJson(json);
    _navigateToSpotifyContextPLaylistPage(
      context,
      playlistId,
      playlistName,
      playlistDescription,
      contextPlaylist,
    );
  }

  Widget returnPlaylists() {
    List<Widget> items = [Container()];
    for (var i = 0; i < widget.playlists.playlists!.items!.length; i++) {
      items.add(Container(
          height: 50,
          width: 50,
          child: widget.playlists.playlists!.items![i].images![0].image));
    }
    return Column(children: items);
  }

  @override
  Widget build(BuildContext context) => StoreProvider<int>(
      store: store,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.category.name.toString()),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.about),
            ),
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  AppColors.blue,
                  AppColors.cyan,
                  AppColors.green,
                ],
              ),
            ),
          ),
        ),
        body: ListView(
          children: [
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            color: colors.secondaryColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(7),
                                bottomLeft: Radius.circular(7)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  color: Colors.transparent,
                                  child: widget.category.image,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.category.name.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'Playlists',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 30),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 480,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),

                          child: GridView.count(
                            // Create a grid with 2 columns. If you change the scrollDirection to
                            // horizontal, this produces 2 rows.
                            crossAxisCount: 2,
                            // Generate 100 widgets that display their index in the List.
                            children: List.generate(
                                widget.playlists.playlists!.items!.length,
                                (index) {
                              return Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      var playListDescription = widget.playlists
                                          .playlists!.items![index].description
                                          .toString();

                                      var playListId = widget
                                          .playlists.playlists!.items![index].id
                                          .toString();

                                      var playListName = widget.playlists
                                          .playlists!.items![index].name
                                          .toString();

                                      fetchContextPlaylist(playListId,
                                          playListName, playListDescription);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                          color: colors.secondaryColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(7))),
                                      height: 160,
                                      width: 150,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 130,
                                                width: 130,
                                                child: widget
                                                    .playlists
                                                    .playlists!
                                                    .items![index]
                                                    .images![0]
                                                    .image,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            widget.playlists.playlists!
                                                .items![index].name
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                          //child: returnPlaylists(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ));

  void _navigateToSpotifyContextPLaylistPage(
      BuildContext context,
      String playlistid,
      String playlistName,
      String playlistDescription,
      ContextPlaylistModel contextPlaylist) {
    Set contextPlaylistSet = {
      playlistid,
      playlistName,
      playlistDescription,
      contextPlaylist
    };

    // replace because we don't want to navigate back to the landing screen
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.stotifyPlaylist,
      arguments: contextPlaylistSet,
    );
  }
}

class IncrementAction extends ReduxAction<int> {
  final int amount;

  IncrementAction({required this.amount});

  @override
  int reduce() => state + amount;
}
