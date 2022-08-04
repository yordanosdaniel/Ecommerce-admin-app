import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project_admin/screens/add_packages.dart';
import 'package:demo_project_admin/screens/add_product.dart';
import 'package:flutter/material.dart';

class PackageList extends StatefulWidget {
  const PackageList({Key? key}) : super(key: key);

  @override
  State<PackageList> createState() => _ProductState();
}

class _ProductState extends State<PackageList> {
  get width => null;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    bool _isLoading = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Package List "),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.white,
      bottomSheet: SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UploadPackages(),
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            height: 45,
            color: Colors.purple,
            child: const Text(
              'Add new package',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          // <2> Pass `Stream<QuerySnapshot>` to stream
          stream: FirebaseFirestore.instance.collection('packages').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 350,
                          child: Stack(children: [
                            Positioned(
                                top: 35,
                                left: 20,
                                child: Material(
                                  child: Container(
                                    height: 400,
                                    width: width * 0.9,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              offset: new Offset(-10.0, 10.0),
                                              blurRadius: 20.0,
                                              spreadRadius: 4.0),
                                        ]),
                                  ),
                                )),
                            Positioned(
                                top: 80,
                                left: 30,
                                child: Card(
                                    elevation: 10,
                                    shadowColor: Colors.grey.withOpacity(0.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Container(
                                      height: 250,
                                      width: 160,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(snapshot
                                              .data!.docs[index]['image']),
                                        ),
                                      ),
                                    ))),
                            Positioned(
                                top: 60,
                                right: 15,
                                left: 200,
                                child: Container(
                                  height: 350,
                                  width: 180,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Title: ${snapshot.data!.docs[index]['title']}",
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.purple,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Price : ${snapshot.data!.docs[index]['price']}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45,
                                          ),
                                        ),
                                        const Divider(
                                          color: Colors.black,
                                        ),
                                        const Text(
                                          "Description",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data!.docs[index]
                                              ['description'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        )
                                      ]),
                                )),
                          ]),
                        ),
                        //
                      ],
                    ),
                  );
                });
          }),
    );
  }
}
