class ImageModel {
  int? id;
  String? name;

  ImageModel({this.id, this.name});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(id: json['id'], name: json['imageUrl']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
