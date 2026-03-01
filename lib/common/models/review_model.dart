import 'package:flutter/rendering.dart';
import 'package:mobile/common/models/image_model.dart';
import 'package:mobile/common/models/user_model.dart';

class ReviewModel {
  final String? title;
  final String? description;
  final double? rating;
  final User? user;
  final int? id;
  final List<ImageModel> images;
  final String? createdAt;

  ReviewModel({
    this.title,
    this.description,
    this.rating,
    this.user,
    this.id,
    this.images = const [],
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    try {
      return ReviewModel(
        title: json['title'],
        description: json['description'],
        rating: double.parse(json['rating'].toString()),
        user: User.fromJson(json['user']),
        images: json['images'] != null
            ? (json['images'] as List)
                  .map((e) => ImageModel.fromJson(e))
                  .toList()
            : [],
        id: json['id'],
        createdAt: json['createdAt'],
      );
    } catch (e) {
      debugPrint(
        "Error while converting review model in ReviewModel.FromJson $e",
      );
    }
    return ReviewModel();
  }
}
