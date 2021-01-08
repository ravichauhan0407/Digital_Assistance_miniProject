import 'package:flutter/material.dart';

class ViewImage extends StatefulWidget {
  final String photo, title;
  ViewImage(this.photo, this.title);
  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.teal[200],
      ),
      body: Container(
        child: Image(
          image: NetworkImage(widget.photo),
        ),
      ),
    );
  }
}
