import '../../models/product.dart';
import '../remote_products_data_source/remote_products_data_source.dart';

abstract class LocalProductsDataSource extends RemoteProductsDataSource {
  Future<void> save(List<Product> products);
}
