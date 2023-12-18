import 'dart:convert';
import 'package:bookhub/bulletin/screens/list_bulletin.dart';
import 'package:bookhub/homepage/screens/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BulletinFormPage extends StatefulWidget {
  BulletinFormPage({super.key});
  String username = "";
  String pict = "";
  BulletinFormPage.withUsernameAndPict({required this.username, required this.pict, super.key});

  @override
  // ignore: no_logic_in_create_state
  State<BulletinFormPage> createState() => _BulletinFormPageState.withUsernameAndPict(username: username, pict: pict);
}

class _BulletinFormPageState extends State<BulletinFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _author = "";
  DateTime _datePublished = DateTime.now();
  String _content = "";
  String username = "";
  String pict = "";
  _BulletinFormPageState.withUsernameAndPict({required this.username, required this.pict});

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
      drawer: LeftDrawer.withUsernamePict(username: username, pict: pict),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            width: 800.0,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
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
                    const SizedBox(height: 10.0),
                    TextFormField(
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
                    const SizedBox(height: 10.0),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "date_published",
                        labelText: "date published",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onTap: () async {
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: _datePublished,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (date != null) {
                          // ignore: use_build_context_synchronously
                          TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(_datePublished),
                          );

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
                      readOnly: true,
                      controller: TextEditingController(
                        text: DateFormat('yyyy-MM-dd HH:mm')
                            .format(_datePublished),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
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
                    const SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.teal),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final response = await request.postJson(
                              "https://bookhub-f06-tk.pbp.cs.ui.ac.id/bulletin/create-flutter/",
                              jsonEncode(<String, String>{
                                'title': _title,
                                'author': _author,
                                'date_published': DateFormat('yyyy-MM-dd HH:mm')
                                    .format(_datePublished),
                                'content': _content,
                              }),
                            );
                            if (response['status'] == 'success') {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Bulletin baru berhasil disimpan!"),
                                ),
                              );
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BulletinPage.withUsernameAndPict(username: username, pict: pict)),
                              );
                            } else {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Terdapat kesalahan, silakan coba lagi."),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
