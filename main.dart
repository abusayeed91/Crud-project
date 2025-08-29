import 'package:flutter/material.dart';
import 'package:product_app/screens/home_screen.dart';

void main(){
  runApp(ProductApp());
}

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'product App',
      theme: ThemeData(
        colorSchemeSeed: Colors.green.shade50
      ),
      home:HomeScreen () ,
    );
  }
}
