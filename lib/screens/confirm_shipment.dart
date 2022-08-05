import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project_admin/global_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';

class ConfirmShipment extends StatefulWidget {
  final String orderId;
  const ConfirmShipment({Key? key, required this.orderId}) : super(key: key);

  @override
  State<ConfirmShipment> createState() => _ConfirmShipmentState();
}

class _ConfirmShipmentState extends State<ConfirmShipment> {
  FocusNode numberOfDaysTakeToDeliverFoucusNode = FocusNode();
  late String numberOfDaysTakeToDeliver;
  String message = '';
  GlobalMethods _globalMethods = GlobalMethods();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    numberOfDaysTakeToDeliverFoucusNode.dispose();

    super.dispose();
  }

  void sendMessage(_phoneNumber) async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      List<String> phoneNumber = [_phoneNumber.toString()];
      sendSMS(message: message, recipients: phoneNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot<Map<String, dynamic>>> courseDocStream =
        FirebaseFirestore.instance
            .collection('orders')
            .doc(widget.orderId)
            .snapshots();

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Confirmation message for Customer',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: TextFormField(
              //     initialValue: '3',
              //     onSaved: (value) {
              //       numberOfDaysTakeToDeliver = value!;
              //     },
              //     textInputAction: TextInputAction.next,
              //     keyboardType: TextInputType.number,
              //     onEditingComplete: () => FocusScope.of(context)
              //         .requestFocus(numberOfDaysTakeToDeliverFoucusNode),
              //     key: const ValueKey('days'),
              //     validator: (value) {
              //       if (value!.isEmpty) {
              //         return 'Please enter how many days does it take to deliver?';
              //       }
              //       return null;
              //     },
              //     decoration: InputDecoration(
              //       labelText: 'How many days does it take to deliver?',
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(0),
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 15,
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: courseDocStream,
                // future: orderProvider.getData(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    var document = snapshot.data!;

                    var customerInfo = document['customer information'];
                    var name = customerInfo['name'];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            initialValue:
                                "Dear $name thank you for ordering our products on Bj Etherbal App. Your orders will be delivered after 3 days.\n\n \n Thank you! \nEtherbal magnifies beauty!",
                            key: const ValueKey('message'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Message is required';
                              }
                              return null;
                            },
                            maxLines: 10,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              labelText: ' Message',
                              hintText: 'Message',
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (value) {
                              message = value!;
                            },
                          ),
                        ),
                        MaterialButton(
                          color: Colors.deepPurple[800],
                          onPressed: () async {
                            var recipients = customerInfo['phoneNumber'];

                            sendMessage(recipients);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Send',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
