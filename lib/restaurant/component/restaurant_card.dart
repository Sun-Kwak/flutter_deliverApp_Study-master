import 'package:flutter/material.dart';
import 'package:flutter_deliverlyapp_test/common/const/colors.dart';
import 'package:flutter_deliverlyapp_test/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_deliverlyapp_test/restaurant/model/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  //음식 사진
  final Widget image;

  // 식당 이름
  final String name;

  // 식당 테그
  final List<String> tags;

  // 평점 개수
  final int ratingsCount;

  // 배송시간
  final int deliveryTime;

  // 배송비용
  final int deliveryFee;

  //평균 평점
  final double ratings;

  final bool isDetail;

  final String? herokey;

  final String? detail;

  const RestaurantCard({
    this.herokey,
    this.detail,
    this.isDetail = false,
    required this.name,
    required this.deliveryFee,
    required this.deliveryTime,
    required this.image,
    required this.ratings,
    required this.ratingsCount,
    required this.tags,
    super.key,
  });

  factory RestaurantCard.fromModel({
    required RestaurantModel model,
    bool isDetail = false,
  }){
    return RestaurantCard(
      herokey: model.id,
      deliveryFee: model.deliveryFee,
      deliveryTime: model.deliveryTime,
      image: Image.network(
        model.thumbUrl,
        fit: BoxFit.cover,
      ),
      name: model.name,
      ratings: model.ratings,
      ratingsCount: model.ratingsCount,
      tags: model.tags,
      isDetail: isDetail,
      detail: model is RestaurantDetailModel ? model.detail : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(herokey != null)
        Hero(
          tag: ObjectKey(herokey),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isDetail ? 0 : 12.0),
            child: image,
          ),
        ),
        if(herokey == null)
          ClipRRect(
            borderRadius: BorderRadius.circular(isDetail ? 0 : 12.0),
            child: image,
          ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isDetail ? 16 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                tags.join(' · '),
                style: TextStyle(
                  color: BODY_TEXT_COLOR,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  _IconText(
                    icon: Icons.star,
                    label: ratings.toString(),
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.receipt,
                    label: ratingsCount.toString(),
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.timelapse_outlined,
                    label: '$deliveryTime 분',
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.monetization_on,
                    label: deliveryFee == 0 ? '무료' : deliveryFee.toString(),
                  )
                ],
              ),
              if(detail != null && isDetail)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(detail!),
                ),
            ],
          ),
        ),
      ],
    );
  }

  renderDot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        ' ',
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconText({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: PRIMARY_COLOR,
          size: 14.0,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
