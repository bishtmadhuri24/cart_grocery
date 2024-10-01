import 'package:bitspanindia_assignment/bloc/cart_bloc.dart';
import 'package:bitspanindia_assignment/bloc/cart_event.dart';
import 'package:bitspanindia_assignment/db/cart_db.dart';
import 'package:bitspanindia_assignment/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Future<void> main() async {

  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final cartDatabaseHelper = CartDatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => CartBloc(databaseHelper: cartDatabaseHelper)..add(LoadCart()),
        child: HomeScreen(),
      ),

    );
  }
}
