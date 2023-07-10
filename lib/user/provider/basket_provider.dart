import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_deliverlyapp_test/product/model/product_model.dart';
import 'package:flutter_deliverlyapp_test/user/model/basket_item_model.dart';
import 'package:flutter_deliverlyapp_test/user/model/patch_basket_body.dart';
import 'package:flutter_deliverlyapp_test/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>((ref) {
  final repository = ref.watch(userMeRepositoryProvider);
  return BasketProvider(
    repository: repository,
  );
});

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;
  final updateBasketDebounce = Debouncer(
    Duration(seconds: 1),
    initialValue: null,
    checkEquality: false,
  );

  BasketProvider({
    required this.repository,
  }) : super([]) {
    updateBasketDebounce.values.listen(
      (event) {
        patchBasket();
      },
    );
  }

  Future<void> patchBasket() async {
    await repository.patchBasket(
      body: PatchBasketBody(
        basket: state
            .map(
              (e) => PatchBasketBodyBasket(
                count: e.count,
                productId: e.product.id,
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    // 1) 장바구니에 해당하는 상품이 없다면
    // 장바구니에 상품을 추가
    // 2) 이미 들어 있으면
    // 장바구니에 있는 값에 +
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exists) {
      state = state
          .map(
            (e) => e.product.id == product.id
                ? e.copyWith(
                    count: e.count + 1,
                  )
                : e,
          )
          .toList();
    } else {
      state = [
        ...state,
        BasketItemModel(
          count: 1,
          product: product,
        ),
      ];
    }
    updateBasketDebounce.setValue(null);
  }

  Future<void> removeFromBasket({
    bool isDelete = false,
    required ProductModel product,
  }) async {
    //1) 장바구니에 상품이 존재할 떄
    //1-1) 상품의 카운트가 1보다 크면 -1
    //1-2) 상품의 카운트가 1이면 삭제
    //2) 상품이 존재하지 않으면
    // 즉시 함수를 반환
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;
    if (!exists) {
      return;
    }

    final existingProduct = state.firstWhere((e) => e.product.id == product.id);

    if (existingProduct.count == 1 || isDelete) {
      state = state
          .where(
            (e) => e.product.id != product.id,
          )
          .toList();
    } else {
      state = state
          .map(
            (e) => e.product.id == product.id
                ? e.copyWith(
                    count: e.count - 1,
                  )
                : e,
          )
          .toList();
    }
    // 케쉬를 먼저 업데이트 후
    // Optimistic Response(긍정적 응답)
    // 응답이 성공할거라고 가정하고 상태를 먼저 업데이트
    updateBasketDebounce.setValue(null);
  }
}
