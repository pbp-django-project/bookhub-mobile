import 'package:bookhub/books/models/book.dart';
import 'package:bookhub/books/widgets/book_template.dart';
import 'package:bookhub/bulletin/screens/bulletinlist_form.dart';
import 'package:bookhub/bulletin/screens/detail_bulletin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookhub/bulletin/models/bulletin.dart';
import 'package:bookhub/homepage/screens/left_drawer.dart';

class BulletinPage extends StatefulWidget {
  const BulletinPage({Key? key}) : super(key: key);

  @override
  BulletinPageState createState() => BulletinPageState();
}

class BulletinPageState extends State<BulletinPage> {

  String _query = "";
  //search Query 
  Future<List<Books>> fetchBookRecomendation() async {
    var url = Uri.parse('http://127.0.0.1:8000/bulletin/book-recomendation/');
    var response = await http.get(
      url,
      headers: { "Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Books> listBook = [];
    for (var d in data) {
      if (d != null) {
        listBook.add(Books.fromJson(d));
      }
    }
    return listBook;


  }

  Future<List<Bulletin>> fetchProduct() async {
    var url = Uri.parse('http://127.0.0.1:8000/bulletin/json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Bulletin> listProduct = [];
    for (var d in data) {
      if (d != null) {
        listProduct.add(Bulletin.fromJson(d));
      }
    }
    return listProduct;
  }

  Future<List<Bulletin>> fetchBulletin() async {
    var url =
        Uri.parse('http://127.0.0.1:8000/bulletin/json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Bulletin> listSearch = [];
    for (var d in data) {
      if (d != null) {
        listSearch.add(Bulletin.fromJson(d));
        
      }
    }

    if(_query.isNotEmpty){
      listSearch = listSearch.where((bulletin){
        return bulletin.fields.title.toLowerCase().contains(_query.toLowerCase()) ||
        bulletin.fields.content.toLowerCase().contains(_query.toLowerCase());
      }).toList();
    }
    return listSearch;
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        'Bulletin',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      elevation: 20,
      backgroundColor: Colors.teal,
      shadowColor: Colors.black,
    ),
    drawer: const LeftDrawer(),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 8.0, top: 10),
                child: TextField(
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.teal,
                        ),
                        borderRadius:
                            BorderRadius.all(Radius.circular(25.0))),
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      // Set state or variables used by FutureBuilder
                      _query = value;
                    });
                    // Handle search logic here
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 10),
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BulletinFormPage(),
                      ));
                },
                child: Container(
                  padding: const EdgeInsets.all(19),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.teal,
                  ),
                  child: const Text(
                    "Add",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
        FutureBuilder(
          future: _query.isEmpty ? fetchProduct() : fetchBulletin(),
          builder: (context, AsyncSnapshot<List<Bulletin>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.data!.isEmpty) {
                return Column(
                  children: [
                    Text(
                      "No result found for '$_query'. Please try a different search.",
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    )
                  ],
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) => Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailBulletinPage(
                                    bulletinPk: snapshot.data![index].pk,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              snapshot.data![index].fields.title,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            snapshot.data![index].fields.content.length > 200 ? '${snapshot.data![index].fields.content.substring(0, 400)}...' : snapshot.data![index].fields.content,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }
          },
        ),
        FutureBuilder(
          future: fetchBookRecomendation(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) =>
                        BookTemplate(snapshot, index)),
              );
            }
          },
        )
      ], // Add a comma here
    ),
  );
}
}

