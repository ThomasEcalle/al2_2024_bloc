part of 'cart_bloc.dart';

enum CartStatus {
  initial,
  addingCart,
  successAddingCart,
  errorAddingCart,
  removingCart,
  successRemovingCart,
  errorRemovingCart,
}

class CartState {
  final CartStatus status;
  final Map<Product, int> products;
  final AppException? exception;

  const CartState({
    this.status = CartStatus.initial,
    this.products = const {},
    this.exception,
  });

  CartState copyWith({
    CartStatus? status,
    Map<Product, int>? products,
    AppException? exception,
  }) {
    return CartState(
      status: status ?? this.status,
      products: products ?? this.products,
      exception: exception,
    );
  }

  int getNbProductsInCart() {
    return products.keys.fold(0, (previousValue, element) => previousValue + (products[element] ?? 0));
  }
}
