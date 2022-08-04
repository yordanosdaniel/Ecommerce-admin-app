// ignore_for_file: unnecessary_const

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project_admin/global_method.dart';
import 'package:demo_project_admin/screens/orders_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool _isOrder = false;
  GlobalMethods globalMethods = GlobalMethods();

  @override
  Widget build(BuildContext context) {
    return _isOrder
        ? Scaffold(
            body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/emptycart.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const Text(
                  'No orders yet!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ))
        : Scaffold(
            appBar: AppBar(
              title: const Text('Orders'),
            ),
            body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                // <2> Pass `Stream<QuerySnapshot>` to stream
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .orderBy('orderData', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // <3> Retrieve `List<DocumentSnapshot>` from snapshot
                    final List<DocumentSnapshot<Map<String, dynamic>>>
                        documents = snapshot.data!.docs;
                    return ListView(
                        children: documents
                            .map(
                              (doc) => Card(
                                child: ListTile(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OrderDetailScreen(
                                                orderIds: doc['orderId'],
                                              ))),
                                  title: Text(
                                    doc['name'],
                                  ),
                                  subtitle: Text(
                                    "Birr ${doc['TotalPricewithDelivery']}",
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  trailing: Text(
                                    doc['orderData'],
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList());
                  } else if (snapshot.hasError) {
                    return const Text("It's Error!");
                  }
                  return Container();
                }),
          );
  }
}
