import 'package:app_car_rental/screen/PayPal.dart';
import 'package:app_car_rental/screen/history.dart';
import 'package:app_car_rental/screen/login_page.dart';
import 'package:app_car_rental/screen/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../const/UserProvider.dart';
import '../const/color.dart';
import '../main.dart';

class NavbarCheckout extends StatelessWidget {
  String? totalPrice;
  String? proId;
  String? userId;
  DateTime? receiveDay;
  DateTime? returnDay;
  NavbarCheckout({
    required this.proId,
    required this.userId,
    required this.receiveDay,
    required this.returnDay,
    required this.totalPrice,
  });

  void saveOrder(BuildContext context) async {
    final userId2 = Provider.of<UserProvider>(context, listen: false).userId;
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.ref();

    // Tăng mã hóa đơn tự động
    DataSnapshot snapshot =
        await _databaseReference.child('Order_counter').get();
    int currentCounter = (snapshot.value ?? 0) as int;

    // Tăng giá trị của order_counter
    int newOrderId = currentCounter + 1;

    // Cập nhật giá trị mới của order_counter
    await _databaseReference.child('Order_counter').set(newOrderId);

    // Lưu thông tin đơn hàng với mã hóa đơn mới
    await _databaseReference.child("Orders").child(newOrderId.toString()).set({
      'orderId': newOrderId,
      'proId': proId,
      'uid': userId2,
      'receiveDay': DateFormat('yyyy-MM-dd').format(receiveDay!),
      'returnDay': DateFormat('yyyy-MM-dd').format(returnDay!),
      'orderDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'status': 'Đang thuê'
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: const Text(
              'Thông báo',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            )),
            content: const Text(
              'Bạn đã gửi yêu cầu thuê thành công',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Center(
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                      color: Color(dart_green),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                        child: Text(
                      'OK',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(userId: userId)));
                },
              ),
            ],
          );
        });
    // print('Hóa đơn đã được lưu với mã hóa đơn $newOrderId');
  }

  Future<bool> isPhoneNumberVerified(BuildContext context) async {
    // Lấy userId từ UserProvider
    final userId = Provider.of<UserProvider>(context, listen: false).userId;

    // Kiểm tra nếu userId không null
    if (userId == null) {
      print('User ID is not available');
      return false;
    }

    final DatabaseReference reference = FirebaseDatabase.instance
        .ref()
        .child('Users')
        .child(userId);
    print( 'ma so lan nay la $userId');
    try {
      // Lấy dữ liệu người dùng từ Realtime Database
      DatabaseEvent event = await reference.once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.exists) {
        // Kiểm tra trường phoneNumberVerified trong dữ liệu người dùng
        Map<String, dynamic>? userData = Map<String, dynamic>.from(snapshot.value as Map);
        if (userData['phoneNumberVerified'] == '1') {
          return true;
        } else {
          return false;
        }
      } else {
        print('Không tìm thấy dữ liệu người dùng');
        return false;
      }
    } catch (e) {
      print('Lỗi khi kiểm tra xác minh số điện thoại: $e');
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    DatabaseReference carRefs = FirebaseDatabase.instance.ref().child('Cars');
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 10,
                  backgroundImage: AssetImage(
                    'assets/images/check.png',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: RichText(
                    textAlign: TextAlign.end,
                    text: const TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: 'Tôi đồng ý với ',
                          style: TextStyle(color: Colors.black, fontSize: 17)),
                      TextSpan(
                          text: 'chính sách hủy chuyến của Mioto',
                          style: TextStyle(
                              color: Color(dart_green),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline)),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 400,
            height: 60,
            margin: EdgeInsets.symmetric(horizontal: 16,vertical: 4),
            child: FutureBuilder(
                future: carRefs.child(proId!).once(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<dynamic, dynamic> carData =
                        snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                    return  TextButton(
                      onPressed: () async {
                        bool isVerified = await isPhoneNumberVerified(context);
                        if (isVerified) {
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
                                    "total": totalPrice,
                                    "currency": "USD",
                                    "details": {
                                      "subtotal": totalPrice,
                                      "shipping": '0',
                                      "shipping_discount": 0
                                    }
                                  },
                                  "description": "${carData['name']} "
                                      "\nĐược thuê từ ${DateFormat('yyyy-MM-dd').format(receiveDay!)} đến ${DateFormat('yyyy-MM-dd').format(returnDay!)}",
                                  "payment_options": {
                                    "allowed_payment_method":
                                    "INSTANT_FUNDING_SOURCE"
                                  },
                                  "item_list": {
                                    "items": [
                                      {
                                        "name": carData['name'],
                                        "quantity": "1",
                                        "price": totalPrice,
                                        "currency": "USD"
                                      },
                                    ],
                                  }
                                }
                              ],
                              note: "Contact us for any questions on your order.",
                              onSuccess: (Map params) async {
                                saveOrder(context);
                                await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Center(
                                            child: const Text(
                                          'Thông báo',
                                          style:
                                              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                        )),
                                        content: const Text(
                                          'Bạn đã gửi yêu cầu thuê thành công',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Center(
                                              child: Container(
                                                height: 40,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black45,
                                                      blurRadius: 10,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                  color: Color(dart_green),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  'OK',
                                                  style: TextStyle(
                                                      color: Colors.white, fontWeight: FontWeight.bold),
                                                )),
                                              ),
                                            ),
                                            onPressed: () {
                                              MyApp.of(context).navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => MainPage(userId: userId,)),
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    });
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
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Thông báo'),
                                content: Text(
                                    'Vui lòng xác minh số điện thoại trước khi yêu cầu thuê xe.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Đồng ý'),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => LoginPage(uid: userId,proId: proId!,receiveDay: receiveDay!,returnDay: returnDay!,)));
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Đóng'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(400, 20),
                        backgroundColor: Color(dart_green),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Thanh Toán trực tuyến",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }else {
                    return CircularProgressIndicator(); // Hiển thị loading khi đang tải dữ liệu
                  }
                },
              ),
          ),
        ],
      ),
    );
  }
}
