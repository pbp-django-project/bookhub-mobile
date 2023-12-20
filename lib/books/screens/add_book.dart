// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:bookhub/books/screens/book_list.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';


// ignore: must_be_immutable
class AddBookPage extends StatefulWidget {
    String username = "";
    String pict = "";
    AddBookPage.withUsernamePict({required this.username, required this.pict, super.key});
    @override
    // ignore: no_logic_in_create_state
    State<AddBookPage> createState() => _AddBookPageState.withUsernamePict(username: username, pict: pict);
}

class _AddBookPageState extends State<AddBookPage> {
    final _formKey = GlobalKey<FormState>();
    String _title = "";
    String _authors = "";
    String _publisher = "";
    int _pubYear = 0;
    String _isbn = "";
    String _coverImg = "";
    String username = "";
    String pict = "";
    _AddBookPageState.withUsernamePict({required this.username, required this.pict});

    @override
    Widget build(BuildContext context) {
      final request = context.watch<CookieRequest>();
        return Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text(
                'Add Your Own Book!',
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
                        hintText: "Authors",
                        labelText: "Authors",
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
                          return "Authors is required!";
                        }
                        return null;
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Publishers",
                        labelText: "Publishers",
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
                          return "Publishers is required!";
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
                          return "Publication Year is Required";
                        }
                        if (int.tryParse(value) == null) {
                          return "Publication Year must be Integer";
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
                          return "ISBN is Required";
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
                          print(username);
                          if (_formKey.currentState!.validate()) {
                             final response = await request.postJson(
                            "https://bookhub-f06-tk.pbp.cs.ui.ac.id/books/add-books-mobile/",
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
                                    title: const Text('Books Added!'),
                                    content: SingleChildScrollView(
                                      child: Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Image.network(
                                                _coverImg,
                                                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                  return Image.network("https://static.thenounproject.com/png/3674271-200.png");
                                                }
                                              )
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
                                            MaterialPageRoute(builder: (context) => BookList.withUsernamePict(username: username, pict: pict)),
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