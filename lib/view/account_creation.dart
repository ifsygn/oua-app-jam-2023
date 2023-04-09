import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oua_app_jam_project/logic/auth_manager.dart';

class AccountCreation extends StatefulWidget {
  const AccountCreation({Key? key}) : super(key: key);

  @override
  State<AccountCreation> createState() => _AccountCreationState();
}

class _AccountCreationState extends State<AccountCreation> {
  List<String> genderList = <String>['Erkek', 'Kadin'];
  List<String> proficiencyList = <String>['Flutter', 'Unity', "Ingilizce"];
  List<String> membershipStatusList = <String>['Bursiyer', 'Mezun', 'Gorevli'];

  String? genderDropdownValue;
  String? proficiencyListDropdownValue;
  String? membershipStatusListDropdownValue;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Auth authManager = Auth();
  UserCredential? authenticatedUser;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenSize.height / 15,
            ),
            Container(
              alignment: Alignment.center,
              width: screenSize.width / 1.3,
              child: const Text(
                "Oyun ve Uygulama Akademisi\nHesap Oluştur",
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
                child: genericInputField(screenSize, "İsim", nameController)),
            SizedBox(
              height: screenSize.height / 20,
            ),
            Container(
                alignment: Alignment.center,
                child: genericInputField(
                    screenSize, "Soyisim", surnameController)),
            SizedBox(
              height: screenSize.height / 20,
            ),
            Container(
                alignment: Alignment.center,
                child:
                    genericInputField(screenSize, "E-posta", emailController)),
            SizedBox(
              height: screenSize.height / 20,
            ),
            Container(
                alignment: Alignment.center,
                child:
                    genericInputField(screenSize, "Şifre", passwordController)),
            SizedBox(
              height: screenSize.height / 30,
            ),
            DropdownButton<String>(
              value: genderDropdownValue,
              icon: const Icon(Icons.arrow_downward),
              hint: Text("Cinsiyet"),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  genderDropdownValue = value!;
                });
              },
              items: genderList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(
              height: screenSize.height / 30,
            ),
            DropdownButton<String>(
              value: proficiencyListDropdownValue,
              icon: const Icon(Icons.arrow_downward),
              hint: Text("Çalışma Alanı"),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.orange,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  proficiencyListDropdownValue = value!;
                });
              },
              items:
                  proficiencyList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(
              height: screenSize.height / 30,
            ),
            DropdownButton<String>(
              value: membershipStatusListDropdownValue,
              icon: const Icon(Icons.arrow_downward),
              hint: Text("Üyelik Durumu"),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.green,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  membershipStatusListDropdownValue = value!;
                });
              },
              items: membershipStatusList
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(
              height: screenSize.height / 30,
            ),
            Container(
                alignment: Alignment.center,
                child: completeRegistrationButton(screenSize)),
          ],
        ),
      ),
    );
  }

  Widget genericInputField(Size size, String hintText, TextEditingController controller) {
    return Container(
      height: size.height / 14,
      width: size.width / 1.2,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }

  Widget completeRegistrationButton(Size size) {
    return GestureDetector(
      onTap: () {
        authManager.createUser(
            nameController.text,
            surnameController.text,
            emailController.text,
            passwordController.text,
            "Gender.$genderDropdownValue",
            "Proficiency.$proficiencyListDropdownValue",
            "MembershipStatus.$membershipStatusListDropdownValue",
            "Çevrimdışı",
            context);
      },
      child: Container(
          height: size.height / 20,
          width: size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.green,
          ),
          alignment: Alignment.center,
          child: const Text(
            "Kaydı Tamamla",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }
}
