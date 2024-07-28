import 'package:flutter/material.dart';

class BaoMatThongTinPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bảo mật thông tin'),
      ),
      body: Center(
        child: Text(
          'Đây là trang bảo mật thông tin.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}