import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/product.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoading()) {
    on<LoadCart>((event, emit) {
      emit(CartLoaded({}));
    });

    on<AddProductToCart>((event, emit) {
      if (state is CartLoaded) {
        final loadedState = state as CartLoaded;
        final updatedProducts = Map<Product, int>.from(loadedState.products);
        updatedProducts.update(event.product, (quantity) => quantity + 1, ifAbsent: () => 1);
        emit(CartLoaded(updatedProducts));
      }
    });

    on<RemoveProductFromCart>((event, emit) {
      if (state is CartLoaded) {
        final loadedState = state as CartLoaded;
        final updatedProducts = Map<Product, int>.from(loadedState.products);
        if (updatedProducts.containsKey(event.product) && updatedProducts[event.product]! > 1) {
          updatedProducts[event.product] = updatedProducts[event.product]! - 1;
        } else {
          updatedProducts.remove(event.product);
        }
        emit(CartLoaded(updatedProducts));
      }
    });
  }
}
