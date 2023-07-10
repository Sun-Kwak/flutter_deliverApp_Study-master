import 'package:flutter/material.dart';
import 'package:flutter_deliverlyapp_test/common/component/pagination_list_view.dart';
import 'package:flutter_deliverlyapp_test/product/component/product_card.dart';
import 'package:flutter_deliverlyapp_test/product/model/product_model.dart';
import 'package:flutter_deliverlyapp_test/product/provider/product_provider.dart';
import 'package:flutter_deliverlyapp_test/restaurant/view/restaurant_detail_screen.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
      itemBuilder: <ProductModel>(_, index, model) {
        return GestureDetector(
          onTap: () {
            context.goNamed(
              RestaurantDetailScreen.routeName,
              pathParameters: {
                'rid': model.restaurant.id,
              },
            );
          },
          child: ProductCard.fromProductModel(
            model: model,
          ),
        );
      },
      provider: productProvider,
    );
  }
}
