import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba1_mv/product.dart';

import 'app_controller.dart';

class ShopSection extends StatefulWidget {
  const ShopSection({Key? key}) : super(key: key);

  @override
  State<ShopSection> createState() => _ShopSectionState();
}

class _ShopSectionState extends State<ShopSection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CatalogCartAndCheckout>(
      builder: (context, catalog, child) {
        return ListView(
          padding: const EdgeInsets.all(20),
          children: catalog.products.map((e) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: ProductW(product: e),
            );
          }).toList(),
        );
      },
    );
  }
}
