
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../detail_suport/baomatthongtinpage.dart';
import '../detail_suport/chinhsachvaquidinh.dart';
import '../detail_suport/danhgiapage.dart';
import '../detail_suport/fanpagepage.dart';
import '../detail_suport/giaiquyettranhchap.dart';
import '../detail_suport/hoivatraloipage.dart';
import '../detail_suport/hotlinemodal.dart';
import '../detail_suport/quychehoatdongpage.dart';
import '../detail_suport/thongtincongty.dart';

class SuportPage extends StatefulWidget {
  const SuportPage({Key? key}) : super(key: key);
  @override
  _SuportPageState createState() => _SuportPageState();
}

class _SuportPageState extends State<SuportPage> {
  void _onContainerTapped(BuildContext context, String containerName) {
    switch (containerName) {
      case 'Thông tin công ty':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CompanyInfoPage()),
        );
        break;
      case 'Chính sách và quy định':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChinhSachvaQuiDinhPage()),
        );
        break;
      case 'Đánh giá Mioto':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DanhGiaPage()),
        );
        break;
      case 'Fanpage Mioto':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FanpagePage()),
        );
        break;
      case 'Hỏi và trả lời':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HoivaTraLoiPage()),
        );
        break;
      case 'Quy chế hoạt động':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QuyCheHoatDongPage()),
        );
        break;
      case 'Bảo mật thông tin':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BaoMatThongTinPage()),
        );
        break;
      case 'Giải quyết tranh chấp':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GiaiQuyetTranhChapPage()),
        );
        break;
      default:
        print('Tapped on $containerName');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 380,
              child: Stack(
                children: [
                  // AppBar container
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 173, 246, 175),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        border: Border.all(color: Colors.green),
                      ),
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    ),
                  ),

                  // Positioned container
                  Positioned(
                    top: 190,
                    left: 10,
                    right: 10,
                    child: Container(
                      height: 190,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cần hỗ trợ nhanh, vui lòng gọi 1900 9217 (7PM - 10PM) hoặc gửi tin nhắn vào CarApp FanPage',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.phone,
                                    color: Colors.green,
                                  ),
                                  label: Text(
                                    'Gọi',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(color: Colors.green),
                                    ),
                                    minimumSize: Size(170, 50),
                                  ),
                                ),
                                SizedBox(width: 16),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon:
                                  Icon(Icons.message, color: Colors.white),
                                  label: Text(
                                    'Gửi tin nhắn',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minimumSize: Size(170, 50),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Hotline bảo hiểm',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => showHotlineModal(context, 'MIC'),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Image.asset('assets/images/suport/MIC_logo.png'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => showHotlineModal(context, 'PVI'),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Image.asset('assets/images/suport/PVI_logo.png'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => showHotlineModal(context, 'VNI'),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Image.asset('assets/images/suport/VNI_logo.png'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Hướng dẫn',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            // Adding three images below 'Hướng dẫn' with horizontal scrolling
            Container(
              height: 200, // Increase height to make images larger
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Container(
                      width: 312,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Image.asset('assets/images/suport/suport1.jpg'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 312,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Image.asset('assets/images/suport/suport2.jpg'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 312,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Image.asset('assets/images/suport/suport3.jpg'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Reduced padding for 'Thông tin' text
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Thông tin',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            // New row with two containers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            _onContainerTapped(context, 'Thông tin công ty'),
                        child: Container(
                          height: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info_sharp, color: Colors.green, size: 40),
                              SizedBox(height: 10),
                              Text(
                                'Thông tin',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'công ty',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      )),
                  SizedBox(width: 0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          _onContainerTapped(context, 'Chính sách và quy định'),
                      child: Container(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.policy_sharp,
                                color: Colors.green, size: 40),
                            SizedBox(height: 10),
                            Text(
                              'Chính sách',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'và qui định',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          _onContainerTapped(context, 'Đánh giá Mioto'),
                      child: Container(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star_rate_sharp,
                                color: Colors.green, size: 40),
                            SizedBox(height: 10),
                            Text(
                              'Đánh giá',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Mioto',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _onContainerTapped(context, 'Fanpage Mioto'),
                      child: Container(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.group, color: Colors.green, size: 40),
                            SizedBox(height: 10),
                            Text(
                              'Fanpage',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Mioto',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          _onContainerTapped(context, 'Hỏi và trả lời'),
                      child: Container(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.question_answer_sharp,
                                color: Colors.green, size: 40),
                            SizedBox(height: 10),
                            Text(
                              'Hỏi và trả lời',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          _onContainerTapped(context, 'Quy chế hoạt động'),
                      child: Container(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.rule_sharp,
                                color: Colors.green, size: 40),
                            SizedBox(height: 10),
                            Text(
                              'Quy chế',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'hoạt động',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          _onContainerTapped(context, 'Bảo mật thông tin'),
                      child: Container(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.security_sharp,
                                color: Colors.green, size: 40),
                            SizedBox(height: 10),
                            Text(
                              'Bảo mật',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'thông tin',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          _onContainerTapped(context, 'Giải quyết tranh chấp'),
                      child: Container(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.gavel_sharp,
                                color: Colors.green, size: 40),
                            SizedBox(height: 10),
                            Text(
                              'Giải quyết',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'tranh chấp',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
