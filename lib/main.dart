import 'package:al2_2024_bloc/products_bloc/products_bloc.dart';
import 'package:al2_2024_bloc/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsBloc(),
      child: const MaterialApp(
        home: ProductsScreen(),
      ),
    );
  }
}
