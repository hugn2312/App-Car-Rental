import 'package:app_car_rental/const/color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';

import 'checkout.dart';
import 'detail_product.dart';

class Productlist extends StatefulWidget {
  const Productlist({super.key});

  @override
  State<Productlist> createState() => _ProductlistState();
}

class _ProductlistState extends State<Productlist> {
  late String selectedCategoryId = '1' ;
  Query dbRef = FirebaseDatabase.instance.ref().child('Cars');
  DatabaseReference references = FirebaseDatabase.instance.ref().child('Cars');
  @override
  void initState() {
    super.initState();
    // Thiết lập query ban đầu
    dbRef ;
  }

  void updateQuery(String categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
      dbRef = references.orderByChild('hangxe').equalTo(selectedCategoryId);
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 100,
            backgroundColor: Colors.white,
            title: TextButton(
              onPressed: null,
              child: Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(grey),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      height: 50,
                      width: 230,
                      child: const Column(
                        children: [
                          Text('32 Tam Bình, Hiệp Bình Chánh, Thủ Đức',style: TextStyle(
                            fontSize: 18,
                            color: Colors.black
                          ),
                          overflow: TextOverflow.ellipsis,
                          ),
                          Text('21h00, 03/07/2024 - 20h00, 04/07/2024',style: TextStyle(
                              fontSize: 14,
                              color: Colors.black45
                          ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: FaIcon(FontAwesomeIcons.search, color: Colors.black,),
                    )
                  ],
                ),
              ),
            ),
            leadingWidth: 70,
            leading: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey,
                    width: 2
                  )
                ),
                child: Center(child: FaIcon(FontAwesomeIcons.angleLeft,color: Colors.black,)),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8,left: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                          onPressed: (){
                          },
                          child: Container(
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                    color: Colors.grey,
                                    width: 1.5
                                )
                            ),
                            child: const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Icon(Icons.car_rental, size: 30,color: Colors.black,),
                                ),
                                Text('Loại xe',style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black
                                ),)
                              ],
                            ),
                          )
                      ),
                      TextButton(
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (context) => const DiaCategory(),
                            ).then((selectedValue) {
                              if (selectedValue != null) {
                                updateQuery(selectedValue); // Cập nhật query mới
                                print('Id đã chọn: $selectedValue');
                              }
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                    color: Colors.grey,
                                    width: 1.5
                                )
                            ),
                            child: const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Icon(Icons.category, size: 30,color: Colors.black,),
                                ),
                                Text('Hãng xe',style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black
                                ),)
                              ],
                            ),
                          )
                      ),
                    ],
                  )
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 32),
                  height: 800,
                  width: double.infinity,
                  child:
                  FutureBuilder(
                      future: dbRef.once(),
                      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot){
                        if (snapshot.hasData) {
                          if (snapshot.data!.snapshot.value != null){
                            if (snapshot.data!.snapshot.value is List) {
                              return
                                FirebaseAnimatedList(
                                scrollDirection: Axis.vertical,
                                query: dbRef,
                                itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index){
                                  Map car = snapshot.value as Map ;
                                  car['key'] = snapshot.key;
                                  return CarListItem(car: car);
                                },
                              );
                            }
                            else if (snapshot.data!.snapshot.value is Map){
                              Map<dynamic, dynamic> productData = Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map);
                              List<dynamic> productList = productData.values.toList();
                              return ListView.builder(
                                  itemCount: productList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return CarListItem(car: productList[index]);
                                  }
                              );
                            } else {
                              return Center(child: Text('Unexpected data type'));
                            }
                          }
                          else {
                            return Center(child: Text('No data available'));
                          }
                        }
                        else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        else {
                          return Center(child: CircularProgressIndicator());
                        }
                      })
                  // FirebaseAnimatedList(
                  //   scrollDirection: Axis.vertical,
                  //   query: dbRef,
                  //   itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index){
                  //     Map car = snapshot.value as Map;
                  //     car['key'] = snapshot.key;
                  //     return CarListItem(car: car);
                  //   },
                  // ),
                ),
              ],
            )
        )
        )
    );
  }
}
//car list item
class CarListItem extends StatefulWidget {
  final Map<dynamic,dynamic> car;
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
    return
      TextButton(
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>DetailProduct(proId: widget.car['id'],))
            );
          },
          child:
          Container(
            margin: const EdgeInsets.fromLTRB(8, 10, 8, 10),
            height: 450,
            width: 410,
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
                  decoration:  BoxDecoration(
                      color: const Color(green),
                      borderRadius: BorderRadius.circular(20),
                      image:
                      DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.fitWidth
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IntrinsicWidth(
                        child:  Container(
                          padding: EdgeInsets.only(left: 4, right: 4),
                          height: 30,
                          decoration: BoxDecoration(
                              color: const Color(green),
                              borderRadius: BorderRadius.circular(16)
                          ),
                          child: const Center(
                              child: Text('Số tự động',style: TextStyle(color: Colors.black, fontSize: 16),)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: IntrinsicWidth(
                          child:Container(
                            padding: EdgeInsets.only(left: 4, right: 4),                                      height: 30,
                            decoration: BoxDecoration(
                                color: const Color(light_green),
                                borderRadius: BorderRadius.circular(16)
                            ),
                            child: const Center(
                                child: const Text('Giao xe tận nơi',style: TextStyle(color: Colors.black, fontSize: 16),)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: Text(widget.car['name'],
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 0),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on,color: Colors.black),
                      Text(widget.car['address'], style: TextStyle(fontSize: 18,color: Colors.black),)
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
                  child:  Row(
                    children: [
                      const SizedBox(
                        width: 60,
                        child:
                        Row(
                          children: [
                            Icon(Icons.star,color: Colors.amber,size: 30,),
                            Text('5.0', style: TextStyle(fontSize: 18),),
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
                        width: 150,
                        child: Row(
                          children: [
                            Icon(Icons.shopping_bag, color: Color(dart_green),),
                            Text('55 Chuyến',style: TextStyle(fontSize: 18,color: Colors.black)),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: RichText(
                          textAlign: TextAlign.end,
                          text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(text: widget.car['price'] + r'$', style: TextStyle(color: Color(dart_green), fontSize: 22, fontWeight: FontWeight.bold)),
                                const TextSpan(text: '/ngày', style: TextStyle(color: Colors.black, fontSize: 18)),
                              ]
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
      );
  }
}
//car list item end

//
class DiaCategory extends StatefulWidget {
  const DiaCategory({super.key});

  @override
  State<DiaCategory> createState() => _DiaCategoryState();
}

class _DiaCategoryState extends State<DiaCategory> {
  Query dbRef = FirebaseDatabase.instance.ref().child('HangXe');
  DatabaseReference references = FirebaseDatabase.instance.ref().child('HangXe');
  String selectedCategoryId = '';
  void _onCategorySelected(String categoryId){
    setState(() {
      selectedCategoryId = categoryId;
    });
    Navigator.of(context).pop(selectedCategoryId);
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        SizedBox(
          height:  MediaQuery.of(context).size.height/2,
        ),
        Container(
          padding: EdgeInsets.only(left: 16,top: 32,right: 16),
          height: (MediaQuery.of(context).size.height) / 2 - 24 ,
          decoration:const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                  topRight: Radius.circular(20))
          ),
            child: FirebaseAnimatedList(
              scrollDirection: Axis.vertical,
              query: dbRef,
              itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index){
                Map category = snapshot.value as Map;
                category['key'] = snapshot.key;
                return CategoryListItem(
                    category: category,
                    onCategorySelected: _onCategorySelected,
                );
              },
            ),
          ),
      ],
    );
  }
}
class CategoryListItem extends StatefulWidget {
  final Map<dynamic,dynamic> category;
  final Function(String) onCategorySelected;
  const CategoryListItem({required this.category, required this.onCategorySelected});

  @override
  State<CategoryListItem> createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem> {
  late String imageUrl;
  final FirebaseStorage storage = FirebaseStorage.instance;
  bool selectedTap = false;
  @override
  void initState() {
    super.initState();
    imageUrl = '';
    _getImageUrl();

  }

  Future<void> _getImageUrl() async {
    final ref = storage.ref().child('HangXe/' + widget.category['img']);
    final url = await ref.getDownloadURL();
    setState(() {
      imageUrl = url;
    });
  }
  @override
  Widget build(BuildContext context) {
    return
      TextButton(
          onPressed: (){
            setState(() {
              selectedTap = !selectedTap;
            });
            widget.onCategorySelected(widget.category['id']);
          },
          child: Container(
            height: 60,
            margin: EdgeInsets.only(top: 8,bottom: 16),
            padding: EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
                color: selectedTap ? Color(green) : Colors.white,
                border: Border.all(
                    color: selectedTap ? Color(green) : Colors.grey,
                    width: 1
                ),
                boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, 2),
                  blurRadius: 10,
                )]
            ),
            child: Row(
              children: [
                Flexible(
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(widget.category['name'],style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        decoration: TextDecoration.none
                    ),),
                  ),),
              ],
            ),
          )
      );
  }
}
