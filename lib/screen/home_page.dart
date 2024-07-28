import 'package:app_car_rental/bar/nav_bar_detail.dart';
import 'package:app_car_rental/const/image.dart';
import 'package:app_car_rental/screen/MapPage.dart';
import 'package:app_car_rental/screen/ProductList.dart';
import 'package:app_car_rental/screen/checkout.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../bar/nav_bar.dart';
import '../bar/nav_model.dart';
import '../const/UserProvider.dart';
import '../const/color.dart';
import 'detail_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class ButtonState extends ChangeNotifier {
  Color color = Colors.white; // Màu mặc định của button là trắng
  void selectButton() {
    color = color == Colors.white
        ? const Color(dart_green)
        : Colors.white; // Thay đổi màu button
    notifyListeners(); // Thông báo thay đổi cho các widget lắng nghe
  }
}

class _HomePage extends State<HomePage> {
  Color bgColor = Colors.white;
  Color bgColor1 = Color(dart_green);
  bool selectedTap = false;
  bool selectedTap1 = true;
  List<NavModel> items = [];

  String? nameUser;
  Query dbRef = FirebaseDatabase.instance.ref().child('Cars');
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('Cars');
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
  }

  Future<String> fetchUserName() async {
    User? user = auth.currentUser;
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();

    if (user != null) {
      final userId1 = Provider.of<UserProvider>(context, listen: false).userId;
      String userId = user.uid;
      try {
        DatabaseReference userRef = dbRef.child('Users').child(userId1!);
        DatabaseEvent event = await userRef.once();
        DataSnapshot snapshot = event.snapshot;

        if (snapshot.exists) {
          Map<String, dynamic>? userData =
              Map<String, dynamic>.from(snapshot.value as Map);
          return userData['name']?? 'Xin chào';
        } else {
          print('User data not found');
          return 'Xin chào';
        }
      } catch (error) {
        print('Error fetching user data: $error');
        return 'Xin chào';
      }
    } else {
      return 'Xin chào';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Query _query = reference.orderByChild('hangxe').equalTo('2');
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 250,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        height: 250,
                        child: AppBar(
                          automaticallyImplyLeading: false,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50))),
                          backgroundColor: const Color(light_green),
                          flexibleSpace: Padding(
                            padding: EdgeInsets.fromLTRB(10, 40, 20, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                  onPressed: null,
                                  style: ButtonStyle(
                                    backgroundColor: null,
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundImage: AssetImage(
                                            'assets/images/user_avatar.png'),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FutureBuilder<String>(
                                            future:
                                                fetchUserName(), // Gọi hàm fetchUserName()
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator(); // Hiển thị loading indicator
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              } else {
                                                return RichText(
                                                  text: TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: 'Xin chào !\n ',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.black45,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: snapshot.data ?? 'Xin chào',
                                                        style: TextStyle(
                                                            fontSize: 23,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Icon(Icons.favorite_border,
                                          color: Colors.black, size: 30),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.card_giftcard,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 200,
                      left: 20,
                      right: 20,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          children: [
                            //search start
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    selectedTap = true;
                                    selectedTap1 = false;
                                    if (selectedTap == true &&
                                        selectedTap1 == false) {
                                      bgColor = Color(dart_green);
                                      bgColor1 = Colors.white;
                                    }
                                  });
                                },
                                icon: const Icon(Icons.directions_car),
                                label: const Text(
                                  'Xe tự lái',
                                  style: TextStyle(fontSize: 16),
                                ),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50),
                                  backgroundColor: bgColor,
                                  foregroundColor: Colors.black,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    selectedTap = false;
                                    selectedTap1 = true;
                                    if (selectedTap == false &&
                                        selectedTap1 == true) {
                                      bgColor = Colors.white;
                                      bgColor1 = Color(dart_green);
                                    }
                                  });
                                },
                                icon: const Icon(Icons.directions_bus),
                                label: const Text('Xe có tài xế',
                                    style: TextStyle(fontSize: 16)),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50),
                                  foregroundColor: Colors.black,
                                  backgroundColor: bgColor1,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              if (selectedTap == true && selectedTap1 == false) Search(),
              if (selectedTap == false && selectedTap1 == true) Search1(),
              // search end
              //CTKM start
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 20),
                child: Text(
                  'Chương trình khuyến mãi',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                child: CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                  ),
                  items: [
                    Container(
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/images/bn1.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/images/bn2.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/images/bn3.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/images/bn4.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              //CTKM end
              const Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  'Xe dành cho bạn',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              //Item xe
              Container(
                height: 500,
                width: double.infinity,
                child: FirebaseAnimatedList(
                  scrollDirection: Axis.horizontal,
                  query: _query,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map car = snapshot.value as Map;
                    car['key'] = snapshot.key;
                    return CarListItem(car: car);
                  },
                ),
              ),
              //End Item xe
              const Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  'Địa điểm nổi bật',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  height: 300,
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 16),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Stack(
                        children: [
                          Container(
                            height: 280,
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/thuduc.jpg'),
                                    fit: BoxFit.fitHeight)),
                          ),
                          Container(
                            width: 200.0,
                            height: 280.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0),
                                  Colors.black.withOpacity(0.5),
                                  Colors.black
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomLeft,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 240.0, left: 16),
                              child: Text(
                                'TP. Thủ Đức',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Stack(
                        children: [
                          Container(
                            height: 280,
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: AssetImage('assets/images/q10.jpg'),
                                    fit: BoxFit.fitHeight)),
                          ),
                          Container(
                            width: 200.0,
                            height: 280.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0),
                                  Colors.black.withOpacity(0.5),
                                  Colors.black
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomLeft,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 240.0, left: 16),
                              child: Text(
                                'Quận 10',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Stack(
                        children: [
                          Container(
                            height: 280,
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/binhthanh.jpg'),
                                    fit: BoxFit.fitHeight)),
                          ),
                          Container(
                            width: 200.0,
                            height: 280.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0),
                                  Colors.black.withOpacity(0.5),
                                  Colors.black
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomLeft,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 240.0, left: 16),
                              child: Text(
                                'Quận Bình Thạnh',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Stack(
                        children: [
                          Container(
                            height: 280,
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/quan1.jpg'),
                                    fit: BoxFit.fitHeight)),
                          ),
                          Container(
                            width: 200.0,
                            height: 280.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0),
                                  Colors.black.withOpacity(0.5),
                                  Colors.black
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomLeft,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 240.0, left: 16),
                              child: Text(
                                'Quận 1',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 16,
                      ),
                    ],
                  )),
              const Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  'Ưu điểm của Mioto',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 16.0),
                child: Container(
                  height: 180,
                  margin: EdgeInsets.only(bottom: 16),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal, // Đặt hướng cuộn ngang
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Container(
                            height: 40,
                            width: 390,
                            decoration: BoxDecoration(
                                color: const Color(light_green),
                                borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/safety.png'))),
                                  margin: EdgeInsets.only(left: 24, right: 16),
                                  height: 70,
                                  width: 70,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 280,
                                      margin: const EdgeInsets.only(top: 16),
                                      child: const Text(
                                        'Lái xe an toàn cùng Mioto',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 8),
                                        width: 270,
                                        child: const Text(
                                          'Chuyến đi trên Mioto được bảo vệ với gói bảo'
                                          'hiểm thuê xe tự lái từ MIC & VNI. Khách thuê chỉ bồi thường'
                                          'tối đa 2,000,000 khi có sự cố ngò ý muốn',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CarListItem extends StatefulWidget {
  final Map<dynamic, dynamic> car;
  const CarListItem({required this.car});

  @override
  State<CarListItem> createState() => _CarListItemState();
}

class _CarListItemState extends State<CarListItem> {
  late String imageUrl;
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    imageUrl = '';
    _getImageUrl();
  }

  Future<void> _getImageUrl() async {
    final ref = storage.ref().child('Car/' + widget.car['img']);
    final url = await ref.getDownloadURL();
    setState(() {
      imageUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailProduct(
                        proId: widget.car['id'],
                      )));
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          height: 430,
          width: 390,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1.0, color: Colors.grey),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(16),
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color(green),
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: NetworkImage(imageUrl), fit: BoxFit.fitWidth)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IntrinsicWidth(
                      child: Container(
                        padding: EdgeInsets.only(left: 4, right: 4),
                        height: 30,
                        decoration: BoxDecoration(
                            color: const Color(green),
                            borderRadius: BorderRadius.circular(16)),
                        child: const Center(
                            child: Text(
                          'Số tự động',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: IntrinsicWidth(
                        child: Container(
                          padding: EdgeInsets.only(left: 4, right: 4),
                          height: 30,
                          decoration: BoxDecoration(
                              color: const Color(light_green),
                              borderRadius: BorderRadius.circular(16)),
                          child: const Center(
                              child: const Text(
                            'Giao xe tận nơi',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: Text(
                  widget.car['name'],
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 0),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.black),
                    Text(
                      widget.car['address'],
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(8),
                width: double.infinity,
                height: 1,
                color: Color(0xFF686D76),
              ),
              Container(
                margin: EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 60,
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 30,
                          ),
                          Text(
                            '5.0',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 4,
                      ),
                    ),
                    const SizedBox(
                      width: 180,
                      child: Row(
                        children: [
                          Icon(
                            Icons.shopping_bag,
                            color: Color(dart_green),
                          ),
                          Text('55 Chuyến',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black)),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: RichText(
                        textAlign: TextAlign.end,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: widget.car['price'] + r"$",
                              style: TextStyle(
                                  color: Color(dart_green),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text: '/ngày',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18)),
                        ]),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

//search
class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        height: 200,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 9, right: 20),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Mappage()));
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  color: Colors.white,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Địa điểm gần bạn',
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      prefixIcon: Icon(Icons.location_on_sharp),
                      border: UnderlineInputBorder(),
                    ),
                  ),
                )
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Thời gian thuê',
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  prefixIcon: Icon(Icons.calendar_month),
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Productlist()));
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(dart_green)),
                  foregroundColor: MaterialStateProperty.all(
                      Colors.white), // Đặt màu chữ và icon
                  minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 50)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: const Text(
                  'Tìm xe',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//search1
class Search1 extends StatefulWidget {
  const Search1({super.key});

  @override
  State<Search1> createState() => _Search1State();
}

class _Search1State extends State<Search1> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Địa điểm abc',
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  hintText: 'Nhập địa điểm',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  prefixIcon: Icon(Icons.location_on),
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
            // const Padding(
            //   padding: EdgeInsets.only(left: 20, right: 20),
            //   child: TextField(
            //     decoration: InputDecoration(
            //       labelText: 'Thời gian thuê',
            //       labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
            //       prefixIcon: Icon(Icons.calendar_month),
            //       border: UnderlineInputBorder(),
            //     ),
            //   ),
            // ),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Thời gian thuê',
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  prefixIcon: Icon(Icons.calendar_month),
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: ElevatedButton(
                onPressed: null,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(dart_green)),
                  foregroundColor: MaterialStateProperty.all(
                      Colors.white), // Đặt màu chữ và icon
                  minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 50)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: const Text(
                  'Tìm xe',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


