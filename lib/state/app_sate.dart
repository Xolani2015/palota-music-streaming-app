import 'package:flutter/material.dart';
import 'package:flutter_spotify_africa_assessment/models/category_model.dart';

@immutable
class AppState {
  final bool? isLoading;
  final CategoryModel? category;

  const AppState({
    this.isLoading,
    this.category,
  });

  factory AppState.init() =>
      AppState(isLoading: false, category: CategoryModel.invalid());

  AppState copyWith({
    bool? isLoading,
    CategoryModel? category,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      category: category ?? this.category,
    );
  }
}
