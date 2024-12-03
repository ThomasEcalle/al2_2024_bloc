import '../../models/product.dart';

abstract class RemoteProductsDataSource {
  Future<List<Product>> getAllProducts();
}