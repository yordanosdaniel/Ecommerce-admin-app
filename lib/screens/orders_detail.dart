// ignore_for_file: unnecessary_const, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project_admin/global_method.dart';
import 'package:demo_project_admin/screens/confirm_shipment.dart';
import 'package:flutter/material.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderIds;
  const OrderDetailScreen({Key? key, required this.orderIds}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final double subtotal = 0.0;
  final double deliveryFee = 0.0;
  final double total = 0.0;

  bool _isOrder = false;
  bool _isConfirmed = false;
  GlobalMethods globalMethods = GlobalMethods();

  @override
  Widget build(BuildContext context) {
    bool _isLoading = false;
    // final orderProvider = Provider.of<OrderProvider>(context);
    // final order = Provider.of<Order>(context);

    Stream<DocumentSnapshot<Map<String, dynamic>>> courseDocStream =
        FirebaseFirestore.instance
            .collection('processing orders')
            .doc(widget.orderIds)
            .snapshots();
    setState(() {
      if (courseDocStream.length != 0) {
        _isOrder = true;
      }
    });

    return !_isOrder
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
              title: const Text('Orders Detail'),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<DocumentSnapshot>(
                    stream: courseDocStream,
                    // future: orderProvider.getData(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        // get course document
                        var courseDocument = snapshot.data!;

                        // get deliveryinfo from the document
                        var sections = courseDocument['ordered products'];
                        var deliveryinfo =
                            courseDocument['delivery information'];
                        var customerInfo =
                            courseDocument['customer information'];

                        return Column(children: [
                          Container(
                            height: 330,
                            margin: const EdgeInsets.only(bottom: 60),
                            child: ListView.builder(
                              itemCount: sections != null ? sections.length : 0,
                              itemBuilder: (ctx, i) {
                                return InkWell(
                                  onTap: () {},
                                  // Navigator.of(context).pushNamed(
                                  //   ProductDetailsScreen.routeName,
                                  // arguments: widget.pId,

                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      width: double.infinity,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2, color: Colors.grey),
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 130,
                                            decoration: BoxDecoration(
                                              color: Colors.purple[200],
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    sections[i]['image']),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        sections[i]['title'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 7),
                                                Row(
                                                  children: [
                                                    const Text(
                                                      'Subtotal : ',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        (sections[i]['price'] *
                                                                sections[i][
                                                                    'quantity'])
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Text(
                                                      'Quantity : ',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        sections[i]['quantity']
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            color: Colors.purple[100],
                            height: 270,
                            width: double.infinity,
                            child: SingleChildScrollView(
                              child: Container(
                                child: Column(
                                  children: [
                                    const Text(
                                      "Delivery Informartion",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.person,
                                        color: Colors.deepPurple,
                                      ),
                                      title: const Text(
                                        "Customer Information",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Full Name: " +
                                                customerInfo['name'],
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Text(
                                            "Email: " + customerInfo['email'],
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Text(
                                            "Phone Number: ${customerInfo['phoneNumber']}",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.calculate_outlined,
                                        color: Colors.deepPurple,
                                      ),
                                      title: const Text(
                                        "Price Detail",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Subtotal: " +
                                                courseDocument['subtotal']
                                                    .toString(),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Text(
                                            "Delivery Fee: " +
                                                courseDocument['deliveryFee']
                                                    .toString(),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Text(
                                            "Total: " +
                                                courseDocument[
                                                        'TotalPricewithDelivery']
                                                    .toString(),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.location_on,
                                        color: Colors.deepPurple,
                                      ),
                                      title: const Text(
                                        "Location",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "City: " + deliveryinfo['city'],
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Text(
                                            "Subcity: " +
                                                deliveryinfo['subCity'],
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Text(
                                            "street: " + deliveryinfo['street'],
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: 30,
                                    // ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ConfirmShipment(
                                                    orderId: courseDocument[
                                                        'orderId']),
                                          ),
                                        );
                                        setState(() {
                                          _isConfirmed = true;
                                        });
                                      },
                                      child: _isConfirmed
                                          ? Container(
                                              alignment: Alignment.center,
                                              height: 45,
                                              color: Colors.purple,
                                              child: const Text(
                                                'Confirm Shipment',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25),
                                              ),
                                            )
                                          //  Container(
                                          //     alignment: Alignment.center,
                                          //     height: 45,
                                          //     color: Colors.purple[200],
                                          //     child: const Text(
                                          //       'Confirmed',
                                          //       style: TextStyle(
                                          //           color: Colors.white,
                                          //           fontWeight: FontWeight.bold,
                                          //           fontSize: 25),
                                          //     ),
                                          //   )
                                          : Container(
                                              alignment: Alignment.center,
                                              height: 45,
                                              color: Colors.purple,
                                              child: const Text(
                                                'Confirm Shipment',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ]);
                      }

                      return Container();
                    })
              ],
            ));
  }
}
