import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_controller.dart';

class Product {
  int? selected;
  // bool? isAGift;
  int? id;
  String? name;
  String? image;
  int? price;
  int? quantity;
  bool? promotion;
  List<int>? match;
  Product(
    this.selected,
    // this.isAGift,
    this.id,
    this.name,
    this.image,
    this.price,
    this.quantity,
    this.promotion,
    this.match,
  );

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
      map['selected'] != null ? map['selected'] as int : null,
      // map['isAGift'] != null ? map['is_a_gift'] as bool : null,
      map['id'] != null ? map['id'] as int : null,
      map['name'] != null ? map['name'] as String : null,
      map['image'] != null ? map['image'] as String : null,
      map['price'] != null ? map['price'] as int : null,
      map['quantityInCart'] != null ? map['quantityInCart'] as int : null,
      map['promotion'] != null ? map['promotion'] as bool : null,
      map['match'] != null ? (map['match'] as List).cast<int>().toList() : null,
    );
  }
}

class ProductCartW extends StatelessWidget {
  const ProductCartW({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            product.name!,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: Color(0xff2d2d2d),
            ),
          ),
        ),
        Text(
          "\$ ${product.price}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class ProductW extends StatelessWidget {
  const ProductW({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    var appController = Provider.of<CatalogCartAndCheckout>(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            Text(
              product.name!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xff2d2d2d),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: AspectRatio(
                aspectRatio: 5 / 3,
                child: Image.asset(
                  "assets/${product.image}.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Si el producto esta seleccionado entonces muestra el contador
            if (product.selected == 1)
              Container(
                decoration: const BoxDecoration(),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (product.quantity == 1) {
                          product.selected = 0;
                          var count = appController.products
                              .where((element) => element.selected == 1);
                          appController.sum = count.length;
                        }
                        if ((product.quantity ?? 0) > 0) {
                          appController.removeProduct(product);
                        }
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    const Spacer(),
                    Text(product.quantity.toString()),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        var count = appController.products
                            .where((element) => element.selected == 1);
                        // EL cliente solo puede agregar 3 tipos productos por compra,
                        if (count.length >= 3) {
                          if (count.any((element) =>
                              element.id == product.id &&
                              element.selected == 1)) {
                            appController.addProduct(product);
                          }
                          return;
                        }
                        appController.addProduct(product);
                      },
                      icon: const Icon(Icons.add),
                    )
                  ],
                ),
              ),
            // De lo contrario muestra un botón para agregar
            if (product.selected == 0)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    var count = appController.products
                        .where((element) => element.selected == 1);
                    if (count.length >= 3) {
                      if (count.any((element) =>
                          element.id == product.id && element.selected == 1)) {
                        appController.addProduct(product);
                      }
                      return;
                    }
                    appController.addProduct(product);
                  },
                  child: const Text("Agregar"),
                ),
              )
          ],
        ),
      ),
    );
  }
}
