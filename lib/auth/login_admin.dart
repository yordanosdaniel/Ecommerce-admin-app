// ignore_for_file: prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_element, prefer_final_fields, no_leading_underscores_for_local_identifiers, unnecessary_null_comparison, avoid_print, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project_admin/auth/signup_admin.dart';
import 'package:demo_project_admin/global_method.dart';
import 'package:demo_project_admin/screens/admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';

  const Login({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _Login();
  }
}

class _Login extends State<Login> {
  void _chanageVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalMethods _globalMethods = GlobalMethods();

  String _email = '';
  String _password = '';
  String role = '';
  String _uid = '';

  bool _isVisible = false;
  bool _isLoading = false;

  // authorizedAccess() async {
  //   FirebaseFirestore.instance
  //       .collection('user')
  //       .where('uid', isEqualTo: _uid)
  //       .get()
  //       .then((doc) {
  //     if (doc.docs[0].exists) {
  //       if (doc.docs[0].get('role') == 'admin') {

  //     } else {
  //       print('not admin');
  //     }
  //   });
  // }

  void _submitData() async {
    final _isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();

      try {
        // authorizedAccess();
        final newUser = await _auth.signInWithEmailAndPassword(
            email: _email.toLowerCase().trim(),
            password: _password.toLowerCase().trim());
        if (newUser != null) {
          User? user = _auth.currentUser;
          _uid = user!.uid;
          final DocumentSnapshot result = await FirebaseFirestore.instance
              .collection('users')
              .doc(_uid)
              .get();

          String role = result.get('role');
          if (role == 'admins') {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Admin()),
            );
          } else {
            _globalMethods.showDialogues(
                context, 'It is not an admin account.');
          }
        }
        print("logged in");
      } catch (e) {
        if (mounted) {
          _globalMethods.showDialogues(context, e.toString());
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: const Icon(Icons.arrow_back_ios),
          title: const Text(
            "Log In",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80.0, vertical: 10.0),
                      child: const CircleAvatar(
                        backgroundImage: AssetImage(
                          "assets/logo.jpg",
                        ),
                        radius: 70,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const Text(
                      "Please enter your login credentials",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Form(
                  key: _formKey,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        userInputWidget(),
                        const SizedBox(
                          height: 10,
                        ),
                        passwordInputWidget(),
                        const SizedBox(
                          height: 10,
                        ),
                        forgetPassword(),
                        // const SizedBox(
                        //   height: 3,
                        // ),
                        loginButton(context),
                        // const SizedBox(
                        //   height: 3,
                        // ),
                        Sign_up(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget userInputWidget() {
    return TextFormField(
      onSaved: (value) {
        _email = value!;
      },
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_passwordFocusNode),
      keyboardType: TextInputType.emailAddress,
      key: const ValueKey('email'),
      validator: (value) {
        if (value!.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        prefixIcon: const Icon(Icons.email),
      ),
    );
  }

  Widget passwordInputWidget() {
    return TextFormField(
      focusNode: _passwordFocusNode,
      onSaved: (value) {
        _password = value!;
      },
      onEditingComplete: _submitData,
      obscureText: !_isVisible,
      key: const ValueKey('password'),
      validator: (value) {
        if (value!.isEmpty || value.length < 6) {
          return 'Password must be atleast 6 units';
        }
        return null;
      },
      decoration: InputDecoration(
        // labelStyle: const TextStyle(
        //     fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
        labelText: "Password",
        // hintText: "Password",
        // floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
          icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }

  Widget forgetPassword() {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: GestureDetector(
        onTap: () {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => ResetPassword()));
        },
        child: Container(
          alignment: Alignment.bottomRight,
          child: const Text(
            "forgot password?",
            style: TextStyle(
                fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget loginButton(BuildContext _context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(100),
            ),
            child: MaterialButton(
              onPressed: _submitData,
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => ProductMainPage()));

              child: const Center(
                child: Text("SIGN IN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center),
              ),
            ),
          );
  }

  Widget Sign_up(BuildContext _context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Not a member? ",
          style: TextStyle(
              fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 2,
        ),
        GestureDetector(
          child: const Text(
            " Register now.",
            style: TextStyle(
                fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Signup()));
          },
        ),
      ],
    );
  }
}
