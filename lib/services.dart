import 'dart:convert';

import 'package:api/api.dart';

class Services {
  final api = Api();

  getProducts() async {
    return {"result": jsonDecode((await api.getProducts()).body)["result"]};
  }

  getCoupon(String code) async {
    return {"result": jsonDecode((await api.getCoupon(code)).body)["result"]};
  }
}
