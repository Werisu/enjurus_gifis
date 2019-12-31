import 'package:flutter/material.dart';
import 'package:enjurus_gifis/ui/home_page.dart';

void main(){
  runApp(MaterialApp(
    home: HomePage(),
    title: "Buscador de Gif",
    theme: ThemeData(inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
    )),
  ));
}