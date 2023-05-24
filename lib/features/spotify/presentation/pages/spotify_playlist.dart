// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'dart:convert';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spotify_africa_assessment/colors.dart';
import 'package:flutter_spotify_africa_assessment/configurations/api.dart';
import 'package:flutter_spotify_africa_assessment/main.dart';
import 'package:flutter_spotify_africa_assessment/models/context_playlist_model.dart';
import 'package:flutter_spotify_africa_assessment/models/playlists_model.dart';
import 'package:flutter_spotify_africa_assessment/routes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spotify_africa_assessment/models/category_model.dart';

// TODO: fetch and populate playlist info and allow for click-through to detail
// Feel free to change this to a stateful widget if necessary

class SpotifyPlaylistPage extends StatefulWidget {
  String playlistid;
  String playlistname;
  String playlistDescription;

  ContextPlaylistModel contextPlaylist;
  SpotifyPlaylistPage({
    Key? key,
    required this.playlistid,
    required this.contextPlaylist,
    required this.playlistname,
    required this.playlistDescription,
  }) : super(key: key);

  @override
  State<SpotifyPlaylistPage> createState() => _SpotifyCategoryState();
}

class ColorScheme {
  var secondaryColor = Color.fromARGB(255, 42, 42, 42);
  ColorScheme();
}

class _SpotifyCategoryState extends State<SpotifyPlaylistPage> {
  ColorScheme colors = ColorScheme();

  bool _isExtendedList = false;
  List<Items> trackList = [];

  Future<void> fetchPlaylists(CategoryModel category) async {
    Map<String, String> requestHeader = {
      'x-functions-key': headerkey,
    };
    final url = '$baseURL/playlists/${widget.playlistid}';
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: requestHeader);
    final body = response.body;
    final json = jsonDecode(body);
    var playlist = PlaylistsModel.fromJson(json);
    _navigateToSpotifyContextPLaylistPage(context, category, playlist);
  }

  Widget returnFeaturedArtists() {
    List<Widget> items = [Container()];
    for (int i = 0; i > widget.contextPlaylist.tracks!.items!.length; i++) {
      items.add(Container(
        height: 40,
        child: Text(widget.contextPlaylist.tracks!.items![i]!.track!.artists
            .toString()),
      ));
    }
    return Container();
  }

  Widget returnTracks(bool isExtendList) {
    trackList = [];
    trackList = widget.contextPlaylist.tracks!.items ?? [];

    int loopLength = widget.contextPlaylist.tracks!.items!.length;

    if (!isExtendList) {
      if (trackList.length > 5) {
        loopLength = 5;
      }
    }

    if (trackList.isNotEmpty) {
      List<Widget> items = [Container()];

      // for (var i = 0; i < widget.contextPlaylist.tracks!.items!.length; i++) {
      for (var i = 0; i < loopLength; i++) {
        // String durationToString(Duration duration) =>
        //     (widget.contextPlaylist.tracks!.items![i].track!.durationMs! / 1000)
        //         .toStringAsFixed(2)
        //         .replaceFirst('.', ':')
        //         .padLeft(5, '0');

        items.add(SizedBox(
          height: 70,
          child: Row(
            children: [
              Expanded(
                  child: Container(
                color: colors.secondaryColor,
                margin: EdgeInsets.all(7),
                height: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: SizedBox.fromSize(
                      size: Size.fromRadius(100), // Image radius
                      child: widget.contextPlaylist.tracks!.items![i].track!
                              .album!.image ??
                          Container()),
                ),
              )),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 160,
                                child: Text(
                                  widget.contextPlaylist.tracks!.items![i]
                                      .track!.name
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.contextPlaylist.tracks!.items![i]
                                      .track!.artists![0].name
                                      .toString(),
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 20,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 20,
                        child: const Text(
                          '0:00m',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
      }
      return Column(children: items);
    } else {
      return const Text('No Track Found');
    }
  }

  @override
  Widget build(BuildContext context) => StoreProvider<int>(
      store: store,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        //backgroundColor: colors.secondaryColor,
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: Color.fromARGB(103, 42, 42, 42),
          elevation: 0,
          title: InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.startUp,
                  arguments: null,
                );
              },
              child: Icon(Icons.arrow_back_rounded)),
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: SizedBox.fromSize(
                            size: Size.fromRadius(100), // Image radius
                            child: widget.contextPlaylist.playlistImage ??
                                Container()),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.playlistname.toString(),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  height: 50,
                  decoration: BoxDecoration(),
                  child: Text(
                    widget.playlistDescription.toString(),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            _informationWidget('452323', true, MainAxisAlignment.end),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      height: 6,
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
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                        ),
                      ),
                    ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                        ),
                      ),
                      child: _isExtendedList
                          ? returnTracks(true)
                          : returnTracks(false),
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (_isExtendedList) {
                        _isExtendedList = false;
                      } else {
                        _isExtendedList = true;
                      }
                    });
                  },
                  child: Container(
                    //     margin: const EdgeInsets.symmetric(horizontal: 70),
                    height: 50,
                    width: 70,
                    decoration: BoxDecoration(
                      color: colors.secondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                        child: Text(
                      !_isExtendedList ? 'View More' : 'View Less',
                      style: const TextStyle(fontSize: 10),
                    )),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                  height: 20,
                )),
                Expanded(
                    flex: 6,
                    child: Container(
                      decoration: BoxDecoration(
                          color: colors.secondaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      height: 50,
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Featured Artists',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 4,
                    child: Container(
                      height: 20,
                    )),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    height: 120,
                    child: ListView(
                      // This next line does the trick.
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: 150.0,
                          decoration: BoxDecoration(
                            color: colors.secondaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: 150.0,
                          decoration: BoxDecoration(
                            color: colors.secondaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: 150.0,
                          decoration: BoxDecoration(
                            color: colors.secondaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: 150.0,
                          decoration: BoxDecoration(
                            color: colors.secondaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ));

  Row _informationWidget(String text, bool isNumOfFollowerWidget,
      MainAxisAlignment mainAxisAlignment) {
    return Row(
      children: [
        Expanded(
            child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: 50,
          decoration: const BoxDecoration(),
        )),
        Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 40,
              decoration: BoxDecoration(
                color: colors.secondaryColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
              child: isNumOfFollowerWidget
                  ? Row(
                      mainAxisAlignment: mainAxisAlignment,
                      children: [
                        Text(
                          text,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Followers',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    )
                  : Text(
                      text,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
            ))
      ],
    );
  }

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
