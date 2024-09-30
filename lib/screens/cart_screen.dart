import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change this to any color you want
        ),
        backgroundColor: Colors.blue,
        title: Text('Grocery Cart',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600)),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            if (state.products.isEmpty) {
              return Center(child: Text('Cart is empty'));
            }

            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products.keys.elementAt(index);
                final quantity = state.products[product] ?? 1;

                return  Card(
                  color: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    leading: Image.network(product.image),
                    title: Text(product.name),
                    subtitle:  Text('Total: \₹${(product.price * quantity).toStringAsFixed(2)}'),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          color: Colors.blue.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.add,size: 18,),
                            onPressed: () {
                              context.read<CartBloc>().add(AddProductToCart(product));
                            },
                          ),
                        ),
                        Text('$quantity',style: TextStyle(color: Colors.black,fontSize: 14),),
                        Card(
                          color: Colors.blue.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),                          child: IconButton(
                            icon: Icon(Icons.remove,size: 18,),
                            onPressed: () {
                              context.read<CartBloc>().add(RemoveProductFromCart(product));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );

              },
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
