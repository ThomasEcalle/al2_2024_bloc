import 'package:al2_2024_bloc/shared/models/product.dart';

import 'local_products_data_source.dart';

class FakeLocalProductsDataSource extends LocalProductsDataSource {
  @override
  Future<List<Product>> getAllProducts() async {
    return const [
      Product(
        id: 42,
        name: 'Cached product',
        price: 100,
      ),
    ];
  }

  @override
  Future<void> save(List<Product> products) async {
    return;
  }
}
