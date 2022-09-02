// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project_admin/auth/change_pasword_page.dart';
import 'package:demo_project_admin/auth/login_admin.dart';
import 'package:demo_project_admin/screens/add_packages.dart';
import 'package:demo_project_admin/screens/add_product.dart';
import 'package:demo_project_admin/screens/orders.dart';
import 'package:demo_project_admin/screens/package_list.dart';
import 'package:demo_project_admin/screens/product_list.dart';
import 'package:demo_project_admin/screens/reported_orders.dart';
import 'package:demo_project_admin/welcome_page.dart';
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
        await FirebaseFirestore.instance.collection("users").doc(_uid).get();
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
          GestureDetector(
            onTap: () {
              _auth.signOut();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
              print("signed out");
            },
            child: Container(
              margin: const EdgeInsets.only(right: 25),
              child: const Icon(Icons.logout),
            ),
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
            GestureDetector(
              onTap: () async {},
              child: ListTile(
                onTap: (() async {
                  await _auth.signOut();
                  Navigator.pop(context);
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                }),
                title: const Text("Log out"),
                leading: Icon(
                  Icons.logout,
                  color: Colors.deepPurple[800],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChangePassword()));
              },
              child: ListTile(
                title: const Text("Change Password"),
                leading: Icon(
                  Icons.person,
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
        const Divider(),
        ListTile(
          leading: Stack(
            children: const [
              Positioned(
                child: Icon(
                  Icons.shopping_cart_checkout_outlined,
                  color: Colors.red,
                ),
              ),
              // Positioned(
              //   top: 0,
              //   right: 0,
              //   child: Text(
              //     "2",
              //     style: TextStyle(
              //         color: Colors.red,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 18),
              //   ),
              // ),
            ],
          ),
          title: const Text("New Orders"),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const OrderScreen()));
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.replay,
            color: Colors.purple,
          ),
          title: const Text("Replied Orders"),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ReportedOrders()));
          },
        ),
        const Divider(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        ListTile(
          leading: const Icon(
            Icons.shopping_basket_outlined,
            color: Colors.orange,
          ),
          title: const Text("Add new product packages"),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UploadPackages()));
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(
            Icons.add,
            color: Colors.teal,
          ),
          title: const Text("Add new single product"),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UploadProducts()));
          },
        ),
        const Divider(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        ListTile(
          leading: const Icon(
            Icons.change_history,
            color: Colors.brown,
          ),
          title: const Text("Products list"),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProductList()));
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(
            Icons.list,
            color: Colors.pinkAccent,
          ),
          title: const Text("Package list"),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const PackageList()));
          },
        ),
        const Divider(),
      ],
    );
  }
}
