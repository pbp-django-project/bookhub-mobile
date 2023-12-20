// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:bookhub/collection/screens/collection_list.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';


// ignore: must_be_immutable
class AddCollectionPage extends StatefulWidget {
    String username = "";
    String pict = "";
    AddCollectionPage.withUsernamePict({required this.username, required this.pict, super.key});
    @override
    // ignore: no_logic_in_create_state
    State<AddCollectionPage> createState() => _AddCollectionPageState.withUsernamePict(username: username, pict: pict);
}

class _AddCollectionPageState extends State<AddCollectionPage> {
    final _formKey = GlobalKey<FormState>();
    String _title = "";
    String _authors = "";
    String _publisher = "";
    int _pubYear = 0;
    String _isbn = "";
    String _coverImg = "";
    String username = "";
    String pict = "";
    _AddCollectionPageState.withUsernamePict({required this.username, required this.pict});

    @override
    Widget build(BuildContext context) {
      final request = context.watch<CookieRequest>();
        return Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text(
                'Add Your Collection!',
              ),
            ),
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Title",
                        labelText: "Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _title = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Title is required!";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Author",
                        labelText: "Author",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _authors = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Author is required!";
                        }
                        return null;
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Publisher",
                        labelText: "Publisher",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _publisher = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Publisher is required!";
                        }
                        return null;
                      },
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Publication Year",
                        labelText: "Publication Year",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _pubYear = int.parse(value!);
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Publication Year";
                        }
                        if (int.tryParse(value) == null) {
                          return "Publication Year";
                        }
                        return null;
                      },
                    ),
                  ),

                  Padding(
                  padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "ISBN",
                        labelText: "ISBN",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _isbn = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "ISBN is required";
                        }
                        return null;
                      },
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Cover Link",
                        labelText: "Cover Link",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _coverImg = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Cover link is required";
                        }
                        return null;
                      },
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.teal),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                             final response = await request.postJson(
                            "https://bookhub-f06-tk.pbp.cs.ui.ac.id/collection/add-collection-mobile/",
                            // "http://localhost:8000/collection/add-collection-mobile/",
                            jsonEncode(<String, String>{
                                'username': username,
                                'title': _title,
                                'authors': _authors,
                                'publisher' : _publisher,
                                'pub_year' : _pubYear.toString(),
                                'isbn' : _isbn,
                                'cover_img': _coverImg,
                            }));
                            if (response['status'] == 'success') {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Collection Added!'),
                                    content: SingleChildScrollView(
                                      child: Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Image.network(
                                              _coverImg,
                                              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                return Image.network("https://static.thenounproject.com/png/3674271-200.png");
                                              }
                                            ),
                                            Text('Title: $_title'),
                                            Text('Authors: $_authors'),
                                            Text('Publisher: $_publisher'),
                                            Text('Publication Year: $_pubYear'),
                                            Text('ISBN: $_isbn'),
                                          ],
                                        ),
                                      )
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => CollectionList.withUsernamePict(username: username, pict: pict)),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                    content:
                                        Text("Terdapat kesalahan, silakan coba lagi."),
                                ));
                            }
                          }
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
    }
}