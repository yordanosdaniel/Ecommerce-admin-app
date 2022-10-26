import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project_admin/screens/add_product.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductState();
}

class _ProductState extends State<ProductList> {
  get width => null;

  Future<void> delete(BuildContext context, String id) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Confirm Delete"),
            content: const Text(
                "All information about this product will be deleted and cannot be undone! Do you want to continue?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No")),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await FirebaseFirestore.instance
                      .collection("products")
                      .doc(id)
                      .delete();
                },
                child: const Text("Yes"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    bool _isLoading = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product List "),
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
              builder: (context) => const UploadProducts(),
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            height: 45,
            color: Colors.purple,
            child: const Text(
              'Add new product',
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
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
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
                          margin: EdgeInsets.symmetric(vertical: 25),
                          child: Column(children: [
                            Card(
                              elevation: 10,
                              shadowColor: Colors.grey.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: 250,
                                        width: 160,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(snapshot
                                                .data!.docs[index]['image']),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            delete(
                                                context,
                                                snapshot.data!.docs[index]
                                                    ['id']);
                                          },
                                          child: Container(
                                            child: Row(
                                              children: const [
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                Text(
                                                  "DELETE",
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 15, bottom: 15),
                                    height: 320,
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
                                  ),
                                ],
                              ),
                            ),
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
