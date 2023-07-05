
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_deliverlyapp_test/common/const/data.dart';
import 'package:flutter_deliverlyapp_test/common/dio/dio.dart';
import 'package:flutter_deliverlyapp_test/common/model/cursor_pagination_model.dart';
import 'package:flutter_deliverlyapp_test/common/model/pagination_params.dart';
import 'package:flutter_deliverlyapp_test/common/repository/base_pagination_repository.dart';
import 'package:flutter_deliverlyapp_test/rating/model/rating_model.dart';
import 'package:flutter_deliverlyapp_test/restaurant/model/restaurant_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'restaurant_rating_repository.g.dart';

final restaurantRatingRepositoryProvider =
Provider.family<RestaurantRatingRepository, String>((ref, id) {
  final dio = ref.watch(dioProvider);

  return RestaurantRatingRepository(dio,
      baseUrl: 'http://$ip/restaurant/$id/rating');
});
@RestApi()

//http://ip/restaurant/:rid/rating
abstract class RestaurantRatingRepository implements IBasePaginationRepository<RatingModel>{
  factory RestaurantRatingRepository(Dio dio,{String baseUrl}) =
      _RestaurantRatingRepository;

  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RatingModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams()
  });
}