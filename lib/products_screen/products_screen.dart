import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cart_screen/cart_screen.dart';
import '../shared/app_exception.dart';
import '../shared/blocs/cart_bloc/cart_bloc.dart';
import '../shared/models/product.dart';
import 'product_detail_screen/product_detail_screen.dart';
import 'products_bloc/products_bloc.dart';
import 'widgets/cart_icon.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    _getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: _onCartBlocListener,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Produits'),
          actions: [
            BlocBuilder<CartBloc, CartState>(
              buildWhen: (previous, current) {
                final addingOrRemovingCart = current.status == CartStatus.addingCart || current.status == CartStatus.removingCart;
                return !addingOrRemovingCart;
              },
              builder: (context, state) {
                return CartIcon(
                  onTap: _onCartIconTap,
                  count: state.getNbProductsInCart(),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            return Column(
              children: [
                Text('${state.status}'),
                Expanded(
                  child: switch (state.status) {
                    ProductsStatus.loading || ProductsStatus.initial => _buildLoading(context),
                    ProductsStatus.error => _buildError(context, state.exception),
                    ProductsStatus.success => _buildSuccess(context, state.products),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(BuildContext context, AppException? exception) {
    return const Center(
      child: Text('Oups, une erreur est survenue'),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return const Center(
      child: Text('Oups, aucun produit'),
    );
  }

  Widget _buildSuccess(BuildContext context, List<Product> products) {
    if(products.isEmpty) return _buildEmpty(context);
    return RefreshIndicator(
      onRefresh: () async {
        _getAllProducts();
      },
      child: ListView.separated(
        itemCount: products.length,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            onTap: () => _onProductTap(context, product),
          );
        },
      ),
    );
  }

  void _getAllProducts() {
    final productsBloc = context.read<ProductsBloc>();
    //final productsBloc = BlocProvider.of<ProductsBloc>(context);
    productsBloc.add(GetAllProducts());
  }

  void _onCartIconTap() {
    CartScreen.navigateTo(context);
  }

  void _onProductTap(BuildContext context, Product product) {
    ProductDetailScreen.navigateTo(context, product);
  }

  void _onCartBlocListener(BuildContext context, CartState state) {
    if (state.status == CartStatus.errorAddingCart) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'ajout du produit dans le panier: ${state.exception}'),
        ),
      );
    }
  }
}
