part of 'products_bloc.dart';

enum ProductsStatus {
  initial,
  loading,
  success,
  error,
}

class ProductsState {
  final ProductsStatus status;
  final List<Product> products;
  final AppException? exception;

  const ProductsState({
    this.status = ProductsStatus.initial,
    this.products = const [],
    this.exception,
  });
}
