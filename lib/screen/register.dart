import 'package:app_car_rental/screen/home_page.dart';
import 'package:app_car_rental/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:app_car_rental/const/authentication.dart';
class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phonenumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    phonenumberController.dispose();
  }
  void signupUser() async {
    // set is loading to true.
    setState(() {
      isLoading = true;
    });
    // signup user using our authmethod
    String res = await AuthMethod().signupUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        confirmPass: confirmPasswordController.text,
        phoneNumber: phonenumberController.text);
    // if string return is success, user has been creaded and navigate to next screen other witse show error.
    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      //navigate to the next screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Loginpage(fromPage: null,proId: null,),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      // show error
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
              height: 100,
              width: double.infinity,
              child: const Center(
                child: Text(
                  'Đăng ký tài khoản',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'Email',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF686D76)
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                child:
                TextField(
                  controller: emailController,
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Nhập Email",
                    labelStyle: TextStyle(
                        color: Color(0xFF686D76),
                        fontSize: 15
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'Số điện thoại',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF686D76)
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                )
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                child: TextFormField(
                  obscureText: false,
                  controller: phonenumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Nhập số điện thoại",
                    labelStyle: TextStyle(
                      color: Color(0xFF686D76),
                      fontSize: 15
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left : 16),
              child: Text(
                'Họ và tên',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF686D76)
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                child: TextFormField(
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Nhập họ và tên",
                    labelStyle: TextStyle(
                        color: Color(0xFF686D76),
                        fontSize: 15
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'Nhập mật khẩu',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF686D76)
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: "Nhập mật khẩu",
                    labelStyle: TextStyle(
                        color: Color(0xFF686D76),
                        fontSize: 15
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'Xác nhận mật khẩu',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF686D76)
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                child: TextFormField(
                  obscureText: true,
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: "Nhập mật khẩu",
                    labelStyle: TextStyle(
                        color: Color(0xFF686D76),
                        fontSize: 15
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.only(left: 45,),
              child: Column(
                children: [
                  Row(
                    children: [
                      RichText(
                          text: const TextSpan(
                            children: <TextSpan>
                            [
                              TextSpan(text: 'Tôi đã đọc và đồng ý với', style: TextStyle(color: Colors.black, fontSize: 15)),
                              TextSpan(text: ' Chính sách & quy định', style: TextStyle(color: Colors.green,fontSize: 15, fontWeight: FontWeight.bold)),
                              TextSpan(text: ' và', style: TextStyle(color: Colors.black)),
                            ]
                          )
                      )
                    ],
                  ),
                  Row(
                    children: [
                      RichText(
                          text: const TextSpan(
                              children: <TextSpan>
                              [
                                TextSpan(text: '     Chính sách bảo vệ dữ liệu cá nhân', style: TextStyle(color: Colors.green,fontSize: 15, fontWeight: FontWeight.bold)),
                                TextSpan(text: ' của Mioto', style: TextStyle(color: Colors.black,fontSize: 15)),
                              ]
                          )
                      )
                    ],
                  ),
                ],
              ),
            ),
             const SizedBox(
               height: 10,
             ),
             Container(
               padding: EdgeInsets.only(left: 20.0),
               child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5fcf86),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 150.0, vertical: 10.0),
                  ),
                    onPressed: signupUser,
                    child: const Text('Đăng ký', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                ),
             ),
          ],
        ),
      ),
    );
  }
}
