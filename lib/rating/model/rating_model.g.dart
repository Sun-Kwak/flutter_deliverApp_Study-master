// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingModel _$RatingModelFromJson(Map<String, dynamic> json) => RatingModel(
      id: json['id'] as String,
      content: json['content'] as String,
      rating: json['rating'] as int,
      imgUrls: DataUtils.listPathsToUrl(json['imgUrls'] as List),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RatingModelToJson(RatingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'rating': instance.rating,
      'content': instance.content,
      'imgUrls': instance.imgUrls,
    };
