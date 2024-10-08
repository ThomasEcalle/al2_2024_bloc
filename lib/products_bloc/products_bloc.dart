import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../app_exception.dart';
import '../models/product.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(const ProductsState()) {
    on<GetAllProducts>((event, emit) async {
      try {
        emit(const ProductsState(status: ProductsStatus.loading));
        final products = await _getProducts();
        emit(ProductsState(
          products: products,
          status: ProductsStatus.success,
        ));
      } catch (error) {
        final appException = AppException.from(error);
        emit(ProductsState(
          status: ProductsStatus.error,
          exception: appException,
        ));
      }
    });
  }

  Future<List<Product>> _getProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    final response = await Dio().get('https://dummyjson.com/products');
    final jsonList = response.data['products'] as List;
    return jsonList.map((jsonElement) => Product.fromJson(jsonElement)).toList();
  }
}
