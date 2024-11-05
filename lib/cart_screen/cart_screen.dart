import 'package:al2_2024_bloc/cart_screen/widgets/cart_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/blocs/cart_bloc/cart_bloc.dart';

class CartScreen extends StatelessWidget {
  static void navigateTo(BuildContext context) {
    Navigator.pushNamed(context, '/cart');
  }

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier'),
        actions: [
          IconButton(
            onPressed: () => _onCleanCart(context),
            icon: const Icon(Icons.cleaning_services),
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final products = state.products;
          if(products.isEmpty) return _buildEmptyCart(context);
          return ListView.separated(
            itemCount: products.keys.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final product = products.keys.elementAt(index);
              final quantity = products[product];
              return CartListItem(
                product: product,
                quantity: quantity ?? 0,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Votre panier est vide'),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Retour'),
          ),
        ],
      ),
    );
  }

  void _onCleanCart(BuildContext context) {
    BlocProvider.of<CartBloc>(context).add(const ClearCart());
  }
}
