import 'package:flutter/material.dart';
import 'package:gif_search/ui/gif_page.dart';
import 'package:gif_search/ui/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),
      theme: ThemeData(hintColor: Colors.white, appBarTheme: AppBarTheme(color: Colors.white)),
    )
  );
}
