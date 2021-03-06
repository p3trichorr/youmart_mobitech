class ProductUploadModel {
  String? pid, name, category, image, price, stock;

  ProductUploadModel(
      {this.pid, this.name, this.price, this.stock, this.category, this.image});

  // receiving data from server
  factory ProductUploadModel.fromMap(map) {
    return ProductUploadModel(
        pid: map['pid'],
        name: map['name'],
        price: map['price'],
        stock: map['stock'],
        category: map['category'],
        image: map['image']);

  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'pid': pid,
      'name': name,
      'price': price,
      'stock': stock,
      'category': category,
      'image': image,
    };
  }

  Map<String, dynamic> toJson() => {
        'pid': pid,
        'name': name,
        'price': price,
        'stock': stock,
        'category': category,
        'image': image,
      };

  static ProductUploadModel fromJson(Map<String, dynamic> json) =>
      ProductUploadModel(
        pid: json['id'],
        name: json['name'],
        price: json['price'],
        stock: json['stock'],
        category: json['category'],
        image: json['image'],
      );
}
