// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:al2_2024_bloc/products_screen/products_bloc/products_bloc.dart';
import 'package:al2_2024_bloc/products_screen/products_screen.dart';
import 'package:al2_2024_bloc/shared/blocs/cart_bloc/cart_bloc.dart';
import 'package:al2_2024_bloc/shared/models/product.dart';
import 'package:al2_2024_bloc/shared/services/local_products_data_source/local_products_data_source.dart';
import 'package:al2_2024_bloc/shared/services/products_repository.dart';
import 'package:al2_2024_bloc/shared/services/remote_products_data_source/remote_products_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class ErrorRemoteProductsDataSource extends RemoteProductsDataSource {
  @override
  Future<List<Product>> getAllProducts() {
    throw Exception();
  }
}

class EmptyRemoteProductsDataSource extends RemoteProductsDataSource {
  @override
  Future<List<Product>> getAllProducts() async {
    return [];
  }
}

class FakeRemoteProductsDataSource extends RemoteProductsDataSource {
  @override
  Future<List<Product>> getAllProducts() async {
    return List.generate(
      5,
      (index) => Product(
        id: index,
        name: 'name $index',
        price: 3.0,
      ),
    );
  }
}

class ErrorLocalProductsDataSource extends LocalProductsDataSource {
  @override
  Future<List<Product>> getAllProducts() async {
    throw Exception();
  }

  @override
  Future<void> save(List<Product> products) async {
    throw Exception();
  }
}

class EmptyLocalProductsDataSource extends LocalProductsDataSource {
  @override
  Future<List<Product>> getAllProducts() async {
    return [];
  }

  @override
  Future<void> save(List<Product> products) async {}
}

class FakeLocalProductsDataSource extends LocalProductsDataSource {
  @override
  Future<List<Product>> getAllProducts() async {
    return List.generate(
      5,
      (index) => Product(
        id: index,
        name: 'name $index',
        price: 3.0,
      ),
    );
  }

  @override
  Future<void> save(List<Product> products) async {}
}

Widget _buildProductsScreen({
  RemoteProductsDataSource? remoteDataSource,
  LocalProductsDataSource? localDataSource,
}) {
  return RepositoryProvider(
    create: (context) => ProductsRepository(
      remoteProductsDataSource: remoteDataSource ?? FakeRemoteProductsDataSource(),
      localDataSource: localDataSource ?? FakeLocalProductsDataSource(),
    ),
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CartBloc(),
        ),
        BlocProvider(
          create: (context) => ProductsBloc(
            productsRepository: context.read<ProductsRepository>(),
          ),
        ),
      ],
      child: const MaterialApp(
        home: ProductsScreen(),
      ),
    ),
  );
}

void main() {
  group('$ProductsScreen', () {
    testWidgets('Title should be "Products"', (WidgetTester tester) async {
      await tester.pumpWidget(_buildProductsScreen());
      expect(find.text('Produits'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('A CircularProgressIndicator should be visible when loading', (WidgetTester tester) async {
      await tester.pumpWidget(_buildProductsScreen());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('An appropriate error message should be visible on error', (WidgetTester tester) async {
      await tester.pumpWidget(_buildProductsScreen(
        remoteDataSource: ErrorRemoteProductsDataSource(),
        localDataSource: ErrorLocalProductsDataSource(),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Oups, une erreur est survenue'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('An appropriate message should be visible when products list is empty', (WidgetTester tester) async {
      await tester.pumpWidget(_buildProductsScreen(
        remoteDataSource: EmptyRemoteProductsDataSource(),
        localDataSource: EmptyLocalProductsDataSource(),
      ));

      await tester.pumpAndSettle();
      expect(find.text('Oups, aucun produit'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('Should show a products list on success', (WidgetTester tester) async {
      await tester.pumpWidget(_buildProductsScreen(
        remoteDataSource: FakeRemoteProductsDataSource(),
      ));

      await tester.pumpAndSettle();

      expect(find.text('name 0'), findsOneWidget);
      expect(find.text('name 1'), findsOneWidget);
      expect(find.text('name 2'), findsOneWidget);
      expect(find.text('name 3'), findsOneWidget);

      await tester.pumpAndSettle();
    });
  });
}
