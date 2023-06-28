import 'package:flutter_deliverlyapp_test/common/const/data.dart';
import 'package:flutter_deliverlyapp_test/common/utils/data_utils.dart';
import 'package:flutter_deliverlyapp_test/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_detail_model.g.dart';

@JsonSerializable()
class RestaurantDetailModel extends RestaurantModel {
  final String detail;
  final List<RestaurantProductModel> products;

  RestaurantDetailModel({
    required this.detail,
    required this.products,
    required super.deliveryFee,
    required super.deliveryTime,
    required super.name,
    required super.id,
    required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.tags,
    required super.thumbUrl,
  });

  factory RestaurantDetailModel.fromJson(Map<String, dynamic>json)
  => _$RestaurantDetailModelFromJson(json);
}

@JsonSerializable()
class RestaurantProductModel {
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl;
  final String detail;
  final int price;

  RestaurantProductModel({
    required this.detail,
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.price,
  });

factory RestaurantProductModel.fromJson(Map<String, dynamic> json)
=> _$RestaurantProductModelFromJson(json);
}
