class Product {
  final List<dynamic> products;
  final String id;
  final String updatedAt;
  final Map<dynamic,dynamic> images;
  Product({required this.products,  required this.id,required this.updatedAt,required this.images});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      products: json['products'],
      id: json['_id'],
      updatedAt: json['updatedAt'],
      images: json['images']
    );
  }
}