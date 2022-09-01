library api;

import 'dart:convert';

import 'package:api/data/coupons.dart';
import 'package:api/data/products.dart';
import 'package:http/http.dart' as http;

class Api {
  Future<http.Response> getProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    return http.Response(
      jsonEncode({
        "success": true,
        "message": "",
        "result": productsDb.values.toList(),
      }),
      200,
    );
  }

  Future<http.Response> getCoupon(String code) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final coupon = couponsDb[code.toUpperCase()];
    if (coupon != null) {
      return http.Response(
        jsonEncode({
          "success": true,
          "message": "",
          "result": coupon,
        }),
        200,
      );
    } else {
      return http.Response(
        jsonEncode({
          "success": false,
          "message": "El cupón no existe",
          "result": null,
        }),
        404,
      );
    }
  }
}
