import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba1_mv/product.dart';
import 'package:prueba1_mv/shop.dart';

import 'app_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    List<Product> productos =
        Provider.of<CatalogCartAndCheckout>(context).products;
    productos = productos.where((element) => element.selected == 1).toList();
    bool showBadge = productos.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text("Home"),
        actions: [
          Badge(
            position: const BadgePosition(end: 3, top: 5),
            showBadge: showBadge,
            badgeContent: Text(
              productos.length.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pushNamed("/checkout"),
              icon: const Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      body: const ShopSection(),
    );
  }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     selectedSection = index;
  //   });
  // }
}
