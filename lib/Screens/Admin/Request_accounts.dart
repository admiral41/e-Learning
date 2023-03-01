import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestedAccountsPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Request For Accounts",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 27,
              ),
            ),
            backgroundColor: Color.fromARGB(255, 21, 21, 21)),
        body: StreamBuilder(
            stream: _firestore.collection("pending_requests").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data?.docs[index].data();
                  return Container(
                    margin: EdgeInsets.all(10),
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Name: ${data!["name"]}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            SizedBox(height: 10),
                            Text("Email: ${data!["email"]}"),
                            SizedBox(height: 10),
                            Text("School Name: ${data!["school_name"]}"),
                            SizedBox(height: 10),
                            Text("Phone Number: ${data!["phone_number"]}"),
                            SizedBox(height: 10),
                            Text("Password: ${data!["password"]}"),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                ElevatedButton(
                                  child: Text("Accept"),
                                  onPressed: () async {
// Move user's information from pending_requests to users collection
                                    _firestore
                                        .collection("users")
                                        .doc(snapshot.data?.docs[index].id)
                                        .set({
                                      "name": data["name"],
                                      "school_name": data["school_name"],
                                      "email": data["email"],
                                      "phone_number": data["phone_number"],
                                      "password": data["password"],
                                      "role": "user",
                                    });
// Delete user's information from pending_requests collection
                                    await snapshot.data?.docs[index].reference
                                        .delete();
                                  },
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  child: Text("Reject"),
                                  onPressed: () async {
// Delete user's information from pending_requests collection
                                    await snapshot.data?.docs[index].reference
                                        .delete();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }));
  }
}
