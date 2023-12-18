import 'package:bookhub/books/models/book.dart';
import 'package:bookhub/reviews/screens/review_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';

// ignore: must_be_immutable
class ReviewFormPage extends StatefulWidget {
  final Books book;
  final int? reviewId;
  String username = "";
  String pict = "";
  ReviewFormPage.withUsernameAndPict({required this.username, required this.pict, required this.book, this.reviewId, super.key});

  // ReviewFormPage({Key? key, required this.book, this.reviewId}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<ReviewFormPage> createState() => _ReviewFormPageState.withUsernameAndPict(username: username, pict: pict);
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  int _rating = 0;
  String _comment = "";
  String username = "";
  String pict = "";
  _ReviewFormPageState.withUsernameAndPict({required this.username, required this.pict});
  @override
  Widget build(BuildContext context) {
    CookieRequest request = CookieRequest();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add Review',
          ),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  hintText: "Rating (1-5)",
                  labelText: "Rating (1-5)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _rating = int.parse(value!);
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Rating tidak boleh kosong!";
                  }
                  int rating = int.tryParse(value) ?? 0;
                  if (rating < 1 || rating > 5) {
                    return "Rating harus berada di antara 1 dan 5!";
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[1-5]$')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Comment",
                  labelText: "Comment",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _comment = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Comment tidak boleh kosong!";
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
                    backgroundColor: MaterialStateProperty.all(Colors.teal),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Kirim ke Django dan tunggu respons
                      final response = await (widget.reviewId == null
                            ? request.postJson(
                                "http://127.0.0.1:8000/reviews/create-review-flutter/",
                                jsonEncode(<String, String>{
                                  'title': _title,
                                  'rating': _rating.toString(),
                                  'comment': _comment,
                                  'book_id': widget.book.pk.toString(),
                                }),
                              )
                            : request.postJson(
                                "http://127.0.0.1:8000/reviews/edit-review-flutter/",
                                jsonEncode(<String, String>{
                                  'title': _title,
                                  'rating': _rating.toString(),
                                  'comment': _comment,
                                  'book_id': widget.book.pk.toString(),
                                  'review_id' : widget.reviewId.toString(),
                                }),
                              ));
                      if (response['status'] == 'success') {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Review baru berhasil disimpan!"),
                        ));
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ReviewPage.withUsernameAndPict(username: username, pict: pict, book: widget.book)
                            ));
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content:
                              Text("Terdapat kesalahan, silakan coba lagi."),
                        ));
                      }
                    }
                    _formKey.currentState!.reset();
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
