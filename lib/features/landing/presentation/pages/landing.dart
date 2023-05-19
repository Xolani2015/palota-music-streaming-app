// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spotify_africa_assessment/colors.dart';
import 'package:flutter_spotify_africa_assessment/configurations/api.dart';
import 'package:flutter_spotify_africa_assessment/features/landing/presentation/animations/rive_assets.dart';
import 'package:flutter_spotify_africa_assessment/models/category_model.dart';
import 'package:flutter_spotify_africa_assessment/models/playlists_model.dart';
import 'package:flutter_spotify_africa_assessment/routes.dart';
import 'package:rive/rive.dart';
import 'package:http/http.dart' as http;

class LandingPage extends StatefulWidget {
  static const String _spotifyCategoryId = "afro";
  static CategoryModel _category = CategoryModel.invalid();

  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late RiveAnimationController _controller;

  Future<void> fetchPlaylists(CategoryModel category) async {
    var categoryName = category.name!.toLowerCase();
    Map<String, String> requestHeader = {
      'x-functions-key': headerkey,
    };
    final endPoint = 'browse/categories/$categoryName/playlists';
    final url = '$baseURL/$endPoint';
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: requestHeader);
    final body = response.body;
    final json = jsonDecode(body);
    var playlist = PlaylistsModel.fromJson(json);
    _navigateToSpotifyCategoryPage(context, category, playlist);
  }

  fetchCatergories() async {
    Map<String, String> requestHeader = {
      'x-functions-key': headerkey,
    };
    const endPoint = 'browse/categories/afro';
    const url = '$baseURL/$endPoint';
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: requestHeader);
    if (response.statusCode == 200) {
      final body = response.body;
      final json = jsonDecode(body);
      var category = CategoryModel.fromJson(json);
      fetchPlaylists(category);
    } else {
      //TODO: log d
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = OneShotAnimation(
      RiveAssets.palotaIntroAnimationName,
      onStop: () {
        Future.delayed(const Duration(seconds: 1)).then(
          (value) => fetchCatergories(),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RiveAnimation.asset(
            RiveAssets.palotaIntro,
            alignment: Alignment.center,
            fit: BoxFit.contain,
            controllers: [_controller],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                    color: const Color.fromRGBO(0, 0, 0, 0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                color: AppColors.cyan,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Please wait fetching',
                                  style: TextStyle(
                                      color: AppColors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'playlists...',
                                  style: TextStyle(
                                      color: AppColors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ))
                ],
              ),
              const SizedBox(
                height: 50,
              )
            ],
          )
        ],
      ),
    );
  }

  void _navigateToSpotifyCategoryPage(BuildContext context,
      CategoryModel category, PlaylistsModel playlistsModel) {
    Set categoryPlayLists = {category, playlistsModel};
    // replace because we don't want to navigate back to the landing screen
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.spotifyCategory,
      arguments: categoryPlayLists,
    );
  }
}
