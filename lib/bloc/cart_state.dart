import '../model/product.dart';

abstract class CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final Map<Product, int> products; // Map of products and their quantities

  CartLoaded(this.products);

  double get totalPrice => products.entries
      .map((e) => e.key.price * e.value)
      .fold(0.0, (previousValue, element) => previousValue + element);
}
