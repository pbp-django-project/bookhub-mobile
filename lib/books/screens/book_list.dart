import 'dart:convert';
import 'package:bookhub/books/screens/add_book.dart';
import 'package:bookhub/homepage/screens/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:bookhub/books/widgets/book_template.dart';
import 'package:bookhub/books/models/book.dart';
import 'package:bookhub/books/models/userbook.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class BookList extends StatefulWidget {
  BookList({super.key});
  BookList.withUsernamePict({required this.username, required this.pict, super.key});
  String username = '';
  String pict = '';

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _BookListState createState() => _BookListState.withUsernamePict(username: username, pict: pict);

}

final List<String> filter = ['All', 'Title', 'Author', 'Pub Year'];
class _BookListState extends State<BookList> {
  // Search Query
  String search = '';
  //Filter Query
  String filterSelected = filter.first;
  String username = '';
  String pict = '';
  _BookListState.withUsernamePict({required this.username, required this.pict});

  Future<List<dynamic>> fetchBooks({String searchQuery='', String filterQuery='All'}) async {
    var url = Uri.parse('https://bookhub-f06-tk.pbp.cs.ui.ac.id/books/book-json/');
    var response = await http.get(url, 
      headers: {"Content-Type": "application/json"}
    );

    var bookData = jsonDecode(utf8.decode(response.bodyBytes)); //json here

    List<Books> listBooks = [];
    for (var book in bookData) {
      if (book != null) {
        listBooks.add(Books.fromJson(book));
      }
    }

    url = Uri.parse('https://bookhub-f06-tk.pbp.cs.ui.ac.id/books/userbook-json/');
    response = await http.get(url,
      headers: {"Content-Type": "application/json"}
    );

    var userbookData = jsonDecode(utf8.decode(response.bodyBytes));

    List<UserBooks> listUserbooks = [];
    for (var userbook in userbookData) {
      if (userbook != null) {
        listUserbooks.add(UserBooks.fromJson(userbook));
      }
    }

    List<dynamic> combinedList = [];
    if (filterQuery == "Title") {
      List<Books> bookByTitle = listBooks.where((element) => element.fields.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      List<UserBooks> userbooksByTitle = listUserbooks.where((element) => element.fields.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      combinedList.addAll(bookByTitle);
      combinedList.addAll(userbooksByTitle);
    }
    else if (filterQuery == "Author") {
      List<Books> bookByAuthor = listBooks.where((element) => element.fields.authors.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      List<UserBooks> userbooksByAuthor = listUserbooks.where((element) => element.fields.authors.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      combinedList.addAll(bookByAuthor);
      combinedList.addAll(userbooksByAuthor);
    }
    else if (filterQuery == "Pub Year") {
      List<Books> bookByPubyear = listBooks.where((element) => element.fields.pubYear.toString().contains(searchQuery)).toList();
      List<UserBooks> userbooksByPubyear = listUserbooks.where((element) => element.fields.pubYear.toString().contains(searchQuery)).toList();
      combinedList.addAll(bookByPubyear);
      combinedList.addAll(userbooksByPubyear);
    }
    else if (filterQuery == "All") {
      List<Books> bookByTitle = listBooks.where((element) => element.fields.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      List<UserBooks> userbooksByTitle = listUserbooks.where((element) => element.fields.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      combinedList.addAll(bookByTitle);
      combinedList.addAll(userbooksByTitle);
      List<Books> bookByAuthor = listBooks.where((element) => element.fields.authors.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      List<UserBooks> userbooksByAuthor = listUserbooks.where((element) => element.fields.authors.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      combinedList.addAll(bookByAuthor);
      combinedList.addAll(userbooksByAuthor);
      List<Books> bookByPubyear = listBooks.where((element) => element.fields.pubYear.toString().contains(searchQuery)).toList();
      List<UserBooks> userbooksByPubyear = listUserbooks.where((element) => element.fields.pubYear.toString().contains(searchQuery)).toList();
      combinedList.addAll(bookByPubyear);
      combinedList.addAll(userbooksByPubyear);
    }
   

    return combinedList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white12,
      appBar: AppBar(
        title: const Text(
          'BookHub',
           style: TextStyle(
            color: Colors.white,
          )
        ),
        elevation: 20,
        backgroundColor: Colors.teal,
        shadowColor: Colors.black,
        // backgroundColor: Colors.white12,
      ),
      drawer: LeftDrawer.withUsernamePict(username: username, pict: pict),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text( 
              "Search a Book",
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold
              )
            ),
            const SizedBox(
              height: 20.0
            ),
            Row(
              children: [
                DropdownButton<String>(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 3),
                  value: filterSelected,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 6,
                  style: const TextStyle(color: Colors.teal),
                  underline: Container(
                    height: 3,
                    color: Colors.teal,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      filterSelected = value!;
                    });
                  },
                  items: filter.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() {
                      search = value;
                    }),
                    style: const TextStyle(
                      color: Colors.teal
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none
                      ),
                      hintText: "eg: Harry Potter",
                      prefixIcon: const Icon(Icons.search),
                      prefixIconColor: Colors.teal
                    ),
                  )
                ),
              ]
            ),
            const SizedBox(
              height: 20.0
            ),
            FutureBuilder(
              future: fetchBooks(searchQuery: search, filterQuery: filterSelected), 
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => BookTemplate.withUsernameAndPict(username: username, pict: pict, snapshot: snapshot, index: index)
                    )
                  );
                }
              }
            )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[300],
        focusColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBookPage.withUsernamePict(username: username, pict: pict)
            )
          );
        }
      ),
    );
  }
}