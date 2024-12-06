import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qrorganic/custom/colors.dart';

class Order {
  final Customer? customer;
  final String source;
  final String id;
  final String orderId;
  final DateTime? date;
  final String paymentMode;
  final String currencyCode;
  final List<Item> items;
  final String skuTrackingId;
  final double totalWeight;
  final double? totalAmount;
  final int coin;
  final double codAmount;
  final double prepaidAmount;
  final String discountCode;
  final String discountScheme;
  final int discountPercent;
  final double discountAmount;
  final int taxPercent;
  final Address? billingAddress;
  final Address? shippingAddress;
  final String courierName;
  final String orderType;
  final String outerPackage;
  final bool replacement;
  int orderStatus;
  bool isBooked;
  bool checkInvoice;
  // final List<OrderStatusMap>? orderStatusMap;
  final Marketplace? marketplace;
  final String agent;
  final String? filter;
  final FreightCharge? freightCharge;
  final String notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  bool isSelected;
  final bool isPickerFullyScanned;
  final bool isPackerFullyScanned;
  final DateTime? expectedDeliveryDate;
  final String preferredCourier;
  final String deliveryTerm;
  final String transactionNumber;
  final String microDealerOrder;
  final String fulfillmentType;
  final int numberOfBoxes;
  final int totalQuantity;
  final int skuQty;
  final String calcEntryNumber;
  final String currency;
  final DateTime? paymentDateTime;
  final String paymentBank;
  final double length;
  final double breadth;
  final double height;
  final String shipmentId;
  final String shiprocketOrderId;
  final String awbNumber;
  final String? image;
  final Checker? checker;
  final Racker? racker;
  final CheckManifest? checkManifest;
  late String? trackingStatus;

  Order({
    this.isBooked = false,
    this.checkInvoice = false,
    this.customer,
    this.source = '',
    this.id = '',
    this.orderId = '',
    this.date,
    this.paymentMode = '',
    this.currencyCode = '',
    required this.items,
    this.skuTrackingId = '',
    this.totalWeight = 0.0,
    this.totalAmount = 0.0,
    this.coin = 0,
    this.codAmount = 0.0,
    this.prepaidAmount = 0.0,
    this.discountCode = '',
    this.discountScheme = '',
    this.discountPercent = 0,
    this.discountAmount = 0.0,
    this.taxPercent = 0,
    this.billingAddress,
    this.shippingAddress,
    this.courierName = '',
    this.orderType = '',
    this.outerPackage = '',
    this.replacement = false,
    required this.orderStatus,
    // this.orderStatusMap,
    this.marketplace,
    this.agent = '',
    this.filter = '',
    this.freightCharge,
    this.notes = '',
    this.createdAt,
    this.updatedAt,
    this.isSelected = false,
    this.isPickerFullyScanned = false,
    this.isPackerFullyScanned = false,
    this.expectedDeliveryDate,
    this.preferredCourier = '',
    this.deliveryTerm = '',
    this.transactionNumber = '',
    this.microDealerOrder = '',
    this.fulfillmentType = '',
    this.numberOfBoxes = 0,
    this.totalQuantity = 0,
    this.skuQty = 0,
    this.calcEntryNumber = '',
    this.currency = '',
    this.paymentDateTime,
    this.paymentBank = '',
    this.length = 0.0,
    this.breadth = 0.0,
    this.height = 0.0,
    this.shipmentId = '',
    this.shiprocketOrderId = '',
    this.awbNumber = '',
    this.image = '',
    required this.checker,
    required this.racker,
    required this.checkManifest,
    this.trackingStatus,
  });

  // Utility function to safely parse a string from any data type
  static String _parseString(dynamic value) {
    return value?.toString() ?? ''; // Dispatched an empty string if null
  }

  // Utility function to parse a double from any data type
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    return value is num
        ? value.toDouble()
        : double.tryParse(value.toString()) ?? 0.0;
  }

  // Utility function to parse an integer from any data type
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    return value is int ? value : int.tryParse(value.toString()) ?? 0;
  }

  // Method to get the image or a default icon if the image is not available
  Widget getOrderImage() {
    if (image != null && image!.isNotEmpty) {
      return Image.network(
        image!,
        width: 200, // You can adjust the size as needed
        height: 200,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.broken_image,
            size: 200,
            color: AppColors.grey,
          ); // Fallback to an icon if the image fails to load
        },
      );
    } else {
      return const Icon(Icons.image,
          size: 200,
          color:
              AppColors.grey); // Dispatched an icon if the image is not present
    }
  }

// Function to parse a string and return a DateTime? object
  /// Parses a date string and returns a DateTime object, handling multiple formats.
  static DateTime? _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      //print("Invalid or empty date string");
      return null; // Dispatched null for invalid or empty strings
    }

    // Try parsing using DateTime.parse()
    try {
      return DateTime.parse(dateString).toLocal();
    } catch (e) {
      //print("DateTime.parse failed for '$dateString': $e");
    }

    // Define formats to try for parsing
    List<String> formats = [
      "EEE MMM dd yyyy HH:mm:ss 'GMT'Z", // e.g., Thu Oct 10 2024 11:18:19 GMT+0000
      "yyyy-MM-dd HH:mm:ss", // e.g., 2024-09-26 12:00:00
      "dd-MM-yyyy", // e.g., 26-09-2024
      "MM/dd/yyyy", // e.g., 09/26/2024
      "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", // e.g., 2024-09-26T12:00:00.000Z
      "yyyy-MM-dd'T'HH:mm:ss'Z'", // e.g., 2024-09-26T12:00:00Z
      "yyyy-MM-dd'T'HH:mm:ss", // e.g., 2024-09-26T12:00:00
      "yyyy.MM.dd HH:mm:ss", // e.g., 2024.09.26 12:00:00
      "MMMM dd, yyyy", // e.g., September 26, 2024
      "dd MMM yyyy", // e.g., 26 Sep 2024
      "dd MMM yyyy hh:mm a", // e.g., 10 Oct 2024 11:18 AM
    ];

    // Try parsing with each format
    for (var format in formats) {
      try {
        return DateFormat(format).parse(dateString, true).toLocal();
      } catch (e) {
        // Log errors but continue trying other formats
        //print("Failed to parse using format '$format': $e");
      }
    }

    //print("Error: Could not parse date string: '$dateString'");
    return null; // Dispatched null if all parsing attempts fail
  }

  /// Formats a DateTime object to 'dd-MM-yyyy' string.
  static String? formatDate(DateTime? date) {
    return date == null ? null : DateFormat('dd-MM-yyyy').format(date);
  }

  /// Parses a date string and returns it formatted as 'dd-MM-yyyy'.
  static String? parseAndFormatDate(String? dateString) {
    DateTime? parsedDate = _parseDate(dateString);
    return parsedDate != null ? formatDate(parsedDate) : null;
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        isBooked: json['isBooked']['status'] ?? false,
        checkInvoice: json['checkInvoice']['approved'] ?? false,
        customer: json['customer'] != null
            ? Customer.fromJson(json['customer'])
            : null,
        source: _parseString(json['source']),
        id: _parseString(json['_id']),
        orderId: _parseString(json['order_id']),
        date: _parseDate(_parseString(json['date'])),
        paymentMode: _parseString(json['payment_mode']),
        currencyCode: _parseString(json['currency_code']),
        items: (json['items'] as List?)
                ?.map((item) => Item.fromJson(item))
                .toList() ??
            [],
        skuTrackingId: _parseString(json['sku_tracking_id']),
        totalWeight: _parseDouble(json['total_weight'] ?? 0),
        totalAmount: _parseDouble(json['total_amt']),
        coin: _parseInt(json['coin']),
        codAmount: _parseDouble(json['cod_amount']),
        prepaidAmount: _parseDouble(json['prepaid_amount']),
        discountCode: _parseString(json['discount_code']),
        discountScheme: _parseString(json['discount_scheme']),
        discountPercent: _parseInt(json['discount_percent']),
        discountAmount: _parseDouble(json['discount_amount']),
        taxPercent: _parseInt(json['tax_percent']),
        billingAddress: json['billing_addr'] is Map<String, dynamic>
            ? Address.fromJson(json['billing_addr'])
            : Address(address1: _parseString(json['billing_addr'])),
        shippingAddress: json['shipping_addr'] is Map<String, dynamic>
            ? Address.fromJson(json['shipping_addr'])
            : Address(address1: _parseString(json['shipping_addr'])),
        courierName: _parseString(json['courier_name']),
        orderType: _parseString(json['order_type']),
        outerPackage: _parseString(json['outerPackage']),
        replacement: json['replacement'] is bool ? json['replacement'] : false,
        orderStatus: _parseInt(json['order_status']),
        // orderStatusMap: (json['order_status_map'] as List?)
        //         ?.map((status) => OrderStatusMap.fromJson(status))
        //         .toList() ??
        //     [],
        marketplace: json['marketplace'] != null
            ? Marketplace.fromJson(json['marketplace'])
            : null,
        agent: _parseString(json['agent']),
        filter: _parseString(json['filter']),
        freightCharge: json['freight_charge'] != null
            ? FreightCharge.fromJson(json['freight_charge'])
            : null,
        notes: _parseString(json['notes']),
        createdAt: _parseDate(_parseString(json['createdAt'])),
        updatedAt: _parseDate(_parseString(json['updatedAt'])),
        isPickerFullyScanned: json['isPickerFullyScanned'] ?? false,
        isPackerFullyScanned: json['isPackerFullyScanned'] ?? false,
        expectedDeliveryDate:
            _parseDate(_parseString(json['expected_delivery_date'])),
        preferredCourier: _parseString(json['preferred_courier']),
        deliveryTerm: _parseString(json['delivery_term']),
        transactionNumber: _parseString(json['transaction_number']),
        microDealerOrder: _parseString(json['micro_dealer_order']),
        fulfillmentType: _parseString(json['fulfillment_type']),
        numberOfBoxes: _parseInt(json['number_of_boxes']),
        totalQuantity: _parseInt(json['total_quantity']),
        skuQty: _parseInt(json['sku_qty']),
        calcEntryNumber: _parseString(json['calc_entry_number']),
        currency: _parseString(json['currency']),
        paymentDateTime: _parseDate(_parseString(json['payment_date_time'])),
        paymentBank: _parseString(json['payment_bank']),
        length: _parseDouble(json['length']),
        breadth: _parseDouble(json['breadth']),
        height: _parseDouble(json['height']),
        shipmentId: _parseString(json['shipment_id']),
        shiprocketOrderId: _parseString(json['shiprocket_order_id']),
        awbNumber: _parseString(json['awb_number']),
        image: json['image'] ?? '',
        checker: Checker.fromJson(json['checker']),
        racker: Racker.fromJson(json['racker']),
        checkManifest: CheckManifest.fromJson(json['checkManifest']),
        trackingStatus: _parseString(json['tracking_status']));
  }
}

class Customer {
  final String? customerId;
  final String? firstName;
  final String? lastName;
  final int? phone;
  final String? email;
  final String? billingAddress;
  final String? customerGstin;
  final String? customerType;

  Customer({
    required this.customerId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.billingAddress,
    required this.customerGstin,
    this.customerType,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customer_id']?.toString() ??
          '', // Handle null and non-string data
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      phone: json['phone'] is int
          ? json['phone']
          : null, // Handle non-integer data
      billingAddress: json['billing_addr']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      customerGstin: json['customer_gstin']?.toString() ?? '',
      customerType: json['customer_type']?.toString() ?? '',
    );
  }
}

class Item {
  final int? qty;
  //final String? productId;
  final Product? product;
  final double? amount;
  final String? sku;
  final String? id;
  final bool? isCombo;
  final String? comboSku;
  final String? comboName;
  int? comboAmount = 0;

  Item({
    required this.qty,
    this.isCombo,
    this.comboAmount,
    this.comboSku,
    this.comboName,
    this.product,
    required this.amount,
    required this.sku,
    required this.id,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      qty: json['qty']?.toInt() ?? 0, // Handle null and non-integer data
      // productId: json['product_id']?.toString() ?? '',
      isCombo: json['isCombo'] ?? false,
      comboAmount: json['comboAmount'] ?? 0,
      comboSku: json['comboSku'] ?? '',
      comboName: json['combo_id'] != null ? json['combo_id']['name'] : '',
      product: json['product_id'] != null
          ? Product.fromJson(json['product_id'])
          : null,
      amount: (json['amount'] as num?)?.toDouble() ??
          0.0, // Handle null and non-numeric data
      sku: json['sku']?.toString() ?? '',
      id: json['_id']?.toString() ?? '',
    );
  }
}

class Product {
  final Dimensions? dimensions;
  final String? id;
  final String displayName;
  final String? parentSku;
  final String? sku;
  final String? ean;
  final String? description;
  final Brand? brand;
  final Category? category;
  final String? technicalName;
  final Label? label;
  final Colour? color;
  final String? taxRule;
  final BoxSize? boxSize;
  final OuterPackage? outerPackage;
  final double? netWeight;
  final double? grossWeight;
  final double? mrp;
  final double? cost;
  final bool? active;
  final List<String>? images;
  final String? grade;
  final String? shopifyImage;
  final String? variantName;

  Product({
    required this.dimensions,
    required this.id,
    required this.displayName,
    required this.parentSku,
    required this.sku,
    required this.ean,
    required this.description,
    required this.brand,
    required this.category,
    required this.technicalName,
    this.label,
    required this.color,
    required this.taxRule,
    this.boxSize,
    this.outerPackage,
    required this.netWeight,
    required this.grossWeight,
    required this.mrp,
    required this.cost,
    required this.active,
    required this.images,
    required this.grade,
    required this.shopifyImage,
    required this.variantName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      dimensions: json['dimensions'] != null
          ? Dimensions.fromJson(json['dimensions'])
          : null,
      id: json['_id']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
      parentSku: json['parentSku']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      ean: json['ean']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      brand: json['brand'] is Map<String, dynamic>
          ? Brand.fromJson(json['brand'])
          : (json['brand'] is String ? Brand(id: json['brand']) : null),
      category: json['category'] is Map<String, dynamic>
          ? Category.fromJson(json['category'])
          : (json['category'] is String
              ? Category(id: json['category'])
              : null),
      technicalName: json['technicalName']?.toString() ?? '',
      label: json['label'] is Map<String, dynamic>
          ? Label.fromJson(json['label'])
          : (json['label'] is String ? Label(id: json['label']) : null),
      color: json['color'] is Map<String, dynamic>
          ? Colour.fromJson(json['color'])
          : (json['color'] is String ? Colour(id: json['color']) : null),
      taxRule: json['tax_rule']?.toString() ?? '',
      boxSize: json['boxSize'] is Map<String, dynamic>
          ? BoxSize.fromJson(json['boxSize'])
          : (json['boxSize'] is String ? BoxSize(id: json['boxSize']) : null),
      outerPackage: json['outerPackage'] is Map<String, dynamic>
          ? OuterPackage.fromJson(json['outerPackage'])
          : (json['outerPackage'] is String
              ? OuterPackage(id: json['outerPackage'])
              : null),
      netWeight: (json['netWeight'] as num?)?.toDouble() ?? 0.0,
      grossWeight: (json['grossWeight'] as num?)?.toDouble() ?? 0.0,
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      active: json['active'] ?? true, // Default to true if not present
      images:
          (json['images'] as List?)?.map((img) => img.toString()).toList() ??
              [],
      grade: json['grade']?.toString() ?? '',
      shopifyImage: json['shopifyImage']?.toString() ?? '',
      variantName: json['variant_name']?.toString() ?? '',
    );
  }
}

class Colour {
  final String? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Constructor
  Colour({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create a Color object from JSON
  factory Colour.fromJson(Map<String, dynamic> json) {
    return Colour(
      id: json['_id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Method to convert the Color object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'createdAt': createdAt!.toIso8601String(),
      'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}

class Brand {
  final String? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Brand({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['_id'],
      name: json['name'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class Category {
  final String? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Category({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class Label {
  final String? id;
  final String? name;
  final String? labelSku;
  final String? productSku;
  final int? quantity;
  final String? description;

  Label(
      {this.id,
      this.name,
      this.labelSku,
      this.productSku,
      this.quantity,
      this.description});

  factory Label.fromJson(Map<String, dynamic> json) {
    return Label(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      labelSku: json['labelSku'] as String?,
      productSku: json['product SKU '] as String?,
      quantity: json['quantity'] as int?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'labelSku': labelSku,
      'product SKU ': productSku,
      'quantity': quantity,
      'description': description,
    };
  }
}

class OuterPackage {
  final String? id;
  final String? outerPackageSku;
  final String? outerPackageName;
  final String? outerPackageType;
  final num? occupiedWeight;
  final String? weightUnit;
  final String? lengthUnit;

  OuterPackage(
      {this.id,
      this.outerPackageSku,
      this.outerPackageName,
      this.outerPackageType,
      this.occupiedWeight,
      this.weightUnit,
      this.lengthUnit});

  factory OuterPackage.fromJson(Map<String, dynamic> json) {
    return OuterPackage(
      id: json['_id'] as String?,
      outerPackageSku: json['outerPackage_sku'] as String?,
      outerPackageName: json['outerPackage_name'] as String?,
      outerPackageType: json['outerPackage_type'] as String?,
      occupiedWeight: json['occupied_weight'] as num?,
      weightUnit: json['weight_unit'] as String?,
      lengthUnit: json['length_unit'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'outerPackage_sku': outerPackageSku,
      'outerPackage_name': outerPackageName,
      'outerPackage_type': outerPackageType,
      'occupied_weight': occupiedWeight,
      'weight_unit': weightUnit,
      'length_unit': lengthUnit
    };
  }
}

class BoxSize {
  final String? id;
  final String? boxName;
  final String? unit;

  BoxSize({
    this.id,
    this.boxName,
    this.unit,
  });

  factory BoxSize.fromJson(Map<String, dynamic> json) {
    return BoxSize(
      id: json['_id'] as String?,
      boxName: json['box_name'] as String?,
      unit: json['unit'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'box_name': boxName,
      'unit': unit,
    };
  }
}

class BoxDimensions {
  final double? length;
  final double? width;
  final double? height;

  BoxDimensions({
    this.length,
    this.width,
    this.height,
  });

  factory BoxDimensions.fromJson(Map<String, dynamic> json) {
    return BoxDimensions(
      length: (json['length'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
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

class Dimensions {
  final double? length;
  final double? width;
  final double? height;

  Dimensions({
    required this.length,
    required this.width,
    required this.height,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      length: (json['length'] as num?)?.toDouble() ??
          0.0, // Handle null and non-numeric data
      width: (json['width'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class Address {
  final String? firstName;
  final String? lastName;
  final String? address1;
  final String? address2;
  final int? phone;
  final String? city;
  final int? pincode;
  final String? state;
  final String? country;
  final String? countryCode;
  final String? email;

  Address({
    this.firstName,
    this.lastName,
    this.address1,
    this.address2,
    this.phone,
    this.city,
    this.pincode,
    this.state,
    this.country,
    this.countryCode,
    this.email,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      firstName: json['first_name']?.toString() ?? '', // Handle null values
      lastName: json['last_name']?.toString() ?? '',
      address1: json['address1']?.toString() ?? '',
      address2: json['address2']?.toString() ?? '',
      phone: (json['phone'] as num?)?.toInt(), // Handle numeric conversion
      city: json['city']?.toString() ?? '',
      pincode: (json['pincode'] as num?)?.toInt(), // Handle numeric conversion
      state: json['state']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      countryCode: json['country_code']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}

// Updated OrderStatusMap class with status_id
class OrderStatusMap {
  final String? status;
  final int? statusId; // New field for status_id
  final DateTime? date;

  OrderStatusMap({
    required this.status,
    required this.statusId,
    required this.date,
  });

  factory OrderStatusMap.fromJson(Map<String, dynamic> json) {
    return OrderStatusMap(
      status: json['status']?.toString() ??
          '', // Convert to String or default to empty
      statusId: (json['status_id'] as num?)?.toInt() ??
          0, // Convert to int or default to 0
      date: Order._parseDate(
          json['createdAt']), // Use the Order class date parsing method
    );
  }
}

class FreightCharge {
  final double? delhivery;
  final double? shiprocket;
  final double? standardShipping;

  FreightCharge({
    required this.delhivery,
    required this.shiprocket,
    required this.standardShipping,
  });

  factory FreightCharge.fromJson(Map<String, dynamic> json) {
    return FreightCharge(
      delhivery: (json['Delhivery'] as num?)?.toDouble() ??
          0.0, // Default to 0.0 if null
      shiprocket: (json['Shiprocket'] as num?)?.toDouble() ??
          0.0, // Default to 0.0 if null
      standardShipping: (json['standard_shipping'] as num?)?.toDouble() ??
          0.0, // Default to 0.0 if null
    );
  }
}

class Marketplace {
  final String id;
  final String name;
  final List<String> skuMap; // Assuming sku_map is a list of strings
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;

  Marketplace({
    required this.id,
    required this.name,
    required this.skuMap,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a Marketplace object from JSON
  factory Marketplace.fromJson(Map<String, dynamic> json) {
    return Marketplace(
      id: json['_id'],
      name: json['name'],
      skuMap: List<String>.from(json['sku_map']),
      version: json['__v'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Method to convert Marketplace object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'sku_map': skuMap,
      '__v': version,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Checker {
  final bool approved;
  final DateTime? timestamp;

  Checker({required this.approved, this.timestamp});

  factory Checker.fromJson(Map<String, dynamic> json) {
    return Checker(
      approved: json['approved'] ?? false,
      timestamp: DateTime.tryParse(json['timestamp'] ?? ''),
    );
  }
}

class Racker {
  final bool approved;
  final DateTime? timestamp;

  Racker({required this.approved, this.timestamp});

  factory Racker.fromJson(Map<String, dynamic> json) {
    return Racker(
      approved: json['approved'] ?? false,
      timestamp: DateTime.tryParse(json['timestamp'] ?? ''),
    );
  }
}

class CheckManifest {
  final bool approved;
  final DateTime? timestamp;

  CheckManifest({required this.approved, this.timestamp});

  factory CheckManifest.fromJson(Map<String, dynamic> json) {
    return CheckManifest(
      approved: json['approved'] ?? false,
      timestamp: DateTime.tryParse(json['timestamp'] ?? ''),
    );
  }
}
