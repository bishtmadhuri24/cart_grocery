import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CartDatabaseHelper {
  static final CartDatabaseHelper _instance = CartDatabaseHelper._();
  static Database? _database;

  CartDatabaseHelper._();

  factory CartDatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'cart.db');
    return await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE cart(id INTEGER PRIMARY KEY, name TEXT, price REAL, image TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<int> addToCart(Map<String, dynamic> item) async {
    final db = await database;
    return await db.insert('cart', item, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await database;
    return await db.query('cart');
  }

  Future<int> removeFromCart(int id) async {
    final db = await database;
    return await db.delete('cart', where: 'id = ?', whereArgs: [id]);
  }
}
