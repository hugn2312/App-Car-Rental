import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';

class CheckoutPage extends StatefulWidget {
  String? totalPrice;
  CheckoutPage({super.key, required this.totalPrice});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PayPal Checkout",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => PaypalCheckout(
                sandboxMode: true,
                clientId: "AQaK9hz8KA7NtzANsT4x3qDOXqVY7GuaZfbIDzGSr_3V2Hlw58bDD5s6ZAoUsCZ-Yh5cOGRNedck4liX",
                secretKey: "EDxBLMht_YxGa9f4DFvI5ZTuEpT2PNVOdzrVTicAWy9ps-b1m2AECSt28c1uUui0h8rjauwO3v96fZEa",
                returnURL: "success.snippetcoder.com",
                cancelURL: "cancel.snippetcoder.com",
                transactions: [
                  {
                    "amount": {
                      "total": widget.totalPrice,
                      "currency": "USD",
                      "details": {
                        "subtotal": widget.totalPrice,
                        "shipping": '0',
                        "shipping_discount": 0
                      }
                    },
                    "description": "The payment transaction description.",
                    // "payment_options": {
                    //   "allowed_payment_method":
                    //       "INSTANT_FUNDING_SOURCE"
                    // },
                    // "item_list": {
                    //   "items": [
                    //     {
                    //       "name": "Apple",
                    //       "quantity": 4,
                    //       "price": '5',
                    //       "currency": "USD"
                    //     },
                    //     {
                    //       "name": "Pineapple",
                    //       "quantity": 5,
                    //       "price": '10',
                    //       "currency": "USD"
                    //     }
                    //   ],
                    //
                    //   // shipping address is not required though
                    //   //   "shipping_address": {
                    //   //     "recipient_name": "Raman Singh",
                    //   //     "line1": "Delhi",
                    //   //     "line2": "",
                    //   //     "city": "Delhi",
                    //   //     "country_code": "IN",
                    //   //     "postal_code": "11001",
                    //   //     "phone": "+00000000",
                    //   //     "state": "Texas"
                    //   //  },
                    // }
                  }
                ],
                note: "Contact us for any questions on your order.",
                onSuccess: (Map params) async {
                  print("onSuccess: $params");
                },
                onError: (error) {
                  print("onError: $error");
                  Navigator.pop(context);
                },
                onCancel: () {
                  print('cancelled:');
                },
              ),
            ));
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(1),
              ),
            ),
          ),
          child: const Text('Checkout'),
        ),
      ),
    );
  }
}