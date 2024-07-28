import 'package:flutter/material.dart';

class HoivaTraLoiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hỏi và trả lời'),
      ),
      body: Center(
        child: Text(
          'Đây là trang Hỏi và trả lời.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}