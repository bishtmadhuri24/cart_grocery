import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/product.dart';

class CartDatabaseHelper {
  static final CartDatabaseHelper _instance = CartDatabaseHelper._internal();
  static Database? _database;

  CartDatabaseHelper._internal();

  factory CartDatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cart.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE cart(id INTEGER PRIMARY KEY, name TEXT, price REAL, image TEXT, quantity INTEGER)',
        );
      },
    );
  }

  Future<void> insertProduct(Product product, int quantity) async {
    final db = await database;
    await db.insert(
      'cart',
      {
        'id': product.id,
        'name': product.name,
        'price': product.price,
        'image': product.image,
        'quantity': quantity,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await database;
    return await db.query('cart');
  }

  Future<void> updateProductQuantity(int productId, int quantity) async {
    final db = await database;
    await db.update(
      'cart',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  Future<void> removeProduct(int productId) async {
    final db = await database;
    await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart');
  }
}
