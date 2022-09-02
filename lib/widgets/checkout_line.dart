import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import '../product.dart';

class CheckoutProductLine extends StatelessWidget {
  const CheckoutProductLine({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Badge(
          position: const BadgePosition(end: -10, top: -10),
          showBadge: true,
          badgeColor: Colors.grey.shade700,
          padding: const EdgeInsets.all(8),
          badgeContent: Text(
            product.quantity.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/${product.image!}.jpeg",
              fit: BoxFit.cover,
              width: 60,
              height: 60,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              product.name!,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 60,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "\$ ${product.price! * product.quantity!}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
