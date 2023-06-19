import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../shared/presentation/screens/home_screen.dart';

part 'pages.g.dart';

@riverpod
List<MaterialPage<dynamic>> pages(PagesRef ref) {
  return [
    const MaterialPage(
      child: HomeScreen(),
    ),
  ];
}
