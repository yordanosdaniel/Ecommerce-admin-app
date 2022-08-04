// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project_admin/screens/add_product.dart';
import 'package:demo_project_admin/screens/orders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  MaterialColor active = Colors.deepPurple;
  MaterialColor notActive = Colors.grey;

  FirebaseAuth _auth = FirebaseAuth.instance;
  String _url = "";
  String _uid = "";
  String _email = "";
  String _name = "";

  void _getData() async {
    User? user = _auth.currentUser;
    _uid = user!.uid;

    final DocumentSnapshot userDocs =
        await FirebaseFirestore.instance.collection("admins").doc(_uid).get();
    setState(() {
      _email = userDocs.get('email');
      _name = userDocs.get('name');
      _url = userDocs.get("imageUrl");
    });
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 25),
            child: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _loadScreen(),
      drawer: Drawer(
        width: 250,
        backgroundColor: Colors.deepPurple[100],
        child: ListView(
          children: [
            Container(
              height: 220,
              child: DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        _url,
                      ),
                      radius: 50,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _name,
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          _email,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 3,
              color: Colors.purple,
            ),
            InkWell(
              onTap: () async {
                await _auth.signOut();
              },
              child: ListTile(
                title: const Text("Log out"),
                leading: Icon(
                  Icons.logout,
                  color: Colors.deepPurple[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadScreen() {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text("Add new product"),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UploadProducts()));
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.change_history),
          title: const Text("Products list"),
          onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const UploadProducts()));
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.shopping_cart_checkout_outlined),
          title: const Text("New Orders"),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const OrderScreen()));
          },
        ),
        const Divider(),
      ],
    );
  }
}
