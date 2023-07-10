import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_deliverlyapp_test/common/const/colors.dart';
import 'package:flutter_deliverlyapp_test/common/const/data.dart';
import 'package:flutter_deliverlyapp_test/common/dio/dio.dart';
import 'package:flutter_deliverlyapp_test/common/layout/default_layout.dart';
import 'package:flutter_deliverlyapp_test/common/model/cursor_pagination_model.dart';
import 'package:flutter_deliverlyapp_test/common/utils/pagination_utils.dart';
import 'package:flutter_deliverlyapp_test/product/component/product_card.dart';
import 'package:flutter_deliverlyapp_test/product/model/product_model.dart';
import 'package:flutter_deliverlyapp_test/rating/component/rating_card.dart';
import 'package:flutter_deliverlyapp_test/rating/model/rating_model.dart';
import 'package:flutter_deliverlyapp_test/restaurant/component/restaurant_card.dart';
import 'package:flutter_deliverlyapp_test/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_deliverlyapp_test/restaurant/model/restaurant_model.dart';
import 'package:flutter_deliverlyapp_test/restaurant/provider/restaurant_provider.dart';
import 'package:flutter_deliverlyapp_test/restaurant/provider/restaurant_rating_provider.dart';
import 'package:flutter_deliverlyapp_test/restaurant/repository/restaurant_rating_repository.dart';
import 'package:flutter_deliverlyapp_test/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_deliverlyapp_test/restaurant/view/basket_screen.dart';
import 'package:flutter_deliverlyapp_test/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'restaruantDetail';

  final String id;

  const RestaurantDetailScreen({required this.id, super.key});

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);

    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(
        restaurantRatingProvider(widget.id).notifier,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));
    final basket = ref.watch(basketProvider);

    if (state == null) {
      return DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultLayout(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          context.pushNamed(BasketScreen.routeName);
        },
        backgroundColor: PRIMARY_COLOR,
        child: Badge(
          showBadge: basket.isNotEmpty,
          badgeContent: Text(
            basket.fold<int>(
              0,
                  (previous, next) => previous + next.count,
            ).toString(),
            style: TextStyle(
              color: PRIMARY_COLOR,
            ),
          ),
          badgeStyle: BadgeStyle(
            badgeColor: Colors.white,
          ),
          child: Icon(
            Icons.shopping_basket_outlined
          ),
        ),
      ),
      title: state.name,
      child: CustomScrollView(
        controller: controller,
        slivers: [
          renderTop(
            model: state,
          ),
          if (state is! RestaurantDetailModel) renderLoading(),
          if (state is RestaurantDetailModel) renderLabel(),
          if (state is RestaurantDetailModel)
            renderProducts(
              restaurant: state,
              products: state.products,
            ),
          if (ratingsState is CursorPagination<RatingModel>)
            renderRatings(
              models: ratingsState.data,
            ),
        ],
      ),
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: SkeletonParagraph(
                style: SkeletonParagraphStyle(
                  lines: 5,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverPadding renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  SliverPadding renderProducts({
    required RestaurantModel restaurant,
    required List<RestaurantProductModel> products,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];
            return InkWell(
              onTap: () {
                ref.read(basketProvider.notifier).addToBasket(
                      product: ProductModel(
                        detail: model.detail,
                        id: model.id,
                        imgUrl: model.imgUrl,
                        name: model.name,
                        price: model.price,
                        restaurant: restaurant,
                      ),
                    );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ProductCard.fromRestaurantProductModel(
                  model: model,
                ),
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  SliverPadding renderRatings({
    required List<RatingModel> models,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: RatingCard.fromModel(
              model: models[index],
            ),
          ),
          childCount: models.length,
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }
}
