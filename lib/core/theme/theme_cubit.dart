import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void toggleTheme() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) =>
      (json['isDark'] as bool? ?? false) ? ThemeMode.dark : ThemeMode.light;

  @override
  Map<String, dynamic>? toJson(ThemeMode state) =>
      {'isDark': state == ThemeMode.dark};
}
