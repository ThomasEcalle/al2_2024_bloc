import 'package:al2_2024_bloc/shared/models/product.dart';
import 'package:dio/dio.dart';

import 'remote_products_data_source.dart';

class ApiProductsDataSource extends RemoteProductsDataSource {
  @override
  Future<List<Product>> getAllProducts() async {
    final response = await Dio().get('https://dummyjson.com/products');
    final jsonList = response.data['products'] as List;
    return jsonList.map((jsonElement) => Product.fromJson(jsonElement)).toList();
  }
}
