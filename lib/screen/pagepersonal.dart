import 'dart:ui';


import 'package:app_car_rental/const/UserProvider.dart';
import 'package:app_car_rental/const/authentication.dart';
import 'package:app_car_rental/screen/login.dart';
import 'package:app_car_rental/screen/main_page.dart';
import 'package:app_car_rental/screen/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Pagepersonal extends StatefulWidget {
  const Pagepersonal({super.key});

  @override
  State<Pagepersonal> createState() => _PagepersonalState();
}

class _PagepersonalState extends State<Pagepersonal> {
  String? nameUser ;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    checkAuthStatus();
  }
  Future<void> checkAuthStatus() async {
    User? user = auth.currentUser;
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    var userId1 = Provider.of<UserProvider>(context,listen: false).userId;
    if (user != null) {
      String? userId = userId1;
      try {
        DatabaseReference userRef = dbRef.child('Users').child(userId!);
        DatabaseEvent event = await userRef.once();
        DataSnapshot snapshot = event.snapshot;

        if (snapshot.exists) {
          Map<String, dynamic>? userData = Map<String, dynamic>.from(snapshot.value as Map);
          setState(() {
            nameUser = userData['name'];
          });
        } else {
          print('User data not found');
        }
      } catch (error) {
        print('Error fetching user data: $error');
      }
    } else {
      setState(() {
        nameUser = 'Xin chào !';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 335,
              child: Stack(
                children: [
                  SizedBox(
                    height: 250,
                    child: AppBar(
                      backgroundColor: Colors.greenAccent,
                    ),
                  ),
                  Positioned(
                    left: 170,
                    top: 180,
                    child: Container(
                      width: 100,
                      height: 100,
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
                  Positioned(
                    left: 155,
                    top: 280,
                    child: Text(
                      nameUser?? 'Xinchao', // Biến chứa tên người dùng
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 142, top: 295),
                    child: Text(
                      '',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 25,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 380,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                children: [

                  TextButton(
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>Profile())
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only( top: 16),
                        child:  Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Icon(Icons.person_2_outlined,color: Colors.black,),
                              width: 60,
                            ),
                            Container(
                                width: 265,
                                child: const Text('Tài khoản của tôi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color:Colors.black),)
                            ),
                            Container(
                                width: 20,
                                child: Icon(Icons.navigate_next)
                            ),
                          ],
                        ),
                      ))
                  ,
                  Container(
                    margin: EdgeInsets.only(left: 70.0),
                    width: double.infinity,
                    height: 1,
                    color: Color(0xFFDDDDDD),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8, top: 16),
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Icon(Icons.wallet_rounded),
                          width: 60,
                        ),
                        Container(
                            width: 250,
                            child: const Text('Đăng ký cho thuê xe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),)
                        ),
                        Container(
                            width: 60,
                            child: Icon(Icons.navigate_next)
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 70.0),
                    width: double.infinity,
                    height: 1,
                    color: Color(0xFFDDDDDD),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8, top: 16),
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Icon(Icons.favorite_outline),
                          width: 60,
                        ),
                        Container(
                            width: 250,
                            child: const Text('Xe yêu thích', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),)
                        ),
                        Container(
                            width: 60,
                            child: Icon(Icons.navigate_next)
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 70.0),
                    width: double.infinity,
                    height: 1,
                    color: Color(0xFFDDDDDD),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8, top: 16),
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Icon(Icons.location_on),
                          width: 60,
                        ),
                        Container(
                            width: 250,
                            child: const Text('Địa chỉ của tôi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),)
                        ),
                        Container(
                            width: 60,
                            child: Icon(Icons.navigate_next)
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 70.0),
                    width: double.infinity,
                    height: 1,
                    color: Color(0xFFDDDDDD),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8, top: 16),
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Icon(Icons.document_scanner_sharp),
                          width: 60,
                        ),
                        Container(
                            width: 250,
                            child: const Text('Giấy phép lái xe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),)
                        ),
                        Container(
                            width: 60,
                            child: Icon(Icons.navigate_next)
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 70.0),
                    width: double.infinity,
                    height: 1,
                    color: Color(0xFFDDDDDD),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8, top: 16),
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Icon(Icons.card_giftcard),
                          width: 60,
                        ),
                        Container(
                            width: 250,
                            child: const Text('Thẻ của tôi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),)
                        ),
                        Container(
                            width: 60,
                            child: Icon(Icons.navigate_next)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 380,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 8, top: 16),
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Icon(Icons.people_alt_outlined),
                          width: 60,
                        ),
                        Container(
                            width: 250,
                            child: const Text('Giới thiệu bạn mới', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),)
                        ),
                        Container(
                            width: 60,
                            child: Icon(Icons.navigate_next)
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 70.0),
                    width: double.infinity,
                    height: 1,
                    color: Color(0xFFDDDDDD),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8, top: 16),
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Icon(Icons.card_giftcard),
                          width: 60,
                        ),
                        Container(
                            width: 250,
                            child: const Text('Quà tặng', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),)
                        ),
                        Container(
                            width: 60,
                            child: Icon(Icons.navigate_next)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 380,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 8, top: 16),
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Icon(Icons.lock),
                          width: 60,
                        ),
                        Container(
                            width: 250,
                            child: const Text('Đổi mật khẩu', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),)
                        ),
                        Container(
                            width: 60,
                            child: Icon(Icons.navigate_next)
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 70.0),
                    width: double.infinity,
                    height: 1,
                    color: Color(0xFFDDDDDD),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8, top: 16),
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Icon(Icons.delete_forever),
                          width: 60,
                        ),
                        Container(
                            width: 250,
                            child: const Text('Yêu cầu xóa tài khoản', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),)
                        ),
                        Container(
                            width: 60,
                            child: Icon(Icons.navigate_next)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 135.0,top: 16.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const MainPage(),
                        ),
                      );
                    },
                    child:
                    Text('Đăng xuất',style: TextStyle(color: Colors.red),),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.logout, color: Colors.red,)
                ],
              )
            ),
          ],
        ),
      )
    );
  }
}
