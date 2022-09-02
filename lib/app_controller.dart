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

  int calculeCostDelivery(int subTotal) {
    //DEVLIVERY FREE SI SUBTOTAL ES MAYOR QUE 500
    if (subTotal >= 500) {
      costDelivery = 0;
    } else {
      return costDelivery;
    }
    return costDelivery;
  }

  int? calculeSubTotal(List<Product> productsSelected, int discount) {
    int? subTotal = 0;
    List<int> productToSumaTotal = [];

    //RECORRER LA LISTA DE PRODUCTOS SELECCIONADOS
    for (int i = 0; i < productsSelected.length; i++) {
      int sumListProducts;
      int discountValue;
      //ProductosEXAMPLE with  2 3  6
      //SI TIENE UN CUPON INGRESADO
      if (discount > 0) {
        //OBTENGO VALOS DE DESCUENTO SI TENGO UN CUPON INGRESADO
        discountValue = (productsSelected[i].price! * (10 / 100)).toInt();

        sumListProducts = productsSelected[i].quantity! *
            (productsSelected[i].price! - discountValue);
        //CADA VEZ QUE RECORRE LA LISTA DE PRODUCTS AGREGA A UNA NUEVA LISTA DE SUMATOTAL
        productToSumaTotal.add(sumListProducts.toInt());
      }
      //SI NO IENE UN CUPON INGRESADO
      else {
        sumListProducts =
            productsSelected[i].quantity! * productsSelected[i].price!;
        //CADA VEZ QUE RECORRE LA LISTA DE PRODUCTS AGREGA A UNA NUEVA LISTA DE SUMATOTAL
        productToSumaTotal.add(sumListProducts.toInt());
      }

      //CALCULAR SUMA TOTAL CON PRODUCTOS EN LISTA DE SUMATOTAL
      var sumSubTotal = 0;
      for (var sum in productToSumaTotal) {
        sumSubTotal += sum;
      }
      subTotal = sumSubTotal;
    }

    return subTotal;
  }

  int calculateTotal(
      int subTotal, int calculeCostDelivery, int valueDiscountCupon) {
    total = subTotal.toInt() + costDelivery - discountValueCoupon;
    return total;
  }

  int calculeDiscountCupon(
      int subTotal, List<Product> productsSelected, String discount) {
    if (subTotal < 500) {
      discountValueCoupon = 0;
      return discountValueCoupon;
    } else {
      //aplicar descuento recibido a cada producto ( fijo o porcentaje)
      List<int> listIdMatch = [];

      for (int i = 0; i < productsSelected.length; i++) {
        //METODO PARA VERIFICAR SI EXISTE PRODUCTOS EN  PAQUETES
        //AGREGA LIST INT DE MATCHS DE TODOS LOS PRODUCTOS
        if (productsSelected[i].match != null) {
          listIdMatch.addAll(productsSelected[i].match!.toList());
        } else {
          //SI NO ENCUNTRO SIGUE REECORRIENDO
        }
        //VERIFICO SI ALGUNA DE LA LISTA DE MATCHS CONTIENE EL ID DE ALGUN PRODUCTO
        if (listIdMatch.contains(productsSelected[i].id)) {
          //APLICO 10 % DE DESCUENTO
          discountValueCoupon = 10;
        } else {
          discountValueCoupon = 0;
        }
      }
      //TENIENDO EL VALOR DE DESCUENTO VERIFICAR SI ES TIPO FIJO O UN PORCENTAJE
      if (productsSelected.isNotEmpty && discount == "fijo") {
        return discountValueCoupon;
      } else if (productsSelected.isNotEmpty && discount != "fijo") {
        discountValueCoupon =
            (subTotal.toInt() * (int.parse(discount) / 100)).toInt();
        return discountValueCoupon;
      }
    }

    return discountValueCoupon;
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
