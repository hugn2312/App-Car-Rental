import 'package:flutter/material.dart';

class DetailNotificationPage extends StatelessWidget {
  final String title;
  final String body;
  final String imgUrl;

  DetailNotificationPage({
    required this.title,
    required this.body,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết thông báo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            imgUrl.isNotEmpty
                ? Image.network(
              imgUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            )
                : Container(
              height: 250,
              color: Colors.grey,
              child: Center(
                child: Text(
                  'No Image Available',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                body,
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
