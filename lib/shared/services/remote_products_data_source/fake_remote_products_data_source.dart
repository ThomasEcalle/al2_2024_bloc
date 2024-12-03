import 'package:al2_2024_bloc/shared/models/product.dart';

import 'remote_products_data_source.dart';

class FakeRemoteProductsDataSource extends RemoteProductsDataSource {
  @override
  Future<List<Product>> getAllProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(2, (index) {
      return Product(
        id: index,
        name: 'Name $index',
        price: 42.0,
      );
    });
  }
}
