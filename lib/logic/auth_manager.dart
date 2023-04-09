import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oua_app_jam_project/view/home.dart';
import 'package:oua_app_jam_project/view/login.dart';

class Auth extends StatelessWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return Home();
    } else {
      return Login();
    }
  }

  Future<User?> createUser(String name, String surname, String email, String password, String gender, String proficiency, String membership, String status, BuildContext context) async {

    FirebaseAuth _auth = this._auth;
    FirebaseFirestore _firestore = this._firestore;

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      userCredential.user!.updateDisplayName(name);
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        "uid": _auth.currentUser!.uid,
        "name": name,
        "surname": surname,
        "email": email,
        "password": password,
        "gender": gender,
        "proficiency": proficiency,
        "status": status,
        "membership": membership
      });
      Navigator.pop(context);
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> login(String email, String password, BuildContext context) async {

    FirebaseAuth _auth = this._auth;
    FirebaseFirestore _firestore = this._firestore;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) => userCredential.user!.updateDisplayName(value['name']));
      Navigator.push(context, MaterialPageRoute(builder: (_) => Home()));
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future logout(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      await _auth.signOut().then((value) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => Login()));
      });
    } catch (e) {
      print("error");
    }
  }
}
