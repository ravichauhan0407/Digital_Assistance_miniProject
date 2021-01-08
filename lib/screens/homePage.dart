import 'dart:convert';
import 'package:Digital_Assistance/database/sharedPrefference.dart';
import 'package:Digital_Assistance/screens/suggestedWorkers.dart';
import 'package:Digital_Assistance/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = "Enter Location";
  String city = "city";
  String state = "state";
  TextEditingController pinCodeController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  authChange() async {
    _auth.authStateChanges().listen((event) async {
      if (event == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return Authentication();
        }), (route) => false);
      }
    });
  }

  getJsonData() async {
    if (pinCodeController.text.isNotEmpty) {
      String pincode = pinCodeController.text;
      var response = await http
          .get(Uri.encodeFull('https://api.postalpincode.in/pincode/$pincode'));

      var map = await jsonDecode(response.body);
      if (map[0]["Status"] == "Success") {
        setState(() {
          location = map[0]["PostOffice"][0]["District"] +
              ',' +
              map[0]["PostOffice"][0]["State"];
          state = map[0]["PostOffice"][0]["State"];
          city = map[0]["PostOffice"][0]["District"];
          saveLocationBySharedPref();
        });
      } else {
        errorDialogue("Invalid Pincode", context);
      }
    } else {
      errorDialogue("Invalid Pincode", context);
    }
  }

  saveLocationBySharedPref() {
    Sharedpref.saveCityPreference(city);
    Sharedpref.saveStatePreference(state);
    Sharedpref.saveLocationPreference(location);
  }

  signOut() {
    _auth.signOut();
  }

  getLocationBySharedPref() async {
    var kcity = await Sharedpref.getCityPreference();
    var kstate = await Sharedpref.getStatePreference();
    var klocation = await Sharedpref.getLocationPreference();
    if (kcity != null) {
      setState(() {
        city = kcity;
        state = kstate;
        location = klocation;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLocationBySharedPref();
    authChange();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Colors.teal[50],
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              ListTile(
                trailing: IconButton(
                  onPressed: signOut,
                  icon: Icon(Icons.exit_to_app),
                ),
                title: Text('Sign Out'),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Easy Service'),
        backgroundColor: Colors.teal[200],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.teal[300],
            leading: IconButton(
              onPressed: getLocation,
              icon: Icon(Icons.location_pin),
            ),
            flexibleSpace: FlexibleSpaceBar(
                title: Text(
              location,
              style: TextStyle(fontSize: 20),
            )),
          ),
          SliverToBoxAdapter(
              child: Divider(
            color: Colors.black26,
            thickness: 20,
          )),
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Quick Services',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SliverGrid.count(
            crossAxisCount: 2,
            children: [
              buildImageCard(
                  'assets/fridgeRepair.png', "Refrigerator Mechanic"),
              buildImageCard(
                'assets/geyserRepair.png',
                "Geyser Mechanic",
              ),
              buildImageCard(
                'assets/roRepair.jpg',
                "R.O. Mechanic",
              ),
              buildImageCard(
                  'assets/washingMachineRepair.jpg', "WashingMachine Mechanic"),
            ],
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
          SliverToBoxAdapter(
              child: Divider(
            color: Colors.black26,
            thickness: 20,
          )),
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Other Services',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SliverGrid.count(
            crossAxisCount: 2,
            children: [
              buildImageCard('assets/painter.jpg', 'Painter'),
              buildImageCard('assets/plumber.jpg', 'Plumber'),
              buildImageCard('assets/electrician.jpg', 'Electrician'),
              buildImageCard('assets/carpenter.jpg', 'Carpenter'),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              width: 300,
              height: 300,
              child: appLogo(),
            ),
          ),
        ],
      ),
    );
  }

  Card buildImageCard(image, String service) {
    return Card(
        child: GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Workers(this.city, this.state, service);
        })).then((value) {
          getLocationBySharedPref();
        });
      },
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage(image),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                service,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  getLocation() async {
    bool k = await modalsheet();
    if (k == true) {
      getJsonData();
    }
  }

  modalsheet() {
    return showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Enter a Pincode*',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextField(
                    controller: pinCodeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                          horizontal: kDefaultPadding, vertical: 4.0),
                      child: Text(
                        'Apply',
                        style: TextStyle(fontSize: 25),
                      ),
                      decoration: BoxDecoration(color: Colors.yellow[700]),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
// ClipRRect(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(8.0),
//                 topRight: Radius.circular(8.0),
//               ),
//   child: Image.asset(
//     'assets/geyserRepair.jpg',
//     height: 250,
//     width: size.width * 0.5 - 10,
//   ),
// ),
