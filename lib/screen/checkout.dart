import 'package:app_car_rental/bar/navbar_checkout.dart';
import 'package:app_car_rental/const/color.dart';
import 'package:app_car_rental/const/image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:intl/intl.dart';

class Checkout extends StatefulWidget {
  String proId;
  DateTime? receiveDay;
  DateTime? returnDay;
  Checkout(
      {required this.proId, required this.receiveDay, required this.returnDay});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  late DatabaseReference reference;
  double? pricePerDay;
  double? totalPrice;
  String? TotalPrice;
  String? differenceText;
  String? uid;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    reference = FirebaseDatabase.instance.ref().child('Cars').child(widget.proId);
    uid = auth.currentUser!.uid;
    _calculateTotalPrice();
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
        if (widget.receiveDay != null && widget.returnDay != null) {
          final int difference =
              (widget.returnDay!.difference(widget.receiveDay!).inDays) + 1;
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(grey),
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 45),
              child: Text(
                'Xác nhận đặt xe',
                style: TextStyle(fontSize: 26),
              ),
            ),
            leading: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:
                Icon(FontAwesomeIcons.angleLeft)
            )
        ),
        //Thong tin san pham
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: reference.once(),
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.snapshot.value != null) {
                    Map<String, dynamic> productData =
                        Map<String, dynamic>.from(
                            snapshot.data!.snapshot.value as Map);
                    final ref =
                        storage.ref().child('Car/' + productData['img']);
                    return FutureBuilder(
                      future: ref.getDownloadURL(),
                      builder: (context, AsyncSnapshot<String> urlSnapshot) {
                        if (urlSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (urlSnapshot.hasError) {
                          return Center(
                              child: Text('Error: ${urlSnapshot.error}'));
                        } else if (urlSnapshot.hasData) {
                          String imgUrl = urlSnapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(8),
                                      width: double.infinity,
                                      height: 430,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 10,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                        border: Border.all(
                                            color: Color(dart_green), width: 2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 8, 0),
                                            child: Container(
                                              height: 250,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                image: DecorationImage(
                                                  image: NetworkImage(imgUrl),
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: const Divider(
                                              color: Colors.grey,
                                              height: 20,
                                              thickness: 2,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 8.0, left: 16.0),
                                                child: Text(
                                                  productData['name'],
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                  left: 16.0,
                                                ),
                                                child: Text(
                                                  'Mã số xe: KH4YJIN',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16.0, top: 12),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.yellow,
                                                    ),
                                                    Text(
                                                      '5.0',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Icon(
                                                      Icons.car_rental_rounded,
                                                      color: Color(dart_green),
                                                    ),
                                                    Text(
                                                      '5 chuyến',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 16.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.green,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Bảo hiểm thuê xe VNI',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 16, right: 16, top: 4),
                                      child: const Divider(
                                        color: Colors.grey,
                                        height: 20,
                                        thickness: 1,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 16.0),
                                      child: Text(
                                        'Thông tin thuê xe',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Container(
                                            child: Icon(
                                                Icons.calendar_month_outlined),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 160,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Nhận xe',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Text(
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(
                                                            widget.receiveDay!)
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Container(
                                            child: Icon(
                                                Icons.calendar_month_outlined),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Trả xe',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              DateFormat('yyyy-MM-dd')
                                                  .format(widget.returnDay!)
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0),
                                            child: Container(
                                              child: Icon(
                                                  Icons.location_on_outlined),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Nhận xe tại địa chỉ của xe',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                'Quận Hoàn Kiếm , Hà Nội',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding:
                                    const EdgeInsets.only(left: 16.0, top: 16),
                                child: Text("Chủ xe",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                height: 180,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 16.0, top: 16),
                                          child: CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'assets/images/user_avatar.png'),
                                            radius: 35,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Thanh Hung',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                  ),
                                                  Text(
                                                    '5.0',
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0, right: 8),
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.black,
                                                      radius: 4,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.car_rental_rounded,
                                                    color: Color(dart_green),
                                                  ),
                                                  Text(
                                                    '5 chuyến',
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 16, right: 16, top: 4),
                                      child: const Divider(
                                        color: Colors.grey,
                                        height: 20,
                                        thickness: 1,
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: Text(text))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 16, top: 16),
                                height: 180,
                                width: double.infinity,
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 16.0, top: 16.0),
                                      child: Text(
                                        'Lời nhắn cho chủ xe',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 16, right: 16, top: 16),
                                      height: 100,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.grey, width: 1)),
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText:
                                                'Nhập nội dung lời nhắn cho chủ xe',
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding:
                                    const EdgeInsets.only(left: 16.0, top: 8),
                                child: Text("Bảng tính giá",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                            NumberFormat.decimalPattern()
                                                    .format(
                                                        pricePerDay!) +
                                                r'$/Ngày',
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
                                            r'510$/ngày',
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
                                      padding: EdgeInsets.only(
                                          left: 16, right: 16, top: 4),
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
                                            NumberFormat.decimalPattern()
                                                    .format(
                                                        pricePerDay!) +
                                                r'$' +
                                                'x $differenceText Ngày',
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
                                      padding: EdgeInsets.only(
                                          left: 16, right: 16, top: 6),
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
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        minimumSize: Size(20, 20),
                                      ),
                                      onPressed: () {},
                                      child: const Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Image(
                                            image: AssetImage(
                                                'assets/images/coupon.png'),
                                            width: 30,
                                            height: 30,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8.0),
                                                child: Text(
                                                  'Mã khuyến mãi',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0),
                                                    child: Text(
                                                      'BANMOI',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Color(
                                                              dart_green)),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(left: 160),
                                            child: Icon(
                                              Icons.navigate_next_outlined,
                                              color: Colors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Expanded(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 8.0),
                                              child: Text(
                                                "Thành tiền",
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 16.0),
                                              child: Text(
                                                NumberFormat.decimalPattern()
                                                        .format(totalPrice!) +
                                                    r' $',
                                                textAlign: TextAlign.end,
                                                style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Center(child: Text('No image URL available'));
                        }
                      },
                    );
                  } else {
                    return Center(child: Text('No data available'));
                  }
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
        bottomNavigationBar: NavbarCheckout(
          proId: widget.proId,
          receiveDay: widget.receiveDay,
          returnDay: widget.returnDay,
          userId: uid,
          totalPrice: totalPrice.toString(),
        ),
      ),
    );
  }
}
