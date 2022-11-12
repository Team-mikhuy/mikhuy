import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.stock,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json, [String? id]) {
    return Product(
      id: id ?? json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      stock: json['stock'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }

  final String id;
  final String name;
  final String imageUrl;
  final int stock;
  final double price;

  static const empty = Product(
    id: '',
    name: '',
    imageUrl: '',
    stock: 0,
    price: 0,
  );

  @override
  List<Object?> get props => [id, name, imageUrl, stock, price];

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
      'stock': stock,
    };
  }
}
