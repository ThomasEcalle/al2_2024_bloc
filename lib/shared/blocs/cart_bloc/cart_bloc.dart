import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../app_exception.dart';
import '../../models/product.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddProduct>(_onAddProduct);
    on<RemoveProduct>(_onRemoveProduct);
    on<ClearCart>(_onClearCart);
  }

  void _onAddProduct(AddProduct event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.addingCart));
    await Future.delayed(const Duration(seconds: 1));

    /// Fake limit of 5 products in the cart to illustrate error handling
    final currentProductsCount = state.getNbProductsInCart();
    if (currentProductsCount >= 5) {
      emit(state.copyWith(
        status: CartStatus.errorAddingCart,
        exception: CartProductsLimitException(),
      ));
      return;
    }

    final product = event.product;
    emit(state.copyWith(
      products: {
        ...state.products,
        product: (state.products[product] ?? 0) + 1,
      },
      status: CartStatus.successAddingCart,
    ));
  }

  void _onRemoveProduct(RemoveProduct event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.removingCart));
    await Future.delayed(const Duration(seconds: 1));

    final product = event.product;
    final newProductCount = ((state.products[product] ?? 0) - 1);

    if (newProductCount <= 0) {
      final newProducts = {...state.products};
      newProducts.remove(product);
      emit(state.copyWith(
        products: newProducts,
        status: CartStatus.successRemovingCart,
      ));
      return;
    }

    emit(state.copyWith(
      products: {
        ...state.products,
        product: newProductCount,
      },
      status: CartStatus.successRemovingCart,
    ));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(
      products: {},
      status: CartStatus.initial,
    ));
  }
}
