import 'dart:ui';

import 'package:app_car_rental/bar/nav_test.dart';
import 'package:app_car_rental/screen/checkout.dart';
import 'package:app_car_rental/screen/detail_product.dart';
import 'package:app_car_rental/screen/login.dart';
import 'package:app_car_rental/screen/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../const/color.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final String proId;
  final DateTime? dayStart;
  final DateTime? dayEnd;
  const CustomBottomNavigationBar(
      {required this.proId, required this.dayStart, required this.dayEnd});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late DatabaseReference reference;
  double? pricePerDay;
  double? totalPrice;
  String? TotalPrice;
  String? differenceText;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void checkAuthAndRent() {
    User? user = _auth.currentUser;
    if (user != null && widget.dayStart != null && widget.dayEnd != null) {
      // Người dùng đã đăng nhập, thực hiện hành động Thuê
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Checkout(
              proId: widget.proId,
              receiveDay: widget.dayStart,
              returnDay: widget.dayEnd),
        ),
      );
    } else if (user != null &&
        widget.dayStart == null &&
        widget.dayEnd == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: const Text(
              'Cảnh báo !',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            )),
            content: const Text(
              'Vui lòng chọn \n ngày nhận và trả',
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
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } else {
      // Người dùng chưa đăng nhập, điều hướng đến trang đăng nhập
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text('Yêu cầu đăng nhập')),
            content: Text(
              'Bạn cần đăng nhập để \nthực hiện chức năng này.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Đồng ý',
                  style: TextStyle(
                    color: Color(dart_green)
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng dialog
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Loginpage(fromPage: '/detail', proId: widget.proId,),
                    ),
                  );
                },
              ),
              TextButton(
                child: Text('Hủy',
                  style: TextStyle(
                      color: Colors.red
                  ),),
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    reference =
        FirebaseDatabase.instance.ref().child('Cars').child(widget.proId);
    _calculateTotalPrice();
  }

  @override
  void didUpdateWidget(covariant CustomBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dayStart != widget.dayStart ||
        oldWidget.dayEnd != widget.dayEnd) {
      _calculateTotalPrice();
    }
  }

  void _calculateTotalPrice() async {
    // Lấy dữ liệu từ Firebase
    try {
      DataSnapshot snapshot =
          await reference.once().then((event) => event.snapshot);

      if (snapshot.value != null) {
        Map<String, dynamic> productData =
            Map<String, dynamic>.from(snapshot.value as Map);

        // Sử dụng tryParse để tránh lỗi khi chuyển đổi
        pricePerDay = double.parse(productData['price']);

        // Kiểm tra ngày bắt đầu và kết thúc
        if (widget.dayStart != null && widget.dayEnd != null) {
          final int difference =
              (widget.dayEnd!.difference(widget.dayStart!).inDays) + 1;
          if (difference == 1) {
            totalPrice = pricePerDay;
            differenceText = '1';
          } else {
            totalPrice = pricePerDay! * (difference);
            differenceText = (difference).toString();
          }
        } else {
          totalPrice = pricePerDay;
          differenceText = '1';
        }

        // Cập nhật giá trị totalPriceText để hiển thị trong TextButton
        setState(() {
          TotalPrice =
              totalPrice != null ? totalPrice!.toStringAsFixed(0) : 'N/A';
        });
      }
    } catch (e) {
      print('Error calculating total price: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: reference.once(),
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.snapshot.value != null) {
              Map<String, dynamic> productData = Map<String, dynamic>.from(
                  snapshot.data!.snapshot.value as Map);
              return Container(
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: Offset(0, -2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16.0, top: 8.0),
                          child: RichText(
                            textAlign: TextAlign.end,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: productData['price'] + r'$',
                                  style: TextStyle(
                                      color: Color(dart_green),
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: '/ngày',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18)),
                            ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              TextButton(
                                  onPressed: () => showPriceDialog(
                                      context,
                                      productData['price'],
                                      TotalPrice!,
                                      differenceText!),
                                  child: Text(
                                    'Giá tổng : ' + TotalPrice! + r'$',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        decoration: TextDecoration.underline),
                                  )),
                              Icon(
                                Icons.price_change,
                                color: Color(dart_green),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: ElevatedButton(
                        onPressed: checkAuthAndRent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(dart_green),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Chọn thuê",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('No data available'));
            }
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class PriceTable extends StatelessWidget {
  final String pricePerday;
  final String totalPrice;
  final String rangeDay;
  PriceTable(
      {required this.totalPrice,
      required this.pricePerday,
      required this.rangeDay});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.height) / 2 - 24,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Bảng tính giá',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        'Đơn giá thuê',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Text(
                      (double.parse(pricePerday))
                              .toStringAsFixed(0)
                              .toString() +
                          r' $/Ngày',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey),
                    ),
                  )),
                ],
              ),
              const Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        'Bảo hiểm thuê xe',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Text(
                      r'51$/ngày',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey),
                    ),
                  )),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 4),
                child: const Divider(
                  color: Colors.black,
                  height: 20,
                  thickness: 1,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        'Tổng cộng',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Text(
                      (double.parse(pricePerday))
                              .toStringAsFixed(0)
                              .toString() +
                          r' $' +
                          'x $rangeDay ngày',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey),
                    ),
                  )),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 6),
                child: const Divider(
                  color: Colors.black,
                  height: 20,
                  thickness: 1,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Khuyến mãi',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size(20, 20),
                ),
                onPressed: () {},
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Image(
                      image: AssetImage('assets/images/coupon.png'),
                      width: 30,
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Mã khuyến mãi',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                'BANMOI',
                                style: TextStyle(
                                    fontSize: 18, color: Color(dart_green)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 230),
                      child: Icon(
                        Icons.navigate_next_outlined,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Thành tiền',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Text(
                        (double.parse(totalPrice) )
                                .toStringAsFixed(0)
                                .toString() +
                            r' $',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 30),
                    backgroundColor: Color(dart_green),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Chọn thuê",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void showPriceDialog(BuildContext context, String _pricePerday,
    String _totalPrice, String _rangeDay) {
  showDialog(
    context: context,
    builder: (context) => PriceTable(
      pricePerday: _pricePerday,
      totalPrice: _totalPrice,
      rangeDay: _rangeDay,
    ),
  );
}
