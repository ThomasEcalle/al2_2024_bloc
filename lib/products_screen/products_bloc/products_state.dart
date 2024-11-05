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

  ProductsState copyWith({
    ProductsStatus? status,
    List<Product>? products,
    AppException? exception,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      exception: exception ?? this.exception,
    );
  }
}
