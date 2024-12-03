import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../shared/app_exception.dart';
import '../../shared/models/product.dart';
import '../../shared/services/products_repository.dart';
import '../../shared/services/remote_products_data_source/remote_products_data_source.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepository productsRepository;

  ProductsBloc({required this.productsRepository}) : super(const ProductsState()) {
    on<GetAllProducts>((event, emit) async {
      try {
        emit(state.copyWith(status: ProductsStatus.loading));
        final products = await productsRepository.getAllProducts();
        emit(state.copyWith(
          status: ProductsStatus.success,
          products: products,
        ));
      } catch (error) {
        final appException = AppException.from(error);
        emit(state.copyWith(
          status: ProductsStatus.error,
          exception: appException,
        ));
      }
    });
  }
}
