import 'package:app_car_rental/const/color.dart';
import 'package:app_car_rental/screen/checkout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';

import '../bar/nav_bar_detail.dart';

class DetailProduct extends StatefulWidget {
  final String proId;
  const DetailProduct({required this.proId});

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  late GoogleMapController mapController;
  final FirebaseStorage storage = FirebaseStorage.instance;
  String _selectedOption2 = '';
  String _selectedOption1 = '';
  List<DateTimeRange> _rentedDateRanges = [];
  DateTime? dayStart;
  DateTime? dayEnd;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  Future<void> _loadRentedDates() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('Orders');
    DatabaseEvent snapshot = await ref.once();
    Map<String, dynamic>? data = snapshot.snapshot.value as Map<String, dynamic>?;

    if (data != null) {
      List<DateTimeRange> rentedDates = [];
      data.forEach((key, value) {
        DateTime start = DateTime.parse(value['receiveDay']);
        DateTime end = DateTime.parse(value['returnDay']);
        rentedDates.add(DateTimeRange(start: start, end: end));
      });
      setState(() {
        _rentedDateRanges = rentedDates;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child('Cars').child(widget.proId);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(grey),
      body: FutureBuilder(
        future: reference.once(),
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.snapshot.value != null) {
              Map<String, dynamic> productData = Map<String, dynamic>.from(
                  snapshot.data!.snapshot.value as Map);
              final ref = storage.ref().child('Car/' + productData['img']);
              // Sử dụng FutureBuilder để tải URL hình ảnh không đồng bộ
              return FutureBuilder(
                future: ref.getDownloadURL(),
                builder: (context, AsyncSnapshot<String> urlSnapshot) {
                  if (urlSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (urlSnapshot.hasError) {
                    return Center(child: Text('Error: ${urlSnapshot.error}'));
                  } else if (urlSnapshot.hasData) {
                    String imgUrl = urlSnapshot.data!;

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 300,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image: NetworkImage(imgUrl),
                                  ),
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 16, left: 16),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        backgroundColor:
                                            Colors.black.withOpacity(0.4),
                                        child: const Icon(Icons.close,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 215),
                                      height: 50,
                                      width: 50,
                                      child: FloatingActionButton(
                                        onPressed: () {},
                                        backgroundColor:
                                            Colors.black.withOpacity(0.4),
                                        child: const Icon(Icons.share,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 16),
                                      height: 50,
                                      width: 50,
                                      child: FloatingActionButton(
                                        onPressed: () {},
                                        backgroundColor:
                                            Colors.black.withOpacity(0.4),
                                        child: Icon(Icons.favorite_border,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 16.0),
                            child: Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        productData['name'],
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const Icon(Icons.shield_moon,
                                          color: Colors.green, size: 30),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.yellow, size: 25),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          '5.0',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Icon(Icons.circle, size: 8),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Icon(Icons.shopping_bag,
                                            color: Colors.green),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          '56 chuyến',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 16, right: 16),
                            width: double.infinity,
                            height: 410,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Color(0xFFEAEAEA),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 16.0),
                                  child: Container(
                                    child: Text(
                                      'Thời gian thuê xe',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final result = await showDateRangePicker(
                                      context: context,
                                      helpText: 'Chọn khoảng ngày',
                                      cancelText: 'Hủy',
                                      confirmText: 'Xác nhận',
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2100)
                                          .add(const Duration(days: 365)),
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Theme(
                                          data: ThemeData.light().copyWith(
                                            // primaryColor: Color(dart_green), // Màu chủ đạo
                                            // hintColor: Color(light_green), // Màu phụ
                                            dialogBackgroundColor: Colors.blue,
                                            colorScheme: ColorScheme.light(
                                                primary: Color(dart_green)),
                                            cardColor: Colors.blue,
                                            buttonTheme: ButtonThemeData(
                                                textTheme:
                                                    ButtonTextTheme.primary),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (result != null) {
                                      setState(() {
                                        dayStart = result.start;
                                        dayEnd = result.end;
                                      });
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.black),
                                  child: Container(
                                    margin: EdgeInsets.only(),
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey, width: 1),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 190,
                                          padding: EdgeInsets.only(
                                              left: 16.0, top: 16.0),
                                          child: Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Nhận xe',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 18,
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  '${dayStart != null ? DateFormat('yyyy-MM-dd').format(dayStart!) : ''}',
                                                  style: const TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 16.0, top: 16.0),
                                          child: Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Trả xe',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 18,
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  '${dayEnd != null ? DateFormat('yyyy-MM-dd').format(dayEnd!) : ''}',
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 16.0),
                                  child: Container(
                                    child: Text(
                                      'Địa điểm giao nhận xe',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 16),
                                  height: 204,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 16, right: 16),
                                        height: 94,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey, width: 1),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ListTile(
                                                    contentPadding:
                                                        const EdgeInsets.all(0),
                                                    title: const Text(
                                                        'Tôi tự đến lấy xe',
                                                        style: TextStyle(
                                                            fontSize: 18)),
                                                    leading:
                                                        Transform.translate(
                                                      offset:
                                                          const Offset(0, 0),
                                                      child: Radio(
                                                        activeColor:
                                                            Color(dart_green),
                                                        value: 1,
                                                        groupValue:
                                                            _selectedOption1,
                                                        onChanged: (value) {},
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16),
                                                  child: const Text(
                                                    'Miễn phí',
                                                    style: TextStyle(
                                                      color: Color(dart_green),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.only(
                                                  left: 64, bottom: 16),
                                              child: Text(
                                                productData['address'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 16, right: 16, top: 16),
                                        height: 94,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey, width: 1),
                                        ),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                              title: const Text(
                                                  'Giao xe tận nơi',
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              leading: Transform.translate(
                                                offset: const Offset(0, 0),
                                                child: Radio(
                                                  activeColor:
                                                      Color(dart_green),
                                                  value: 2,
                                                  groupValue: _selectedOption2,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.only(
                                                  left: 64, bottom: 16),
                                              child: const Text(
                                                  'Nhập địa chỉ cụ thể'),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 16, top: 16),
                            width: double.infinity,
                            child: const Text(
                              'Bảo hiểm thuê xe MIC',
                              style: TextStyle(
                                color: Color(dart_green),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(left: 16, top: 4, right: 16),
                            width: double.infinity,
                            child: const Text(
                              'Chuyến đi có mua bảo hiểm. Khách thuê bồi thường tối đa 2.000.000 VNĐ trong trường hợp có sự cố ngoài ý muốn',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(left: 16, right: 16, top: 4),
                            child: const Divider(
                              color: Colors.grey,
                              height: 20,
                              thickness: 1,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 16, top: 4),
                            width: double.infinity,
                            child: const Text(
                              'Đặc điểm',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 8, top: 16),
                                  child: Column(
                                    children: [
                                      Icon(Icons.chair_rounded,
                                          color: Color(dart_green), size: 40),
                                      Text('Số ghế',
                                          style: TextStyle(color: Colors.grey)),
                                      Text(productData['soghe'] + ' chỗ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 8, top: 16),
                                  child: Column(
                                    children: [
                                      Icon(Icons.local_gas_station,
                                          color: Color(dart_green), size: 40),
                                      Text('Nhiên liệu',
                                          style: TextStyle(color: Colors.grey)),
                                      Text(productData['nhienlieu'],
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 8, top: 16),
                                  child: Column(
                                    children: [
                                      Icon(Icons.directions_car,
                                          color: Color(dart_green), size: 40),
                                      Text('Truyền động',
                                          style: TextStyle(color: Colors.grey)),
                                      Text(productData['truyendong'],
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 8, top: 16),
                                  child: Column(
                                    children: [
                                      FaIcon(FontAwesomeIcons.oilCan,
                                          color: Color(dart_green), size: 40),
                                      Text('Tiêu hao',
                                          style: TextStyle(color: Colors.grey)),
                                      Text(productData['tieuhao'] + 'L/100Km',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(left: 16, right: 16, top: 4),
                            child: const Divider(
                              color: Colors.grey,
                              height: 20,
                              thickness: 1,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 16, top: 4, bottom: 8),
                            width: double.infinity,
                            child: const Text(
                              'Địa chỉ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 350,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 10,
                                    offset: Offset(0,4)
                                )]
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 300,
                                  child: GoogleMap(
                                    onMapCreated: _onMapCreated,
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(productData['latitude'] ?? 10.827863783630507  , productData['longtitude'] ?? 106.72147069522974),
                                      zoom: 15.0,
                                    ),
                                    markers: {
                                      Marker(
                                          markerId: MarkerId('carLocation'),
                                          position: LatLng(productData['latitude'] ?? 10.827863783630507 , productData['longtitude'] ?? 106.72147069522974)
                                      ),
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 16, top: 8),
                                  width: double.infinity,
                                  child: Text(
                                    productData['address'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
        },
      ),
      bottomNavigationBar: FutureBuilder(
          future: reference.once(),
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.snapshot.value != null) {
                Map<String, dynamic> productData = Map<String, dynamic>.from(
                    snapshot.data!.snapshot.value as Map);
                return CustomBottomNavigationBar(
                  proId: productData['id'],
                  dayStart: dayStart,
                  dayEnd: dayEnd,
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
    ));
  }
}
