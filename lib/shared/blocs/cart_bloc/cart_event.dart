part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {
  const CartEvent();
}

class AddProduct extends CartEvent {
  const AddProduct(this.product);

  final Product product;
}

class RemoveProduct extends CartEvent {
  const RemoveProduct(this.product);

  final Product product;
}

class ClearCart extends CartEvent {
  const ClearCart();
}
