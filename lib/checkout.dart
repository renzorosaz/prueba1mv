import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba1_mv/product.dart';
import 'package:prueba1_mv/widgets/checkout_line.dart';

import 'app_controller.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final ScrollController _sc = ScrollController();
  final TextEditingController _tc = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(milliseconds: 200));
      _sc.animateTo(_sc.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    });
    super.initState();
  }

  //creando variables
  int subTotal = 0;
  int costDelivery = 0;
  int costDiscount = 0;

  int total = 0;
  int valueTotalDiscount = 0;

  List<Product> products = [];
  String valueCoupon = "";

  final inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: Colors.grey.shade400,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pago")),
      body: Consumer<CatalogCartAndCheckout>(
        builder: (context, cart, child) {
          //Verificar los productos seleccionados
          products = cart.products.where((map) => map.selected == 1).toList();
          int? subTotal = cart.calculeSubTotal(products, costDiscount);
          int costDelivery = cart.calculeCostDelivery(subTotal!);

          return SingleChildScrollView(
            controller: _sc,
            dragStartBehavior: DragStartBehavior.down,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Wrap(
                  runSpacing: 20,
                  children: cart.products
                      .where((element) => element.selected == 1)
                      .map((e) {
                    return CheckoutProductLine(product: e);
                  }).toList(),
                ),
                const Divider(height: 50),
                if (costDiscount == 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: TextField(
                                controller: _tc,
                                decoration: InputDecoration(
                                  hintText: "Cup??n",
                                  isDense: true,
                                  enabledBorder: inputBorder,
                                  border: inputBorder,
                                  errorBorder: inputBorder,
                                  focusedBorder: inputBorder,
                                  disabledBorder: inputBorder,
                                  focusedErrorBorder: inputBorder,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                valueCoupon = _tc.text;
                                int? discountTemp = cart.calculeDiscountCupon(
                                    subTotal!, products, valueCoupon);

                                int? subTotalTemp = cart.calculeSubTotal(
                                    products, discountTemp);

                                int? totalTemp = cart.calculateTotal(
                                    subTotalTemp!, costDelivery, discountTemp);

                                setState(() {
                                  costDiscount = discountTemp;
                                  valueTotalDiscount =
                                      totalTemp - subTotalTemp.toInt();
                                  subTotal = subTotalTemp;
                                  total = totalTemp;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Text("Aplicar"),
                            ),
                          ),
                        ],
                      ),
                      if (cart.error != null)
                        Text(
                          cart.error!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        )
                    ],
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ingrese 'fijo' para aplicar 10% ",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        )),
                    Text(
                        "Ingrese un 'n??mero de 2 cifras' para aplicar el descuento",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        )),
                  ],
                ),
                if (costDiscount > 0)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          cart.coupon != null
                              ? "Cup??n ${cart.coupon!.code} aplicado"
                              : "Cup??n de $valueCoupon% aplicado",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          cart.coupon = null;
                          costDiscount = 0;
                          _tc.text = "";
                          cart.coupon = null;
                          // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                          cart.notifyListeners();
                        },
                        icon: const Icon(Icons.delete),
                        color: Colors.grey,
                      )
                    ],
                  ),
                const Divider(height: 50),
                if (products.isNotEmpty)
                  Wrap(
                    runSpacing: 15,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                              child: Text(
                            "Subtotal",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "\$$subTotal",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              costDiscount > 0
                                  ? const Text(
                                      "Descuento aplicado por compra de produtos en paquete",
                                      style: TextStyle(
                                          fontSize: 8, color: Colors.red))
                                  : Container()
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Text(
                            "Descuento por cup??n",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                          // ignore: unnecessary_null_comparison
                          valueCoupon == null
                              ? Text(
                                  costDiscount <= 0
                                      ? "\$ 0"
                                      : "\$$costDiscount",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : Text(
                                  "\$ $valueTotalDiscount ($valueCoupon%) ",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Text(
                            "Costo de env??o",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                          Text(
                            costDelivery == 0.0 ? "Gratis" : "\$$costDelivery",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                const Divider(height: 50),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      "\$ $total",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 50),
                SizedBox(
                  height: 50,
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      cart.pay(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      "Pagar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
