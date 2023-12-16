import 'dart:convert';
import 'package:bookhub/bulletin/screens/list_bulletin.dart';
import 'package:bookhub/homepage/screens/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';


class BulletinFormPage extends StatefulWidget {
    const BulletinFormPage({super.key});

    @override
    State<BulletinFormPage> createState() => _BulletinFormPageState();
}

class _BulletinFormPageState extends State<BulletinFormPage> {
    final _formKey = GlobalKey<FormState>();
    String _title = "";
    String _author = "";
    DateTime _datePublished = DateTime.now(); 
    String _content = "";
    
    @override
    Widget build(BuildContext context) {
      final request = context.watch<CookieRequest>();
      return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Form Add Bulletin',
            ),
          ),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        drawer: const LeftDrawer(),
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
                      hintText: "title",
                      labelText: "title",
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
                        return "Title tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "author",
                      labelText: "author",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _author = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Author tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "date_published",
                      labelText: "date published",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onTap: () async {
                    // Tampilkan date picker
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: _datePublished,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    // Jika pengguna memilih tanggal, tampilkan time picker
                    if (date != null) {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_datePublished),
                      );

                      // Jika pengguna memilih waktu, gabungkan tanggal dan waktu
                      if (time != null) {
                        setState(() {
                          _datePublished = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    }
                  },
                  validator: (String? value) {
                    if (_datePublished == null) {
                      return "Date published tidak boleh kosong!";
                    }
                    return null;
                  },
                  readOnly: true,
                  controller: TextEditingController(
                    text: _datePublished != null
                        ? DateFormat('yyyy-MM-dd HH:mm').format(_datePublished)
                        : '',
                  ),
                ),
                ),
              
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "content",
                      labelText: "content",
                       
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _content = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "content tidak boleh kosong!";
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
                              // Kirim ke Django dan tunggu respons
                              
                              final response = await request.postJson(
                              "http://127.0.0.1:8000/bulletin/create-flutter/",
                              jsonEncode(<String, String>{
                                  'title': _title,
                                  'author': _author,
                                  'date_published': DateFormat('yyyy-MM-dd HH:mm').format(_datePublished),
                                  'content': _content,
                              }));
                              if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                  content: Text("Bulletin baru berhasil disimpan!"),
                                  ));
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => BulletinPage()),
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
              ]
          ),
        ),
      )
    );
  }
}