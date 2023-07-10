import 'package:flutter/material.dart';
import 'package:flutter_deliverlyapp_test/common/component/pagination_list_view.dart';
import 'package:flutter_deliverlyapp_test/order/conponent/order_card.dart';
import 'package:flutter_deliverlyapp_test/order/model/order_model.dart';
import 'package:flutter_deliverlyapp_test/order/provider/order_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class OrderScreen extends ConsumerWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginationListView<OrderModel>(
      provider: orderProvider,
      itemBuilder: <OrderModel>(_, index, model) {
        return OrderCard.fromModel(model: model);
      },
    );
  }
}
