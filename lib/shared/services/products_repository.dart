import '../models/product.dart';
import 'local_products_data_source/local_products_data_source.dart';
import 'remote_products_data_source/remote_products_data_source.dart';

class ProductsRepository {
  final RemoteProductsDataSource remoteProductsDataSource;
  final LocalProductsDataSource localDataSource;

  const ProductsRepository({
    required this.remoteProductsDataSource,
    required this.localDataSource,
  });

  Future<List<Product>> getAllProducts() async {
    try {
      final products = await remoteProductsDataSource.getAllProducts();
      await localDataSource.save(products);
      return products;
    } catch (error) {
      return localDataSource.getAllProducts();
    }
  }
}
