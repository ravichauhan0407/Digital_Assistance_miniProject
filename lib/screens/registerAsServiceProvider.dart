import 'dart:convert';
import 'dart:io';
import 'package:Digital_Assistance/database/firestoreFunction.dart';
import 'package:Digital_Assistance/database/sharedPrefference.dart';
import 'package:http/http.dart' as http;
import 'package:Digital_Assistance/Constants.dart';
import 'package:Digital_Assistance/screens/homePage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

class RegisterAsSP extends StatefulWidget {
  @override
  _RegisterAsSPState createState() => _RegisterAsSPState();
}

class _RegisterAsSPState extends State<RegisterAsSP> {
  String _photoUrl = "Upload Photo";
  String _adhaarPhotoUrl = "Upload Aadhaar Photo";
  String city = "City";
  String state = "State";
  String service = "Painter";
  String name = "name";

  TextEditingController pinCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  Future uploadImage() async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String fileName = basename(pickedFile.path);
      File file = File(pickedFile.path);

      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      reference.putFile(file).then((firebaseaFile) async {
        var downloadUrl = await firebaseaFile.ref.getDownloadURL();
        setState(() {
          _photoUrl = downloadUrl;
        });
      });
    }
  }

  Future uploadAdhaarImage() async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String fileName = basename(pickedFile.path);
      File file = File(pickedFile.path);

      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      reference.putFile(file).then((firebaseaFile) async {
        var downloadUrl = await firebaseaFile.ref.getDownloadURL();
        setState(() {
          _adhaarPhotoUrl = downloadUrl;
        });
      });
    }
  }

  getJsonData() async {
    if (pinCodeController.text.isNotEmpty) {
      String pincode = pinCodeController.text;
      var response = await http
          .get(Uri.encodeFull('https://api.postalpincode.in/pincode/$pincode'));

      var map = await jsonDecode(response.body);
      if (map[0]["Status"] == "Success") {
        setState(() {
          city = map[0]["PostOffice"][0]["District"];
          state = map[0]["PostOffice"][0]["State"];
        });
      } else {
        setState(() {
          city = "City";
          state = "State";
        });
      }
    }
  }

  getUserName() async {
    name = await Sharedpref.getUserNamePreference();
  }

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(
              top: 30, left: kDefaultPadding, right: kDefaultPadding),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    navigateToHomePage(context);
                  },
                  child: Container(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(colors: appColor)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Skip',
                            style: TextStyle(fontSize: 20),
                          ),
                          Icon(Icons.arrow_forward_sharp)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: pinCodeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Pincode',
                      labelStyle: TextStyle(color: Colors.teal[200]),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal[200])),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal[200]))),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: getJsonData,
                  child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(colors: appColor)),
                      child: Text(
                        'Click here',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text('City', style: TextStyle(fontSize: 15)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: kDefaultPadding, vertical: 5),
                  width: _width,
                  color: Colors.teal[200],
                  child: Text(
                    city,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text('State', style: TextStyle(fontSize: 15)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: kDefaultPadding, vertical: 5),
                  width: _width,
                  color: Colors.teal[200],
                  child: Text(state, style: TextStyle(fontSize: 20)),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text('Click here for Upload your  photo*',
                      style: TextStyle(fontSize: 15)),
                ),
                GestureDetector(
                  onTap: uploadImage,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    color: Colors.teal[50],
                    alignment: Alignment.centerLeft,
                    child: _photoUrl == "Upload Photo"
                        ? Text(_photoUrl, style: TextStyle(fontSize: 15))
                        : Row(
                            children: [
                              Text('Photo uploaded',
                                  style: TextStyle(fontSize: 15)),
                              Spacer(),
                              Icon(
                                Icons.check,
                                color: Colors.green[700],
                              )
                            ],
                          ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text('Click here for Upload Aadhaaar photo*',
                      style: TextStyle(fontSize: 15)),
                ),
                GestureDetector(
                  onTap: uploadAdhaarImage,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    color: Colors.teal[50],
                    alignment: Alignment.centerLeft,
                    child: _adhaarPhotoUrl == "Upload Aadhaar Photo"
                        ? Text(_adhaarPhotoUrl, style: TextStyle(fontSize: 15))
                        : Row(
                            children: [
                              Text('Aadhaar Photo uploaded',
                                  style: TextStyle(fontSize: 15)),
                              Spacer(),
                              Icon(
                                Icons.check,
                                color: Colors.green[700],
                              )
                            ],
                          ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    color: Colors.teal[200],
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: DropdownButton(
                        value: service,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          size: 20,
                        ),
                        items: kservices.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(
                              dropDownStringItem,
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            service = newValue;
                          });
                        })),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Phone',
                      prefixIcon: Icon(Icons.phone),
                      labelStyle: TextStyle(color: Colors.teal[200]),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal[200])),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal[200]))),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    saveUserInfo(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(colors: appColor)),
                      child: Text(
                        'Submit',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  saveUserInfo(context) {
    if (this._photoUrl != "Upload Photo" &&
        this._adhaarPhotoUrl != "Upload Aadhaar Photo" &&
        this.city != "City" &&
        this.state != "State" &&
        this.phoneNumberController.text.isNotEmpty) {
      Map<String, dynamic> userMap = {
        "aadhaarphotourl": this._adhaarPhotoUrl,
        "city": this.city,
        "name": this.name,
        "phone": this.phoneNumberController.text,
        "photourl": this._photoUrl,
        "state": this.state,
        "service": this.service
      };

      FirestoreFunction.addUserinCollection(userMap);
      navigateToHomePage(context);
    }
  }

  navigateToHomePage(context) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }), (route) => false);
  }
}
