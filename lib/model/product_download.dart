import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDownloadModel {
  final String pid, name, category, price, image, stock;

  const ProductDownloadModel({
    required this.pid,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.image,
  });

  ProductDownloadModel.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          category: json['category']! as String,
          price: json['price']! as String,
          stock: json['stock']! as String,
          pid: json['pid']! as String,
          image: json['image']! as String,
        );

  Map<String, Object?> toJson() => {
        'pid': pid,
        'name': name,
        'price': price,
        'category': category,
        'stock': stock,
        'image': image,
      };

  static ProductDownloadModel fromSnapshot(DocumentSnapshot snap) {
    ProductDownloadModel product = ProductDownloadModel(
      pid: snap['pid'],
      name: snap['name'],
      category: snap['category'],
      price: snap['price'],
      stock: snap['stock'],
      image: snap['image'],
    );
    return product;
  }
}
