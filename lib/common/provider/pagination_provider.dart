import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_deliverlyapp_test/common/model/cursor_pagination_model.dart';
import 'package:flutter_deliverlyapp_test/common/model/model_with_id.dart';
import 'package:flutter_deliverlyapp_test/common/model/pagination_params.dart';
import 'package:flutter_deliverlyapp_test/common/repository/base_pagination_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _Paginationinfo{
  final int fetchCount;
  final bool fetchMore;
  final bool forceRefetch;

  _Paginationinfo({
    this.fetchCount = 20,
    this.fetchMore = false,
    this.forceRefetch = false,
});
}

class PaginationProvider<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;
  final paginationThrottle = Throttle(
    Duration(seconds: 3),
    initialValue: _Paginationinfo(),
    checkEquality: false,
  );

  PaginationProvider({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();

    paginationThrottle.values.listen(
        (state){
          _throttledPagination(state);
        },
    );
  }

  Future<void> paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    paginationThrottle.setValue(_Paginationinfo(
      fetchCount: fetchCount,
      fetchMore: fetchMore,
      forceRefetch: forceRefetch,
    ));
  }
  _throttledPagination(_Paginationinfo info) async{
    final fetchCount = info.fetchCount;
    final fetchMore = info.fetchMore;
    final forceRefetch = info.forceRefetch;
    try {
      //1) hasMore = False (기존 상태에서 이미 다음 데이터가 없다는 값을 가지고 있을 때)
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;
        if (!pState.meta.hasMore) {
          return;
        }
      }
      //2) 로딩중 - fetchMore : true
      // fetchMore가 아닐 때 - 새로고침의 의도가 있을 수 있다.
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );
      //3 데이터를 추가로 더 가지고 오는 상황
      if (fetchMore) {
        //T 타입은 IModelWithId를 extends하고 있고 IModelWithId는 id를 가져야하기 때문에
        //data에 id 필드가 있는 것을 알 수 있다.
        final pState = state as CursorPagination<T>;

        state = CursorPaginationFetchingMore<T>(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      }
      // 데이터를 처음부터 가져오는 상황
      else {
        //만약 데이터가 있는 상황이라면 기존 데이터를 보존한채로 요청
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;

          state = CursorPaginationRefetching<T>(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;

        //기존 데이터에 새로운 데이터 추가
        state = resp.copyWith(data: [
          ...pState.data,
          ...resp.data,
        ]);
      } else {
        state = resp;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}
