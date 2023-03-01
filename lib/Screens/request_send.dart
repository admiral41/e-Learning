import 'package:flutter/material.dart';
class RequestSentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Sent"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 100.0,
          ),
          SizedBox(height: 10.0),
          Text(
            "Your request has been sent",
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 10.0),
          Text(
            "Please wait for the admin to confirm your request",
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}
