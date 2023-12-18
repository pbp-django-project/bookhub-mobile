// ignore_for_file: use_build_context_synchronously, avoid_print
import 'package:bookhub/books/models/book.dart';
import 'package:bookhub/homepage/screens/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookhub/reviews/models/review.dart';
import 'package:bookhub/reviews/screens/review_form.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

// ignore: must_be_immutable
class ReviewPage extends StatefulWidget {
  final Books book;
  String username = "";
  String pict = "";
  ReviewPage.withUsernameAndPict({required this.username, required this.pict, required this.book, super.key});

  // ReviewPage({Key? key, required this.book}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _ReviewPageState createState() => _ReviewPageState.withUsernameAndPict(username: username, pict: pict);
}

class _ReviewPageState extends State<ReviewPage> {
  String? loggedInUsername;
  String username = "";
  String pict = "";
  _ReviewPageState.withUsernameAndPict({required this.username, required this.pict});

  @override
  void initState() {
    super.initState();
    getLoggedInUserInfo();
  }

  Future<void> getLoggedInUserInfo() async {
    CookieRequest request = CookieRequest();
    var url =
        Uri.parse('https://bookhub-f06-tk.pbp.cs.ui.ac.id/reviews/check-username-flutter/');

    try {
      var response = await request.postJson(
        url.toString(),
        jsonEncode({
          // Include any request parameters if needed
        }),
      );

      if (response['status'] == 'success') {
        setState(() {
          loggedInUsername = response['username'];
          print('Logged-in Username: $loggedInUsername');
          // Add other user-related data as needed
        });
      } else {
        // Handle error
        print("Failed to fetch user information: ${response.statusCode}");
      }
    } catch (error) {
      // Handle network or other errors
      print("Error: $error");
    }
  }

  Future<List<Review>> fetchReview(int pk) async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse('https://bookhub-f06-tk.pbp.cs.ui.ac.id/reviews/get-review/$pk/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Review> listReview = [];
    for (var d in data) {
      if (d != null) {
        listReview.add(Review.fromJson(d));
      }
    }
    return listReview;
  }

  Future<void> deleteReview(int reviewId) async {
    CookieRequest request = CookieRequest();
    var url = Uri.parse('https://bookhub-f06-tk.pbp.cs.ui.ac.id/reviews/delete-review-flutter/');

    try {
      var response = await request.postJson(
          url.toString(),
          jsonEncode({
            // Include any request parameters if needed
            'review_id': reviewId
          }));

      if (response['status'] == 'success') {
        // Review deleted successfully
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Review deleted successfully"),
        ));

        // Optionally, you can refresh the review list
        setState(() {
          // Perform any necessary updates
        });
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed to delete review"),
        ));
      }
    } catch (error) {
      // Handle network or other errors
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review',
            style: TextStyle(
              color: Colors.white,
            )),
        elevation: 20,
        backgroundColor: Colors.teal,
        shadowColor: Colors.black,
      ),
      drawer: LeftDrawer.withUsernamePict(username: username, pict: pict),
      body: FutureBuilder(
          future: fetchReview(widget.book.pk),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (!snapshot.hasData) {
                return const Column(
                  children: [
                    Text(
                      "Tidak ada data review.",
                      style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
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
                              Text(
                                  "Rating: ${snapshot.data![index].fields.rating} / 5"),
                              const SizedBox(height: 10),
                              Text("${snapshot.data![index].fields.comment}"),
                              const SizedBox(height: 7),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "by: ${snapshot.data![index].fields.username}"),
                                  if (snapshot.data![index].fields.username ==
                                      loggedInUsername)
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                ReviewFormPage.withUsernameAndPict(username: username, pict: pict, book: widget.book, reviewId: snapshot.data![index].pk),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            // Handle delete button press
                                            deleteReview(
                                                snapshot.data![index].pk);
                                          },
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ));
              }
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[300],
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewFormPage.withUsernameAndPict(username: username, pict: pict, book: widget.book)
              ));
        },
        tooltip: 'Add Review',
        child: const SizedBox(
          width: 150, // Adjust the width as needed
          height: 50, // Adjust the height as needed
          child: Center(
            child: Text(
              'Add Review',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
