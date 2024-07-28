import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DialogPrice extends StatelessWidget {
  const DialogPrice({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Bảng giá'),
      content: const SingleChildScrollView(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 340,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Hyundai Accent 2022'),
                SizedBox(height: 10),
                Text('Thời gian thuê xe: 2 ngày'),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Đơn giá thuê'),
                    Text('780,640 đ/ngày'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Bảo hiểm thuê xe'),
                    Text('68,000 đ/ngày'),
                  ],
                ),
                SizedBox(height: 10),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Tổng cộng'),
                    Text('1,697,280 đ'),
                  ],
                ),
                SizedBox(height: 10),
                Text('Khuyến mãi'),
                SizedBox(height: 10),
                Text('2 Mã khuyến mãi'),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Thành tiền'),
                    Text('1,697,280 đ'),
                  ],
                ),
              ],
            ),
          ),
        )

      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Đóng'),
        ),
        TextButton(
          onPressed: () {
            // Xử lý khi người dùng nhấn nút "Thuê"
            print('Người dùng nhấn nút "Thuê"');
          },
          child: const Text('Thuê'),
        ),
      ],
    );
  }
}
