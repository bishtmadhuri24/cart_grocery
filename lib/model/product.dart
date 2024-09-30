class Product {
  final int id;
  final String name;
  final double price;
  final String image;

  Product({required this.id, required this.name, required this.price, required this.image});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
    };
  }
}


class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}
