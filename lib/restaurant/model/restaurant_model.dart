import 'package:flutter_deliverlyapp_test/common/const/data.dart';
import 'package:flutter_deliverlyapp_test/common/model/model_with_id.dart';
import 'package:flutter_deliverlyapp_test/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}
@JsonSerializable()
class RestaurantModel implements IModelWithId{
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel({
    required this.deliveryFee,
    required this.deliveryTime,
    required this.name,
    required this.id,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.tags,
    required this.thumbUrl,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json)
  => _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

}