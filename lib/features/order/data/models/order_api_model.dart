class OrderApiModel {
  final String? id; // backend _id
  final List<OrderItemApiModel> items;
  final double totalAmount;
  final String fullName;
  final String phone;
  final String address;
  final String? note;
  final DateTime createdAt;

  OrderApiModel({
    this.id,
    required this.items,
    required this.totalAmount,
    required this.fullName,
    required this.phone,
    required this.address,
    this.note,
    required this.createdAt,
  });

  factory OrderApiModel.fromJson(Map<String, dynamic> json) {
    return OrderApiModel(
      id: json['_id']?.toString(),
      items: (json['items'] as List)
          .map((e) => OrderItemApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      fullName: (json['fullName'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      note: json['note']?.toString(),
      createdAt: DateTime.parse(json['createdAt'].toString()),
    );
  }

  /// ✅ App -> Backend payload (matches your Node controller)
  Map<String, dynamic> toJson() {
    return {
      "items": items.map((e) => e.toJson()).toList(),
      "fullName": fullName,
      "phone": phone,
      "address": address,
      "note": note,
    };
  }
}

class OrderItemApiModel {
  final String pizzaId;
  final String name;
  final double price;
  final String image;
  final int quantity;

  OrderItemApiModel({
    required this.pizzaId,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
  });

  factory OrderItemApiModel.fromJson(Map<String, dynamic> json) {
    return OrderItemApiModel(
      pizzaId: json['pizzaId']?.toString() ?? '',
      name: (json['name'] ?? '').toString(),
      price: (json['price'] as num).toDouble(),
      image: (json['image'] ?? '').toString(),
      quantity: (json['quantity'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pizzaId": pizzaId,
      "name": name,
      "price": price,
      "image": image,
      "quantity": quantity,
    };
  }
}