import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oua_app_jam_project/view/account_creation.dart';
import 'package:oua_app_jam_project/logic/auth_manager.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Auth authManager = Auth();
  UserCredential? authenticatedUser;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: screenSize.height / 15,
          ),
          Container(
            alignment: Alignment.center,
            width: screenSize.width / 1.3,
            child: const Text(
              "Oyun ve Uygulama Akademisi",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: screenSize.height / 20,
          ),
          Container(
              alignment: Alignment.center,
              child: genericInputField(
                  screenSize, "E-mail", Icons.email, emailController)),
          SizedBox(
            height: screenSize.height / 20,
          ),
          Container(
              alignment: Alignment.center,
              child: genericInputField(
                  screenSize, "Şifre", Icons.password, passwordController)),
          SizedBox(
            height: screenSize.height / 20,
          ),
          Container(
              alignment: Alignment.center, child: loginButton(screenSize)),
          SizedBox(
            height: screenSize.height / 20,
          ),
          Container(
              alignment: Alignment.center, child: registerButton(screenSize)),
        ],
      ),
    );
  }

  Widget genericInputField(Size size, String hintText, IconData icon, TextEditingController controller) {
    return Container(
      height: size.height / 14,
      width: size.width / 1.2,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }

  Widget loginButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (emailController.text.isNotEmpty &&
            passwordController.text.isNotEmpty) {
          authManager.login(
              emailController.text, passwordController.text, context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Container(
              padding: const EdgeInsets.all(8),
              height: 70,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: const Center(
                child:
                    Text('Lütfen e-posta ve şifre alanlarını kontrol ediniz!'),
              ),
            ),
          ));
        }
      },
      child: Container(
          height: size.height / 14,
          width: size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.blue,
          ),
          alignment: Alignment.center,
          child: const Text(
            "Giriş Yap",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }

  Widget registerButton(Size size) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => AccountCreation()));
      },
      child: Container(
          height: size.height / 14,
          width: size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.green,
          ),
          alignment: Alignment.center,
          child: const Text(
            "Hesap Oluştur",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }
}
