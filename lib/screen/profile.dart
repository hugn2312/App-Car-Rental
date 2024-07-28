import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Positioned(
                    left: 150,
                    top: 130,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/user_avatar.png'),
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 145, top: 295),
                    child: Text(
                      'Võ Văn Quảng',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 25,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Center(child: Text('Ngày tham gia: 06/06/2024')),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 87.0),
                  child: Container(
                    height: 40,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:  Row(
                      children: [
                        Container(
                          child: Icon(Icons.shopping_bag, color: Colors.green),
                          width: 40,
                        ),
                        Container(
                            width: 90,
                            child: const Text('0 chuyến', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),)
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:  Row(
                      children: [
                        Container(
                          child: Icon(Icons.verified_outlined, color: Colors.yellow),
                          width: 40,
                        ),
                        Container(
                            width: 70,
                            child: const Text('0 điểm', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),)
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 16, top: 16),
              child:  Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 235,
                      child: const Text('Giấy phép lái xe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey),)
                  ),
                  Container(
                      width: 140,
                      child: const Text('Xác thực ngay', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),)
                  ),
                  Container(
                      width: 20,
                      child: Icon(Icons.navigate_next)
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 4),
              child: const Divider(
                color: Colors.grey,
                height: 20,
                thickness: 1,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, top: 16),
              child:  Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 235,
                      child: const Text('Số điện thoại', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey),)
                  ),
                  Container(
                      width: 140,
                      child: const Text('Xác thực ngay', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),)
                  ),
                  Container(
                      width: 20,
                      child: Icon(Icons.navigate_next)
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 4),
              child: const Divider(
                color: Colors.grey,
                height: 20,
                thickness: 1,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, top: 16),
              child:  Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 105,
                      child: const Text('Email', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey),)
                  ),
                  Container(
                      width: 270,
                      child: const Text('vovanquang235@gmail.com', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),)
                  ),
                  Container(
                      width: 20,
                      child: Icon(Icons.navigate_next)
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 4),
              child: const Divider(
                color: Colors.grey,
                height: 20,
                thickness: 1,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, top: 16),
              child:  Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 240,
                      child: const Text('Facebook', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey),)
                  ),
                  Container(
                      width: 130,
                      child: const Text('Liên kết ngay', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),)
                  ),
                  Container(
                      width: 20,
                      child: Icon(Icons.navigate_next)
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 4),
              child: const Divider(
                color: Colors.grey,
                height: 20,
                thickness: 1,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, top: 16),
              child:  Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 245,
                      child: const Text('Google', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey),)
                  ),
                  Container(
                      width: 130,
                      child: const Text('Liên kết ngay', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),)
                  ),
                  Container(
                      width: 20,
                      child: Icon(Icons.navigate_next)
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 4),
              child: const Divider(
                color: Colors.grey,
                height: 20,
                thickness: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
