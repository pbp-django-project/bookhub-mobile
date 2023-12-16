import 'package:bookhub/bulletin/screens/list_bulletin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookhub/bulletin/models/bulletin.dart';
import 'package:bookhub/homepage/screens/left_drawer.dart';

class DetailBulletinPage extends StatefulWidget {
  final int bulletinPk;
  const DetailBulletinPage({required this.bulletinPk, Key? key})
      : super(key: key);

  @override
  DetailBulletinPageState createState() => DetailBulletinPageState();
}

class DetailBulletinPageState extends State<DetailBulletinPage> {
  Future<List<Bulletin>> fetchProduct() async {
    var url =
        Uri.parse('http://127.0.0.1:8000/bulletin/json/${widget.bulletinPk}/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Bulletin> listProduct = [];
    for (var d in data) {
      if (d != null) {
        listProduct.add(Bulletin.fromJson(d));
      }
    }
    return listProduct;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bulletin',
              style: TextStyle(
                color: Colors.white,
              )),
          elevation: 20,
          backgroundColor: Colors.teal,
          shadowColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BulletinPage(),
                  ));
            },
          ),
        ),
        drawer: const LeftDrawer(),
        body: FutureBuilder(
            future: fetchProduct(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (!snapshot.hasData) {
                  return const Column(
                    children: [
                      Text(
                        "Tidak ada data bulletin.",
                        style: TextStyle(
                            color: Color.fromARGB(255, 239, 44, 44),
                            fontSize: 20),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${snapshot.data![index].fields.title}",
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(snapshot.data![index].fields.author),
                                const SizedBox(height: 10),
                                Text(
                                    snapshot.data![index].fields.datePublished.toString().substring(0, 19)),
                                const SizedBox(height: 10),
                                Text("${snapshot.data![index].fields.content}"),
                              ],
                            ),
                          ));
                }
              }
            }));
  }
}
