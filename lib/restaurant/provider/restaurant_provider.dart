import 'package:flutter_deliverlyapp_test/common/model/cursor_pagination_model.dart';
import 'package:flutter_deliverlyapp_test/common/model/pagination_params.dart';
import 'package:flutter_deliverlyapp_test/common/provider/pagination_provider.dart';
import 'package:flutter_deliverlyapp_test/restaurant/model/restaurant_model.dart';
import 'package:flutter_deliverlyapp_test/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final restaurantDetailProvider = Provider.family<RestaurantModel?, String>((ref, id){
          final state = ref.watch(restaurantProvider);

          if(state is! CursorPagination){
            return null;
          }
          return state.data.firstWhereOrNull((element) => element.id == id);
        }
);

final restaurantProvider =

    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);
    final notifier = RestaurantStateNotifier(repository: repository);

    return notifier;
  },
);

class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository>{
  RestaurantStateNotifier({
    required super.repository,
  });

  void getDetail({
    required String id,
}) async {
    // 만약 데이터가 없는 상태라면 (CursorPagination!)
    // 데이터 가지고 오는 시도
    if(state is! CursorPagination){
      await this.paginate();
    }
    // state가 CursorPagination! 그냥 리턴
    if(state is! CursorPagination){
      return;
    }
    //pState는 RestaurantModel
    final pState = state as CursorPagination;
    //resp는 RestaurantDetailModel
    final resp = await repository.getRestaurantDetail(id: id);
    
    if(pState.data.where((e) => e.id == id).isEmpty){
      state = pState.copyWith(
        data: <RestaurantModel> [
        ...pState.data,
        resp,
        ]
      );
    }else{
      //id가 동일하면 (선택 된 id) RestaurantDetailModel로 변경하면서 새로 데이터 가지고 오기
      state = pState.copyWith(
          data: pState.data
              .map<RestaurantModel>(
                  (e) => e.id == id ? resp : e
          )
              .toList()
      );
    }
  }
}
