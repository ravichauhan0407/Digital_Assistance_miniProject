import 'dart:convert';

import 'package:Digital_Assistance/database/firestoreFunction.dart';
import 'package:Digital_Assistance/database/sharedPrefference.dart';
import 'package:Digital_Assistance/screens/viewWorkerProfile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../Constants.dart';

class Workers extends StatefulWidget {
  final String city, state, service;
  Workers(this.city, this.state, this.service);
  @override
  _WorkersState createState() =>
      _WorkersState(this.city, this.state, this.service);
}

class _WorkersState extends State<Workers> {
  String city, state, service;
  _WorkersState(this.city, this.state, this.service);
  String location;
  TextEditingController pinCodeController = TextEditingController();

  QuerySnapshot snapshot;
  getWorkers() async {
    var k = await FirestoreFunction.getUsers(city, state, service);
    setState(() {
      snapshot = k;
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

  @override
  void initState() {
    super.initState();
    getWorkers();
  }

  @override
  Widget build(BuildContext context) {
    location = city == "city" ? "Enter Location" : city + ',' + state;
    return Scaffold(
      appBar: AppBar(
        title: Text(service),
        backgroundColor: Colors.teal[200],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.teal[300],
            leading: IconButton(
              icon: Icon(Icons.location_pin),
              onPressed: getLocation,
            ),
            flexibleSpace: FlexibleSpaceBar(
                title: Text(
              location,
              style: TextStyle(fontSize: 20),
            )),
          ),
          buildList(),
          SliverToBoxAdapter(
            child: Divider(
              color: Colors.black26,
              thickness: 5,
            ),
          )
        ],
      ),
    );
  }

  Widget buildList() {
    return snapshot != null
        ? SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    // name,phone,serviceArea,photourl,aadharCardPhotoUrl
                    return Profile(
                        snapshot.docs[index].get("name"),
                        snapshot.docs[index].get("phone"),
                        snapshot.docs[index].get("city") +
                            ',' +
                            snapshot.docs[index].get("state"),
                        snapshot.docs[index].get("photourl"),
                        snapshot.docs[index].get("aadhaarphotourl"),
                        service);
                  }));
                },
                child: Column(
                  children: [
                    Divider(
                      color: Colors.black26,
                      thickness: 5,
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 30.0,
                        backgroundImage:
                            NetworkImage(snapshot.docs[index].get("photourl")),
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text(
                        snapshot.docs[index].get("name") + '| ' + service,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      subtitle: Text(
                          'Mobile No.${snapshot.docs[index].get("phone")}'),
                    ),
                  ],
                ),
              ),
            );
          }, childCount: snapshot.docs.length))
        : SliverToBoxAdapter(child: Container());
  }

  getLocation() async {
    bool k = await modalsheet();
    if (k == true) {
      await getJsonData();
      getWorkers();
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
