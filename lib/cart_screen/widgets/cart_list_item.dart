import 'package:flutter/material.dart';

import '../../shared/models/product.dart';

class CartListItem extends StatelessWidget {
  const CartListItem({
    super.key,
    required this.product,
    required this.quantity,
  });

  final Product product;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text('Quantité: $quantity'),
    );
  }
}
