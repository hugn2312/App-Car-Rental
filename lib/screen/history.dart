import 'dart:async';
import 'dart:ui';

import 'package:app_car_rental/const/color.dart';
import 'package:app_car_rental/screen/orderhistory.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../const/UserProvider.dart';

class History extends StatefulWidget {
  String uid;
  History({super.key, required this.uid});
  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  DatabaseReference references =
      FirebaseDatabase.instance.ref().child('Orders');
  Query dbRef = FirebaseDatabase.instance.ref().child('Orders');
  @override
  void initState() {
    super.initState();
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    // TODO: implement initState
    setState(() {
      dbRef =
          references.orderByChild('uid').equalTo(userId);
    });
  }

  void updateQuery(String categoryId) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(grey),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Padding(
            padding: EdgeInsets.only(left: 110),
            child: Text(
              'Chuyến của tôi',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            )),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.history, size: 35),
            onPressed: () {
              // Hành động khi nhấn biểu tượng tìm kiếm
            },
          ),
        ],
      ),
      body: FirebaseAnimatedList(
        scrollDirection: Axis.vertical,
        query: dbRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map orders = snapshot.value as Map;
          orders['key'] = snapshot.key;
          return ListItem(orderId: orders['orderId']);
        },
      ),
    ));
  }
}

class ListItem extends StatefulWidget {
  final int orderId;
  const ListItem({required this.orderId});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
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
                Map<dynamic, dynamic> carData =
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                String img = carData['img'];
                // Hiển thị thông tin xe
                return Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(0, 2),
                        blurRadius: 10,
                      ),
                    ],
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Row(
                    children: [
                      FutureBuilder<String?>(
                        future: getCarImageFromStorage(img),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            String? imageLink = snapshot.data;
                            return Container(
                                margin: EdgeInsets.only(left: 16),
                                height: 180,
                                width: 180,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    image: DecorationImage(
                                        image: NetworkImage(imageLink!),
                                        fit: BoxFit.cover)));
                          } else if (snapshot.hasError) {
                            return Text('Lỗi khi tải ảnh');
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 32.0, left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 115,
                              child: Text(carData['name'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: FutureBuilder<double>(
                                future: calculateTotalCost(widget.orderId.toString()), // Truyền ID order
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    double totalCost = snapshot.data!;
                                    return RichText(
                                      textAlign: TextAlign.end,
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: 'Giá thuê: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black)),
                                          TextSpan(
                                              text: r'$' + totalCost.toStringAsFixed(0) ,
                                              style: TextStyle(
                                                  color: Color(0xFF4CAF50),
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Lỗi khi tính tổng tiền');
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: RichText(
                                textAlign: TextAlign.end,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Trạng thái: ',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black)),
                                    TextSpan(
                                        text: orderData['status'],
                                        style: TextStyle(
                                            color: Color(0xFF4CAF50),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: null,
                              label: const Text('Hỗ trợ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black)),
                              icon: const Icon(Icons.help_outline),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Orderhistory(orderId: orderData['orderId'],)),
                                    );
                                  },
                                  child: const Text(
                                    'Xem chi tiết',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                Icon(Icons.navigate_next),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
//
// FutureBuilder(
//   future: dbRef.once(),
//   builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//     if (snapshot.hasData) {
//       if(snapshot.data!.snapshot.value != null) {
//         Map<String, dynamic> productData = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
//         final ref = storage.ref().child('Car/' + productData['img']);
//         return FutureBuilder(
//             future: ref.getDownloadURL(),
//             builder: (context, AsyncSnapshot<String> urlSnapshot) {
//               if (urlSnapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (urlSnapshot.hasError) {
//                 return Center(child: Text('Error: ${urlSnapshot.error}'));
//               } else if (urlSnapshot.hasData) {
//                 String imgUrl = urlSnapshot.data!;
//                 return Row(
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(left: 16),
//                       height: 180,
//                       width: 180,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(18),
//                           image: DecorationImage(
//                               image: AssetImage('assets/images/car4.jpg'),
//                               fit: BoxFit.fitHeight
//                           )
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(top: 32.0,left: 8),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(widget.order['orderId'].toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: RichText(
//                               textAlign: TextAlign.end,
//                               text: const TextSpan(
//                                   children: <TextSpan>[
//                                     TextSpan(text: 'Giá thuê: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400,color: Colors.black),),
//                                     TextSpan(text: '1200K', style: TextStyle(color: Color(dart_green), fontSize: 22, fontWeight: FontWeight.bold)),
//                                   ]
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: RichText(
//                               textAlign: TextAlign.end,
//                               text: const TextSpan(
//                                   children: <TextSpan>[
//                                     TextSpan(text: 'Trạng thái: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400,color: Colors.black),),
//                                     TextSpan(text: 'Đang hoạt động', style: TextStyle(color: Color(dart_green), fontSize: 16, fontWeight: FontWeight.bold)),
//                                   ]
//                               ),
//                             ),
//                           ),
//                           TextButton.icon(
//                             onPressed: null,
//                             label: const Text('Hỗ trợ',style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400,color: Colors.black)),
//                             icon: const Icon(Icons.help_outline,),
//                           ),
//                           Row(
//                             children: [
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(builder: (context) => Orderhistory()));
//                                 },
//                                 child: const Text('Xem chi tiết',
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w400,
//                                         color: Colors.black,
//                                         decoration: TextDecoration.underline)
//                                 ),
//                               ),
//                               Icon(Icons.navigate_next)
//                             ],
//                           )
//                         ],
//                       ),
//                     )
//                   ],
//                 );
//               }
//               else {
//                 return Center(child: Text('No image URL available'));
//               }
//             }
//         );
//       } else {
//         return Center(child: Text('No data available'));
//       }
//     }else if (snapshot.hasError) {
//       return Center(child: Text('Error: ${snapshot.error}'));
//     }else {
//       return Center(child: CircularProgressIndicator());
//     }
//   } ,
// ),
//
