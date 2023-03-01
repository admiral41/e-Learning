import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewAndRemoveUsers extends StatefulWidget {
  @override
  _ViewAndRemoveUsersState createState() => _ViewAndRemoveUsersState();
}

class _ViewAndRemoveUsersState extends State<ViewAndRemoveUsers> {
  late String _searchQuery;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchQuery = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        centerTitle: true,
        title: Text("View & Remove Users"),
          backgroundColor: Color.fromARGB(255,21, 21, 21)
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Search users",
                  prefixIcon: Icon(Icons.search, color: Colors.blue,),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide.none)),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<DocumentSnapshot> filteredData = snapshot.data!.docs;
                if (_searchQuery != null && _searchQuery.isNotEmpty) {
                  filteredData = filteredData
                      .where((user) => (user.data() as Map<String, dynamic>)["name"] != null && (user.data() as Map<String, dynamic>)["name"].toString().toLowerCase().contains(_searchQuery.toLowerCase()))
                      .toList();
                }
                return filteredData.length > 0 ?
                ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    var data = filteredData[index];
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                    child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                    title: Text(data["name"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                      subtitle: Text("Email: ${data["email"]} | Role: ${data["role"]}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await FirebaseFirestore.instance.collection("users").doc(data.id).delete();


                        },
                      ),
                    )
                    )
                    );
                  },
                )
                    : Center(child: Text("No data found"));
              },
            ),
          ),
        ],
      ),
    );
  }
}