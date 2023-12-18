import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookhub/bulletin/models/bulletin.dart';
import 'package:bookhub/books/models/book.dart';
import 'package:bookhub/books/widgets/book_template.dart';
import 'package:bookhub/bulletin/screens/bulletinlist_form.dart';
import 'package:bookhub/bulletin/screens/detail_bulletin.dart';
import 'package:bookhub/homepage/screens/left_drawer.dart';

// ignore: must_be_immutable
class BulletinPage extends StatefulWidget {
  BulletinPage({Key? key}) : super(key: key);
  String username = "";
  String pict = "";
  BulletinPage.withUsernameAndPict(
      {required this.username, required this.pict, Key? key})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _BulletinPageState createState() =>
      _BulletinPageState.withUsernameAndPict(username: username, pict: pict);
}

class _BulletinPageState extends State<BulletinPage> {
  String _query = "";
  String username = "";
  String pict = "";
  _BulletinPageState.withUsernameAndPict(
      {required this.username, required this.pict});

  Future<List<Books>> fetchBookRecomendation() async {
    var url = Uri.parse(
        'http://127.0.0.1:8000/bulletin/book-recomendation/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
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

  Future<List<Bulletin>> fetchBulletin() async {
    var url = Uri.parse('http://127.0.0.1:8000/bulletin/json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Bulletin> listBulletin = [];
    for (var d in data) {
      if (d != null) {
        listBulletin.add(Bulletin.fromJson(d));
      }
    }

    if (_query.isNotEmpty) {
      listBulletin = listBulletin.where((bulletin) {
        return bulletin.fields.title
                .toLowerCase()
                .contains(_query.toLowerCase()) ||
            bulletin.fields.content
                .toLowerCase()
                .contains(_query.toLowerCase());
      }).toList();
    }
    return listBulletin;
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
      drawer: LeftDrawer.withUsernamePict(username: username, pict: pict),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 10),
                  child: Text(
                    'BookHub',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 8.0, top: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextField(
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.teal,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                            ),
                            hintText: 'Search...',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _query = value;
                            });
                            // Handle search logic here
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BulletinFormPage.withUsernameAndPict(
                                username: username, pict: pict),
                      ),
                    );
                  },
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 70),
                    padding: const EdgeInsets.all(19),
                    margin: const EdgeInsets.only(right: 10, top: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.teal,
                    ),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: fetchBulletin(),
              builder: (context, AsyncSnapshot<List<Bulletin>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.data!.isEmpty) {
                    // ignore: sized_box_for_whitespace
                    return Container(
                      width: 700,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 125, right: 25.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'No result found for "',
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 20),
                                      children: [
                                        TextSpan(
                                          // ignore: unnecessary_string_interpolations
                                          text: '$_query',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const TextSpan(
                                          text:
                                              '". Please try a different search.',
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const Icon(
                                  IconData(0xf34a, fontFamily: 'MaterialIcons'),
                                  size: 300.0,
                                  color: Colors.teal,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2.0,
                        ),
                        padding: const EdgeInsets.only(
                          top: 30,
                          left: 115,
                          right: 20,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailBulletinPage.withUsernameAndPict(
                                            username: username,
                                            pict: pict,
                                            bulletinPk:
                                                snapshot.data![index].pk),
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
                            Container(
                              constraints: const BoxConstraints(maxWidth: 750),
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(
                                      text: snapshot.data![index].fields.content
                                                  .length >
                                              300
                                          ? '${snapshot.data![index].fields.content.substring(0, 300).replaceAll('\r\n\r\n', '')}...'
                                          : snapshot.data![index].fields.content
                                              .replaceAll('\r\n\r\n', ''),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
              },
            ),
            Container(
              margin: const EdgeInsets.only(top: 252),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                border: Border.all(
                  color: Colors.teal,
                  width: 1.5,
                ),
                color: const Color.fromARGB(255, 240, 240, 240),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book,
                          color: Colors.teal,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Book Recommendation',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      ),
                    ),
                    child: FutureBuilder(
                      future: fetchBookRecomendation(),
                      builder: (context, AsyncSnapshot<List<Books>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) =>
                                  BookTemplate.withUsernameAndPict(
                                      username: username,
                                      pict: pict,
                                      snapshot: snapshot,
                                      index: index));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
