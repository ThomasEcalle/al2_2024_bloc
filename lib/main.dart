import 'package:al2_2024_bloc/products_screen/products_screen.dart';
import 'package:al2_2024_bloc/shared/blocs/cart_bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_screen/cart_screen.dart';
import 'products_screen/product_detail_screen/product_detail_screen.dart';
import 'products_screen/products_bloc/products_bloc.dart';
import 'shared/models/product.dart';
import 'shared/services/remote_products_data_source/api_products_data_source.dart';
import 'shared/services/remote_products_data_source/fake_remote_products_data_source.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductsBloc(
            remoteProductsDataSource: FakeRemoteProductsDataSource(),
          ),
        ),
        BlocProvider(
          create: (context) => CartBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const ProductsScreen(),
          '/cart': (context) => const CartScreen(),
        },
        onGenerateRoute: (routeSettings) {
          Widget screen = Container(color: Colors.pink);
          final argument = routeSettings.arguments;
          switch (routeSettings.name) {
            case 'productDetail':
              if (argument is Product) {
                screen = ProductDetailScreen(product: argument);
              }
              break;
          }

          return MaterialPageRoute(builder: (context) => screen);
        },
      ),
    );
  }
}
