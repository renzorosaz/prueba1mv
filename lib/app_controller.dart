import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prueba1_mv/product.dart';
import 'package:prueba1_mv/services.dart';

class CatalogCartAndCheckout extends ChangeNotifier {
  List<Product> products = [];
  Coupon? coupon;
  int? sum;
  String? error;

  //to checkout products
  int subTotal = 0;
  int total = 0;
  int discountValueCoupon = 0;
  int costDelivery = 0;

  init() async {
    await fetchProducts();
  }

  fetchProducts() async {
    var products = await Services().getProducts();
    products = products["result"];
    this.products = (products as List).map(
      (e) {
        var product = Product.fromJson(e);
        product.selected = 0;
        return product;
      },
    ).toList();
    notifyListeners();
  }

  addProduct(Product product) {
    var productInList = products.firstWhere(
      (element) => element.id == product.id,
    );
    var count = products.where((element) => element.selected == 1);
    sum = count.length;
    productInList.selected = 1;
    productInList.quantity = (productInList.quantity ?? 0) + 1;

    notifyListeners();
  }

  removeProduct(Product product) {
    product.quantity = product.quantity! - 1;
    var count = products.where((element) => element.selected == 1);
    sum = count.length;
    notifyListeners();
  }

  checkPrices(List<Product> products) {
    for (var i = 0; i < products.length; i++) {
      products[i].selected = 0;
      products[i].quantity = 0;
    }
  }

  int? calculeSubTotal(List<Product> productsSelected, int discount) {
    int? _subTotal = 0;
    List<int> _productsTotalCount = [];

    //RECORRER LA LISTA DE PRODUCTOS  SELECCIONADOS
    for (int i = 0; i < productsSelected.length; i++) {
      int _sumListProducts;
      int _discountValue;

      _sumListProducts =
          productsSelected[i].quantity! * productsSelected[i].price!;
      //CADA VEZ QUE RECORRE LA LISTA DE PRODUCTS AGREGA A UNA NUEVA LISTA DE SUMATOTAL
      _productsTotalCount.add(_sumListProducts.toInt());
      // }
      //CALCULAR SUMA TOTAL CON PRODUCTOS EN LISTA DE SUMATOTAL
      var _sumSubTotal = 0;
      for (var sum in _productsTotalCount) {
        _sumSubTotal += sum;
      }
      subTotal = _sumSubTotal;
    }
    return subTotal;
  }

  getCoupon(String code) async {
    error = null;
    var cupon = await Services().getCoupon(code);
    cupon = cupon["result"];
    if (cupon != null) {
      coupon = Coupon.fromJson(cupon);
      notifyListeners();
    } else {
      error = "El cupón no existe";
      notifyListeners();
    }
    cupon;
  }

  clearCart() {
    for (var i = 0; i < products.length; i++) {
      products[i].selected = 0;
      products[i].quantity = 0;
    }
    notifyListeners();
  }

  pay(BuildContext context) {
    clearCart();
    coupon = null;
    Navigator.of(context).pop();
  }
}

class Coupon {
  Coupon({
    this.id,
    this.code,
    this.description,
    this.type,
    this.payload,
  });

  int? id;
  String? code;
  String? description;
  String? type;
  Payload? payload;

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json["id"],
      code: json["code"],
      description: json["description"],
      type: json["type"],
      payload: Payload.fromJson(json["payload"]),
    );
  }
}

class Payload {
  Payload({
    this.value,
    this.minimum,
  });

  int? value;
  int? minimum;

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        value: json["value"],
        minimum: json["minimum"],
      );
}
