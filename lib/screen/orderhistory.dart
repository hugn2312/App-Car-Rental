import 'package:app_car_rental/const/color.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Orderhistory extends StatefulWidget {
  final int orderId;
  const Orderhistory({required this.orderId});

  @override
  State<Orderhistory> createState() => _OrderhistoryState();
}

class _OrderhistoryState extends State<Orderhistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0 , top:25.0),
                    child: IconButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.arrow_back_ios),
                        color: Colors.black,
                        iconSize: 40,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 45.0 , top:32.0),
                    child: Text('Chi tiết thuê xe' , style: TextStyle(fontSize: 30,fontWeight: FontWeight.w400),),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            UserInfomation(orderId: widget.orderId,),
            const SizedBox(
              height: 20,
            ),
            CarInfomation(orderId: widget.orderId,),
            ButtonReturn(orderId: widget.orderId)
          ],
        ),
      ),
    );
  }
}
class UserInfomation extends StatefulWidget {
  final int orderId;
  const UserInfomation({required this.orderId});

  @override
  State<UserInfomation> createState() => _UserInfomationState();
}

class _UserInfomationState extends State<UserInfomation> {
  DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child('Orders');
  DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('Users');

  @override
  Widget build(BuildContext context) {
    return
      StreamBuilder<DatabaseEvent>(
        stream: ordersRef
            .child(widget.orderId.toString())
            .onValue, // Lắng nghe thay đổi cho order hiện tại
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Lấy dữ liệu từ snapshot
            Map<dynamic, dynamic> orderData =
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            String uid = orderData['uid'].toString();

            // Truy vấn dữ liệu xe từ bảng "Cars"
            return StreamBuilder<DatabaseEvent>(
              stream: usersRef.child(uid).onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<dynamic, dynamic> userData =
                  snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  // Hiển thị thông tin xe
                  return Padding(
                    padding: const EdgeInsets.only(left: 16.0,right: 16.0),
                    child: Container(
                      width: double.infinity,
                      height: 240,
                      decoration: BoxDecoration(
                          color: Color(light_green),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 16.0, top: 16.0),
                            child: Text('Thông tin khách hàng' , style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 16, right: 16, top: 4),
                            child: const Divider(
                              color: Colors.black,
                              height: 5,
                              thickness: 2,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/user_avatar.png'),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 16.0, top: 32.0),
                                child: Text(userData['name'] , style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Container(
                              width: double.infinity,
                              height: 80,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.phone , color: Color(0xFF41B06E),),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(userData['phoneNumber'], style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, color: Color(0xFF41B06E),),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text('Quận Thủ Đức, TPHCM', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return CircularProgressIndicator(); // Hiển thị loading khi đang tải dữ liệu
                }
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      );

  }
}
class CarInfomation extends StatefulWidget {
  final int orderId;
  const CarInfomation({required this.orderId});

  @override
  State<CarInfomation> createState() => _CarInfomationState();
}

class _CarInfomationState extends State<CarInfomation> {
  DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child('Orders');
  DatabaseReference productsRef = FirebaseDatabase.instance.ref().child('Cars');
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String?> getCarImageFromStorage(String img) async {
    try {
      // Đường dẫn đến ảnh trong Firebase Storage
      String imagePath = 'Car/$img';

      // Lấy link tải xuống ảnh
      String downloadUrl =
      await FirebaseStorage.instance.ref(imagePath).getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Lỗi khi lấy ảnh từ Storage: $e');
      return null;
    }
  }
  Future<double> calculateTotalCost(String orderId) async {
    // Lấy dữ liệu order
    DataSnapshot orderSnapshot = await ordersRef.child(orderId).get();
    Map<dynamic, dynamic> orderData = orderSnapshot.value as Map<dynamic, dynamic>;

    // Lấy ngày nhận và ngày trả
    DateTime receiveDay = DateTime.parse(orderData['receiveDay']);
    DateTime returnDay = DateTime.parse(orderData['returnDay']);
    final int difference =
        (returnDay.difference(receiveDay).inDays) + 1;

    // Tính số ngày thuê



    // Lấy giá thuê xe từ bảng "Cars"
    String proId = orderData['proId'].toString();
    DataSnapshot carSnapshot = await productsRef.child(proId).get();
    Map<dynamic, dynamic> carData = carSnapshot.value as Map<dynamic, dynamic>;
    double pricePerDay = double.tryParse(carData['price']) ?? 0; // Lấy giá từ trường "price"

    // Tính tổng tiền
    return pricePerDay * difference;
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: ordersRef
          .child(widget.orderId.toString())
          .onValue, // Lắng nghe thay đổi cho order hiện tại
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Lấy dữ liệu từ snapshot
          Map<dynamic, dynamic> orderData =
          snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          String proId = orderData['proId'].toString();

          // Truy vấn dữ liệu xe từ bảng "Cars"
          return StreamBuilder<DatabaseEvent>(
            stream: productsRef.child(proId).onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DateTime receiveDay = DateTime.parse(orderData['receiveDay']);
                DateTime returnDay = DateTime.parse(orderData['returnDay']);
                Map<dynamic, dynamic> carData =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                String img = carData['img'];
                // Hiển thị thông tin xe
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0 , right: 16.0),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    width: double.infinity,
                    height: 620,
                    decoration: BoxDecoration(
                        color: Color(light_green),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0, top: 16.0),
                          child: Text('Chi tiết hoá đơn' , style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 4),
                          child: const Divider(
                            color: Colors.black,
                            height: 5,
                            thickness: 2,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        FutureBuilder<String?>(
                          future: getCarImageFromStorage(img),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              String? imageLink = snapshot.data;
                              return Padding(
                                padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0 ),
                                child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    image:  DecorationImage(
                                      image: NetworkImage(imageLink!),
                                      fit: BoxFit.fitWidth,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Lỗi khi tải ảnh');
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(carData['name'] , style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Container(
                            width: double.infinity,
                            height: 110,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.calendar_month_outlined),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text('Ngày nhận' , style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),),
                                    Padding(
                                      padding: EdgeInsets.only(left: 90),
                                      child: Text( orderData['receiveDay'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_month_outlined, ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text('Ngày trả' , style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),),
                                    Padding(
                                      padding: EdgeInsets.only(left: 115),
                                      child: Text(orderData['returnDay'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Trạng thái' , style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),),
                                    Padding(
                                      padding: EdgeInsets.only(left: 140.0),
                                      child: Text(orderData['status'] , style: TextStyle(fontSize: 20,color: Color(dart_green), fontWeight: FontWeight.bold),),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
                          child: const Divider(
                            color: Colors.black,
                            height: 5,
                            thickness: 2,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Container(
                            width: double.infinity,
                            height: 70,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox( width: 190,child: Text('Đơn giá thuê' , style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),)),
                                    Container(
                                      width: 142,
                                        padding: EdgeInsets.only(left: 0.0),
                                        child: Text(NumberFormat.decimalPattern().format(int.parse(carData['price'])) + r' $',textAlign: TextAlign.end , style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 115,child: Text('Tổng cộng' , style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),)),
                                    Container(
                                      width: 230,
                                        padding: EdgeInsets.only(left: 0.0),
                                        child: Text(NumberFormat.decimalPattern().format(int.parse(carData['price'])) + r' $' + ' x ' + ((returnDay.difference(receiveDay).inDays) + 1).toString() + ' Ngày',textAlign: TextAlign.end, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
                          child: const Divider(
                            color: Colors.black,
                            height: 5,
                            thickness: 2,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: FutureBuilder<double>(
                            future: calculateTotalCost(widget.orderId.toString()), // Truyền ID order
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                double totalCost = snapshot.data!;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Thành tiền' , style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),),
                                    Padding(
                                      padding: EdgeInsets.only(left: 165.0),
                                      child: Text(NumberFormat.decimalPattern().format(totalCost) + r' $' , style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                    ),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Text('Lỗi khi tính tổng tiền');
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),

                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return CircularProgressIndicator(); // Hiển thị loading khi đang tải dữ liệu
              }
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class ButtonReturn extends StatefulWidget {
  final int orderId;
  const ButtonReturn({super.key, required this.orderId});

  @override
  State<ButtonReturn> createState() => _ButtonReturnState();
}

class _ButtonReturnState extends State<ButtonReturn> {
  Future<void> _updateCarStatus(String orderId) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('Orders').child(orderId);
    await ref.update({
      'status': 'Đã trả',
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hoàn tất trả xe')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật trạng thái xe thất bại: $error')),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        _updateCarStatus(widget.orderId.toString());
      },
      child: Container(
        margin: EdgeInsets.only(right: 8, left: 8, bottom: 8),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4))
            ],
            color: Color(dart_green),
            borderRadius: BorderRadius.circular(20)),
        child: const Center(
            child: Text(
              'Trả xe',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            )),
      ),
    );

  }
}

