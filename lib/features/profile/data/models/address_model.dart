class AddressModel {
  final String id;
  final String street;
  final String city;
  final String pincode;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.street,
    required this.city,
    required this.pincode,
    required this.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      pincode: json['pincode'] ?? '',
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'pincode': pincode,
      'isDefault': isDefault,
    };
  }
}
