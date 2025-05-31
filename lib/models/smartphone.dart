class Smartphone {
  final int id;
  final String model;
  final String brand;
  final double price;
  final int ram;
  final int storage;
  final String image;
  final String website;

  Smartphone({
    required this.id,
    required this.model,
    required this.brand,
    required this.price,
    required this.ram,
    required this.storage,
    required this.image,
    required this.website,
  });

  factory Smartphone.fromJson(Map<String, dynamic> json) {
    return Smartphone(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
      model: json['model'] ?? '',
      brand: json['brand'] ?? '',
      price: json['price'] != null
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0,
      ram: json['ram'] != null ? int.tryParse(json['ram'].toString()) ?? 0 : 0,
      storage:
          json['storage'] != null ? int.tryParse(json['storage'].toString()) ?? 0 : 0,
      image: json['image'] ?? '',
      website: json['website'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'brand': brand,
      'price': price,
      'ram': ram,
      'storage': storage,
      'image': image,
      'website': website,
    };
  }

  @override
  String toString() {
    return 'Smartphone(id: $id, model: $model, brand: $brand, price: $price, ram: $ram, storage: $storage)';
  }
}
