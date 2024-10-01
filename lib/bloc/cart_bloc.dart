import 'package:flutter_bloc/flutter_bloc.dart';
import '../db/cart_db.dart';
import '../model/product.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartDatabaseHelper databaseHelper;

  CartBloc({required this.databaseHelper}) : super(CartLoading()) {
    on<LoadCart>((event, emit) async {
      try {
        final cartItems = await databaseHelper.getCartItems();
        final Map<Product, int> loadedProducts = {};
        for (var item in cartItems) {
          Product product = Product(
            id: item['id'],
            name: item['name'],
            price: item['price'],
            image: item['image'],
          );
          loadedProducts[product] = item['quantity'];
        }
        emit(CartLoaded(loadedProducts));
      } catch (_) {
        emit(CartLoaded({}));
      }
    });

    on<AddProductToCart>((event, emit) async {
      if (state is CartLoaded) {
        final loadedState = state as CartLoaded;
        final updatedProducts = Map<Product, int>.from(loadedState.products);
        updatedProducts.update(event.product, (quantity) => quantity + 1, ifAbsent: () => 1);

        // Save to database
        await databaseHelper.insertProduct(event.product, updatedProducts[event.product]!);

        emit(CartLoaded(updatedProducts));
      }
    });

    on<RemoveProductFromCart>((event, emit) async {
      if (state is CartLoaded) {
        final loadedState = state as CartLoaded;
        final updatedProducts = Map<Product, int>.from(loadedState.products);
        if (updatedProducts.containsKey(event.product) && updatedProducts[event.product]! > 1) {
          updatedProducts[event.product] = updatedProducts[event.product]! - 1;

          // Update quantity in database
          await databaseHelper.updateProductQuantity(event.product.id, updatedProducts[event.product]!);
        } else {
          updatedProducts.remove(event.product);

          // Remove from database
          await databaseHelper.removeProduct(event.product.id);
        }
        emit(CartLoaded(updatedProducts));
      }
    });
  }
}
