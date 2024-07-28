import 'package:flutter/material.dart';

void showHotlineModal(BuildContext context, String companyName) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Stack(
        children: [
          Container(
            height: 230,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                buildHotlineRow('assets/images/MIC_logo.png', '1900 558 891'),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 4),
                  child: const Divider(
                    color: Colors.grey,
                    height: 20,
                    thickness: 1,
                  ),
                ),
                buildHotlineRow('assets/images/PVI_logo.png', '1900 545 458'),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 4),
                  child: const Divider(
                    color: Colors.grey,
                    height: 20,
                    thickness: 1,
                  ),
                ),
                buildHotlineRow('assets/images/VNI_logo.png', '093 739 3955'),
              ],
            ),
          ),
          Positioned(
            top: 2,
            left: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.close,
                color: Colors.black,
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget buildHotlineRow(String imagePath, String phoneNumber) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Image.asset(imagePath, width: 40, height: 40),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hotline',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 2),
            Text(
              phoneNumber,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        Spacer(),
        Icon(Icons.phone_outlined, color: Colors.black),
      ],
    ),
  );
}
