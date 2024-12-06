import 'package:flutter/foundation.dart';

class Picker {
  String sku;
  int scannedQty;
  bool isFullyScanned;
  // String? awb;
  Picker(
      {required this.sku,
      required this.scannedQty,
      required this.isFullyScanned});
  factory Picker.fromJson(Map<String, dynamic> json) {
    return Picker(
        sku: json['sku'] ?? '',
        scannedQty: (json['scannedQty'] as num?)?.toInt() ?? 0,
        isFullyScanned: json['isFullyScanned'] ?? false);
  }
}

class Packer {
  String sku;
  int scannedQty;
  bool isFullyScanned;
  Packer(
      {required this.sku,
      required this.scannedQty,
      required this.isFullyScanned});
  factory Packer.fromJson(Map<String, dynamic> json) {
    return Packer(
        sku: json['sku'] ?? '',
        scannedQty: (json['scannedQty'] as num?)?.toInt() ?? 0,
        isFullyScanned: json['isFullyScanned'] ?? false);
  }
}

class Dimensions {
  final double length;
  final double width;
  final double height;

  Dimensions({
    this.length = 0.0,
    this.width = 0.0,
    this.height = 0.0,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      length: (json['length'] as num?)?.toDouble() ?? 0.0,
      width: (json['width'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'width': width,
      'height': height,
    };
  }
}

class ItemModel {
  double quantity;
  double amount;
  Product product;
  ItemModel({this.amount = 0.0, this.quantity = 0.0, required this.product});
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
        quantity: (json["qty"] as num?)?.toDouble() ?? 0.0,
        amount: (json["amount"] as num?)?.toDouble() ?? 0.0,
        product: Product.fromJson(json["product_id"]));
  }
  Map<String, dynamic> toJson() {
    return {
      'qty': quantity,
      'amount': amount,
      'product_id': product.toJson(),
    };
  }
}

class Product {
  final String id;
  final String displayName;
  final String parentSku;
  final String sku;
  final String ean;
  final String description;
  final String brand;
  final String category;
  final String technicalName;
  final String taxRule;
  final double netWeight;
  final double grossWeight;
  final String boxSize;
  final double mrp;
  final double cost;
  final bool active;
  final List<String> images;
  final String grade;
  final String shopifyImage;
  final Dimensions dimensions;
  DateTime upDatedAt;
  int itemQty;

  Product({
    this.id = '',
    this.displayName = '',
    this.parentSku = '',
    this.sku = '',
    this.ean = '',
    this.description = '',
    this.brand = '',
    this.category = '',
    this.technicalName = '',
    this.taxRule = '',
    this.netWeight = 0.0,
    this.grossWeight = 0.0,
    this.boxSize = '',
    this.mrp = 0.0,
    this.cost = 0.0,
    this.active = false,
    this.images = const [],
    this.grade = '',
    this.shopifyImage = '',
    required this.upDatedAt,
    required this.dimensions,
    this.itemQty = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      parentSku: json['parentSku'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      ean: json['ean'] as String? ?? '',
      description: json['description'] as String? ?? '',
      brand: '',
      category: '',
      technicalName: json['technicalName'] as String? ?? '',
      taxRule: json['tax_rule'] as String? ?? '',
      netWeight: (json['netWeight'] as num?)?.toDouble() ?? 0.0,
      grossWeight: (json['grossWeight'] as num?)?.toDouble() ?? 0.0,
      boxSize: '',
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      active: json['active'] as bool? ?? false,
      images: List<String>.from(json['images'] ?? []),
      grade: json['grade'] as String? ?? '',
      shopifyImage: json['shopifyImage'] as String? ?? '',
      upDatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      dimensions: Dimensions.fromJson(json['dimensions'] ?? {}),
      itemQty: (json['itemQty'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'displayName': displayName,
      'parentSku': parentSku,
      'sku': sku,
      'ean': ean,
      'description': description,
      'brand': brand,
      'category': category,
      'technicalName': technicalName,
      'tax_rule': taxRule,
      'netWeight': netWeight,
      'grossWeight': grossWeight,
      'boxSize': boxSize,
      'mrp': mrp,
      'cost': cost,
      'active': active,
      'images': images,
      'grade': grade,
      'shopifyImage': shopifyImage,
      'dimensions': dimensions.toJson(),
      'itemQty': itemQty,
    };
  }
}

class CheckerModel {
  bool approved;
  CheckerModel({required this.approved});
  factory CheckerModel.fromJson(Map<String, dynamic> json) {
    return CheckerModel(approved: json["approved"]);
  }
}

class RackerModel {
  bool approved;
  RackerModel({required this.approved});
  factory RackerModel.fromJson(Map<String, dynamic> json) {
    return RackerModel(approved: json["approved"]);
  }
}

class ManiFestModel {
  bool approved;
  ManiFestModel({required this.approved});
  factory ManiFestModel.fromJson(Map<String, dynamic> json) {
    return ManiFestModel(approved: json["approved"]);
  }
}

class ModelByDipu {
  String orderId;
  List<ItemModel>? items;
  List<Picker>? picker;
  List<Packer>? packer;
  CheckerModel checker;
  RackerModel racker;
  ManiFestModel mainFest;
  bool isPickerFullyScanned;
  bool isPackerFullyScanned;
  String awb;
  DateTime updatedAt;
  // String shopifyImage;
  ModelByDipu(
      {required this.orderId,
      this.items,
      this.picker,
      required this.isPickerFullyScanned,
      required this.checker,
      required this.racker,
      required this.mainFest,
      required this.isPackerFullyScanned,
      required this.packer,
      required this.awb,
      required this.updatedAt});
  factory ModelByDipu.fromJson(Map<String, dynamic> json) {
    print(
        "model dipu ${json['isPickerFullyScanned']}   ${List.from(json['items']).length}");
    for (int i = 0; i < List.from(json['items']).length; i++) {
      print("item are here ${json['items'][i]}");
    }
    if (json['picker'] == null) {
      json['picker'] = [];
    }
    return ModelByDipu(
      orderId: json['order_id'],
      // items: (json['items'] as List)
      //     .map((itemJson) => ItemModel.fromJson(itemJson))
      //     .toList(),
      items: (json['items'] as List).map((e) => ItemModel.fromJson(e)).toList(),
      picker: (json['picker'] as List)
          .map((e) => Picker.fromJson(e as Map<String, dynamic>))
          .toList(),
      packer: (json['packer'] as List)
          .map((e) => Packer.fromJson(e as Map<String, dynamic>))
          .toList(),
      isPickerFullyScanned: json["isPickerFullyScanned"],
      checker: CheckerModel.fromJson(json["checker"]),
      racker: RackerModel.fromJson(json["racker"]),
      mainFest: ManiFestModel.fromJson(json["checkManifest"]),
      isPackerFullyScanned: json["isPackerFullyScanned"],
      awb: json["awb_number"] ?? '',
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

// class StatusModel {
//   final String id; // Corresponds to _id
//   final int statusId;
//   final String status;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final int version; // Corresponds to __v

//   StatusModel({
//     required this.id,
//     required this.statusId,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.version,
//   });

//   factory StatusModel.fromJson(Map<String, dynamic> json) {
//     return StatusModel(
//       id: json['_id'] ?? '', // Default to empty string if null
//       statusId: json['status_id'] ?? 0, // Default to 0 if null
//       status: json['status'] ?? '', // Default to empty string if null
//       createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
//       updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
//       version: json['__v'] ?? 0, // Default to 0 if null
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'status_id': statusId,
//       'status': status,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//       '__v': version,
//     };
//   }
// }

// "_id": "66fe7008d5c08322975858ae",
// "order_id": "dummyOrderId2324324",
// "phone": 1234567890,
// "payment_mode": "Credit Card",
// "currency_code": "INR",

// "picker": null,
// "packer": null,
// "code": null,
// "sku_tracking_id": "abcd12345",
// "total_weight": 10,
// "total_amt": 2,
// "coin": 10,
// "cod_amount": 1,
// "prepaid_amount": 2,
// "discount_scheme": "None",
// "discount_percent": 0,
// "discount_amount": 0,
// "tax_percent": 0,
// "courier_name": "dummy",
// "order_type": "New Order",
// "order_status": 4,
// "order_status_map": [
//   {
//     "_id": "66fe7008d5c08322975858ab",
//     "status_id": 0,
//     "status": "failed",
//     "createdAt": "2024-10-03T10:20:56.647Z",
//     "updatedAt": "2024-10-03T10:20:56.647Z",
//     "__v": 0
//   }
// ],
// "filter": "B2C",

// "source": "internal",
// "agent": "Agent Smith",
// "notes": "Handle with care.",
//   "date": "2024-10-03T10:20:56.864Z",
//   "createdAt": "2024-10-03T10:20:56.873Z",
//   "updatedAt": "2024-10-03T10:20:56.873Z",
//   "__v": 0
// }
