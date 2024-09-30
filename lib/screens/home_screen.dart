import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart'; // Import the state for CartLoaded
import '../model/product.dart';
import 'cart_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Product> products = [
    Product(id: 1, name: 'Fortune', price: 20.0, image: 'https://encrypted-tbn0.gstatic.com/shopping?q=tbn:ANd9GcSpIl0vTKS86o-aadOKKPi4E05lTW7jgBSRsAmSlwEr0vzQLg554lrhkW0l0tTKOJ54cb7LX9wOsLtq3SzU5Uepjpn-9uzCUdGzJmeoIE1KvmJcU-u7lN7d&usqp=CAE'),
    Product(id: 2, name: 'SuitCase', price: 30.0, image: 'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcSg2f1wU-P6T0QCAGoZ9AUKT5EGkWyI73_FqBW0OojokBVWP6sx2pSC318kbVzcS-j6CbcPlz5crI9ZTPw91IcZO7FYMFi2CtcJI9gktpT35Wf6yzrr0XVC&usqp=CAE'),
    Product(id: 3, name: 'Maggie', price: 10.0, image: 'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcRhK-z4Arofg0jyoQ0q-YdXEXR7FAfW8YKwEvT9iz3GqxnmI7ZH9kmq3Q7-7P_ZqrwOO0Zecb5kIENXA3KZfpVMgbEXakvJCsBgPTc3Zsem598PSVuWT7QWZg&usqp=CAE'),
    Product(id: 4, name: 'Frock', price: 30.0, image: 'https://m.media-amazon.com/images/I/61+rr2cf65L._SX679_.jpg'),
    Product(id: 5, name: 'Aashirwad', price: 20.0, image: 'https://encrypted-tbn2.gstatic.com/shopping?q=tbn:ANd9GcQz_AO0Mt_wRPEG0Fi5OBCafhm3dwFnMio9k9nTEZ8pQK2V3XpG5yVsNeP-ZNtGPyYvqp9M_yck4GzXJVK_PYkgAt7FxOLom5xsZENAn6hV1UOXzpCBd0ENnA&usqp=CAE'),

    // Add more products here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Grocery App',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600),),
        actions: [
          // BlocBuilder to listen for changes in cart state and show cart item count
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int itemCount = 0;
              if (state is CartLoaded) {
                itemCount = state.products.length; // Number of items in the cart
              }
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart,color: Colors.white,),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<CartBloc>(), // Pass the existing CartBloc
                          child: CartScreen(),
                        ),
                      ),
                    ),
                  ),
                  // Display the badge if there are items in the cart
                  if (itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$itemCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Space between cards
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4, // Shadow effect for the card
            child: Container(
              height: 120, // Fixed height for all items
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  // Image Section
                  Container(
                    width: 80, // Fixed width for the image
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(product.image),
                        fit: BoxFit.cover, // Ensures image covers the area
                      ),
                    ),
                  ),
                  SizedBox(width: 16), // Space between image and text
                  // Product Details Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1, // Limit text to a single line
                          overflow: TextOverflow.ellipsis, // Show "..." if text is too long
                        ),
                        SizedBox(height: 8),
                        Text(
                          '\₹${product.price}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Add Button Section
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      context.read<CartBloc>().add(AddProductToCart(product));
                    },
                  ),
                ],
              ),
            ),
          );
        },
      )

    );
  }
}
