class MenuItemModel {
  final int? id;
  final String? name;
  final int? price;
  final int? quantity;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  MenuItemModel copyWith({int? quantity}) {
    return MenuItemModel(
      id: id,
      name: name,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }
}
