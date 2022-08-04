// ignore_for_file: unused_field

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project_admin/global_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

class UploadProducts extends StatefulWidget {
  const UploadProducts({Key? key}) : super(key: key);

  @override
  State<UploadProducts> createState() => _UploadProductsState();
}

class _UploadProductsState extends State<UploadProducts> {
  var _productTitle = "";
  var _productDescription = "";
  var _productPrice = "";

  final _formKey = GlobalKey<FormState>();
  String _url = '';
  var uuid = const Uuid();

  FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalMethods _globalMethods = GlobalMethods();
  bool _isLoading = false;

  File? _image;
  _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
    }
    try {
      if (_image == null) {
        return _globalMethods.showDialogues(context, 'Please provide an image');
      } else {
        setState(() {
          _isLoading = true;
        });

        final ref = FirebaseStorage.instance
            .ref()
            .child('product')
            .child(_productTitle + '.jpg');
        await ref.putFile(_image!);
        _url = await ref.getDownloadURL();

        final productId = uuid.v4();
        // final User? user = _auth.currentUser;
        // final _uid = user!.uid;
        FirebaseFirestore.instance.collection('products').doc(productId).set({
          'title': _productTitle,
          'description': _productDescription,
          'price': _productPrice,
          'image': _url,
          'id': productId,
          'createdAt': Timestamp.now()
        });

        Navigator.pop(context);
        _globalMethods.showDialogues(context, "Successfully Added.");
      }
    } catch (e) {
      _globalMethods.showDialogues(context, e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future _getGalleryImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image!.path);
    });
  }

  Future _getCameraImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      _image = File(image!.path);
    });
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Products"),
        elevation: 0,
      ),
      bottomSheet: SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: _trySubmit,
          child: Container(
            alignment: Alignment.center,
            height: 45,
            color: Colors.purple,
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.white,
                  ))
                : const Text(
                    'A D D',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _image == null
                            ? Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 2, color: Colors.grey),
                                ),
                                // ignore: prefer_const_constructors

                                //   child: Image(
                                //       image: AssetImage("assets/empty_gal.jpg")),
                              )
                            : Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 2, color: Colors.grey),
                                ),
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.contain,
                                ),
                              ),
                      ),
                      Column(
                        children: [
                          TextButton.icon(
                            onPressed: _getCameraImage,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Camera'),
                          ),
                          TextButton.icon(
                            onPressed: _getGalleryImage,
                            icon: const Icon(Icons.image),
                            label: const Text('Gallery'),
                          ),
                          TextButton.icon(
                            onPressed: _removeImage,
                            icon: const Icon(Icons.remove_circle),
                            label: const Text('Remove'),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: TextFormField(
                          key: const ValueKey('title'),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(labelText: 'Title'),
                          onSaved: (val) {
                            _productTitle = val.toString();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          key: const ValueKey('price'),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Price is missing';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration:
                              const InputDecoration(labelText: 'Price Birr'),
                          onSaved: (val) {
                            _productPrice = val.toString();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),

                  const SizedBox(height: 15),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   crossAxisAlignment: CrossAxisAlignment.end,
                  //   children: [
                  //     Expanded(
                  //       //flex: 2,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(right: 9),
                  //         child: TextFormField(
                  //           keyboardType: TextInputType.number,
                  //           key: const ValueKey('Quantity'),
                  //           validator: (value) {
                  //             if (value!.isEmpty) {
                  //               return 'Quantity is missed';
                  //             }
                  //             return null;
                  //           },
                  //           decoration: const InputDecoration(
                  //             labelText: 'Quantity',
                  //           ),
                  //           onSaved: (value) {
                  //             _productQuantity = value.toString();
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 15),
                  TextFormField(
                      key: const ValueKey('Description'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'product description is required';
                        }
                        return null;
                      },
                      //controller: this._controller,
                      maxLines: 10,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        //  counterText: charLength.toString(),
                        labelText: 'Description',
                        hintText: 'Product description',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _productDescription = value.toString();
                      },
                      onChanged: (text) {
                        // setState(() => charLength -= text.length);
                      }),
                  //    SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
