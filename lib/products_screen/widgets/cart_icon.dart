import 'package:al2_2024_bloc/shared/blocs/cart_bloc/cart_bloc.dart';
import 'package:flutter/material.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({
    super.key,
    this.count = 0,
    this.onTap,
  });

  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    print('CartIcon build');
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$count'),
          const SizedBox(width: 8),
          const Icon(Icons.shopping_cart),
        ],
      ),
    );
  }
}
