import 'package:Digital_Assistance/Constants.dart';
import 'package:Digital_Assistance/screens/ViewImage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  final String name, phone, serviceArea, photourl, aadharCardPhotoUrl, service;
  Profile(this.name, this.phone, this.serviceArea, this.photourl,
      this.aadharCardPhotoUrl, this.service);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  callAction(String number) async {
    String url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      errorDialogue("Could not Call to $number", context);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[200],
        title: Text(widget.name),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ViewImage(widget.photourl, "Photo");
                    }));
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.photourl))),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.perm_identity),
                  title: Text(widget.name),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.phone),
                  title: Text(widget.phone),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Card(
                child: ListTile(
                  leading: Image.asset(
                    'assets/toolIcon.png',
                  ),
                  title: Text(widget.service),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.home),
                  title: Text(widget.serviceArea),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ViewImage(widget.aadharCardPhotoUrl, "Identity Proof");
                }));
              },
              child: Container(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'See ID proof',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.arrow_forward)
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CircleAvatar(
              backgroundColor: Colors.lightGreenAccent[400],
              radius: 30,
              child: Icon(
                Icons.call,
              ),
            )
          ],
        ),
      ),
    );
  }
}
