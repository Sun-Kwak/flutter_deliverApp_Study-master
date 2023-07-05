import 'package:flutter_deliverlyapp_test/common/model/model_with_id.dart';
import 'package:flutter_deliverlyapp_test/common/utils/data_utils.dart';
import 'package:flutter_deliverlyapp_test/user/model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rating_model.g.dart';

@JsonSerializable()
class RatingModel implements IModelWithId{
  final String id;
  final UserModel user;
  final int rating;
  final String content;
  @JsonKey(
    fromJson: DataUtils.listPathsToUrl,
  )
  final List<String> imgUrls;

  RatingModel({
    required this.id,
    required this.content,
    required this.rating,
    required this.imgUrls,
    required this.user,
});
  factory RatingModel.fromJson(Map<String, dynamic> json)
  => _$RatingModelFromJson(json);
}