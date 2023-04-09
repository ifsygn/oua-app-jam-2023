import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oua_app_jam_project/view/peer_chat.dart';
import 'package:intl/intl.dart';
import 'package:oua_app_jam_project/view/profile.dart';

import '../logic/auth_manager.dart';

enum Proficiency { Flutter, Unity, Ingilizce }

enum MembershipStatus { Bursiyer, Mezun, Gorevli }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  List<Map<String, dynamic>>? userMapList = [];
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Auth authManager = Auth();

  int _proficiencyGroupValue = -1;
  int _membershipStatusGroupValue = -1;
  String? _proficiencyValue;
  String? _membershipValue;
  Proficiency? proficiencyGroupValue;
  MembershipStatus? membershipStatusGroupValue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Çevrimiçi");
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Çevrimiçi");
    } else {
      setStatus("Çevrimdışı");
    }
  }

  String chatRoomId(String user1, String user2) {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    if (user1[0].toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
      return "$user1 : $user2 ($formattedDate)";
    } else {
      return "$user2 : $user1 ($formattedDate)";
    }
  }

  void refreshSuggestions() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("proficiency", isEqualTo: _proficiencyValue)
        .where("membership", isEqualTo: _membershipValue)
        .get()
        .then((value) {
      setState(() {
        userMapList = value.docs.map((doc) => doc.data()).toList();
        print("********************************");
        print(userMapList);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text("Ana Sayfa"),
          actions: [
            IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
                }),
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  authManager.logout(context);
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height / 15,
              ),
              Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Uzmanlık Alanı', style: TextStyle(fontSize: 18, color: Colors.red)),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: RadioListTile(
                                      value: 0,
                                      groupValue: _proficiencyGroupValue,
                                      title: Text("Flutter", style: TextStyle(fontSize: 11, color: Colors.blue)),
                                      onChanged: (newValue) => setState(() {
                                        _proficiencyGroupValue = 0;
                                        _proficiencyValue =
                                            "Proficiency.Flutter";
                                      }),
                                      activeColor: Colors.red,
                                      selected: false,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: RadioListTile(
                                      value: 1,
                                      groupValue: _proficiencyGroupValue,
                                      title: Text("Unity", style: TextStyle(fontSize: 11, color: Colors.blue)),
                                      onChanged: (newValue) => setState(() {
                                        _proficiencyGroupValue = 1;
                                        _proficiencyValue = "Proficiency.Unity";
                                      }),
                                      activeColor: Colors.red,
                                      selected: false,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: RadioListTile(
                                      value: 2,
                                      groupValue: _proficiencyGroupValue,
                                      title: Text("Ingilizce", style: TextStyle(fontSize: 11, color: Colors.blue)),
                                      onChanged: (newValue) => setState(() {
                                        _proficiencyGroupValue = 2;
                                        _proficiencyValue = "Proficiency.Ingilizce";
                                      }),
                                      activeColor: Colors.red,
                                      selected: false,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height / 15,
                              ),
                              Text('Üyelik Durumu', style: TextStyle(fontSize: 18, color: Colors.red)),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Expanded(
                                      child: RadioListTile(
                                        value: 0,
                                        groupValue: _membershipStatusGroupValue,
                                        title: Text("Bursiyer", style: TextStyle(fontSize: 11, color: Colors.blue)),
                                        onChanged: (newValue) => setState(() {
                                          _membershipStatusGroupValue = 0;
                                          _membershipValue ="MembershipStatus.Bursiyer";
                                        }),
                                        activeColor: Colors.red,
                                        selected: false,
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioListTile(
                                        value: 1,
                                        groupValue: _membershipStatusGroupValue,
                                        title: Text("Mezun", style: TextStyle(fontSize: 11, color: Colors.blue)),
                                        onChanged: (newValue) => setState(() {
                                          _membershipStatusGroupValue = 1;
                                          _membershipValue ="MembershipStatus.Mezun";
                                        }),
                                        activeColor: Colors.red,
                                        selected: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  isLoading
                      ? Center(
                          child: Container(
                            height: size.height / 20,
                            width: size.height / 20,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Column(
                          children: [
                            Container(
                                height: 100,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      ElevatedButton(
                                          onPressed: refreshSuggestions,
                                          child: Text(
                                            "Üye Önerilerini Göster",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ])),
                            SizedBox(
                              height: size.height / 30,
                            ),
                            for(var userMap in userMapList!)...[
                            ListTile(
                                    onTap: () {
                                      String roomId = chatRoomId(
                                          _auth.currentUser!.displayName!,
                                          userMap!['name']);

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => PeerChat(
                                            chatRoomId: roomId,
                                            userMap: userMap!,
                                          ),
                                        ),
                                      );
                                    },
                                    leading: Icon(Icons.account_box,
                                        color: Colors.black),
                                    title: Text(
                                      userMap!['name'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(userMap!['email']),
                                    trailing:
                                        Icon(Icons.chat, color: Colors.black),
                                  )
                                  ]
                          ],
                        ),
                ],
              ),
            ],
          ),
        ));
  }
}