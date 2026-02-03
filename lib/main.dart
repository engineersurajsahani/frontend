import 'package:flutter/material.dart';
import './screens/add_flower.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      title:"Flower App",
      initialRoute: '/',
      routes: {
        '/': (context) => AddFlowerScreen(),
      },
    );
  }
}