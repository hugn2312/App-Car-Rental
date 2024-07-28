import 'package:flutter/material.dart';

class ChinhSachvaQuiDinhPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'HỖ TRỢ',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Image.asset(
              "assets/images/suport/chinhsachvaquydinh.png",
              width: MediaQuery.of(context).size.width,
              height: 250,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Container(
                width: double.infinity,
                height: 850,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 244, 196, 166),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Thông báo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                            children: [
                              TextSpan(
                                  text: 'Mioto',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: ' xin thông báo về việc bổ sung '),
                              TextSpan(
                                  text: 'Chính sách bảo mật',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      ' liên quan đến các vấn đề mới trong việc bảo vệ dữ liệu cá nhân theo Nghị định 13/2023/NĐ-CP của Chính phủ Việt Nam.'),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5.0),
                        child: Text(
                          'Trong quá trình thiết lập mối quan hệ giữa Mioto và Người dùng, giữ các người dùng với nhau phụ thuộc vào từng loại hình dịch vụ mà chúng tôi cung cấp, Mioto có thể thu thập và xử lý dữ liệu cá nhân của Quý Khách hàng. Mioto cam kết đảm bảo an toàn và Bảo vệ dữ liệu cá nhân của Quý người dùng theo quy định của pháp luật Việt Nam.',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5.0),
                        child: Text(
                          'Theo đó bắt đầu từ ngày ra thông báo này, chúng tôi cần xác nhận lại sự đồng ý của bạn để tiếp tục thu thập, xử lý và chia sẻ dữ liệu cá nhân của bạn. Tuy nhiên, chúng tôi muốn nhắc nhở rằng nếu thu hồi sự đồng ý của mình, Quý Người dùng sẽ không thể tiếp cận với những người dùng khác trên nền tảng để phục vụ nhu cầu sử dụng dịch vụ của mình.',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5.0),
                        child: Text(
                          'Mioto hiểu rằng việc bảo vệ dữ liệu cá nhân là rất quan trọng, và chúng tôi cam kết tuân thủ Nghị định 13/2023/NĐ-CP và các quy định về bảo vệ dữ liệu liên quan khác. Bỏ qua thông tin này nếu bạn đồng ý để chia sẻ thông tin cá nhân của mình với các Người dùng khác trên nền tảng Mioto. Hoặc vào tài khoản của mình vào để thu hồi/xóa dữ liệu. Cảm ơn sự quan tâm của bạn về vấn đề này. Chúng tôi rất trân trọng và hy vọng sẽ có cơ hội tiếp tục hỗ trợ bạn trong tương lai.',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
