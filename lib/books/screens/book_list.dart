import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bookhub/books/widgets/book_template.dart';
import 'package:bookhub/books/models/book.dart';
import 'package:bookhub/books/models/userbook.dart';
import 'package:http/http.dart' as http;

class BookList extends StatefulWidget {
 
  @override
  _BookListState createState() => _BookListState();

}

final List<String> filter = ['All', 'Title', 'Author', 'Pub Year'];
class _BookListState extends State<BookList> {
  // Search Query
  String search = '';
  //Filter Query
  String filterSelected = filter.first;

  Future<List<dynamic>> fetchBooks({String searchQuery='', String filterQuery='All'}) async {
    var url = Uri.parse('http://127.0.0.1:8000/books/book-json/');
    var response = await http.get(url, 
      headers: {"Content-Type": "application/json"}
    );

    var book_data = jsonDecode(utf8.decode(response.bodyBytes)); //json here

    List<Books> list_books = [];
    for (var book in book_data) {
      if (book != null) {
        list_books.add(Books.fromJson(book));
      }
    }

    url = Uri.parse('http://127.0.0.1:8000/books/userbook-json/');
    response = await http.get(url,
      headers: {"Content-Type": "application/json"}
    );

    var userbook_data = jsonDecode(utf8.decode(response.bodyBytes));

    List<UserBooks> list_userbooks = [];
    for (var userbook in userbook_data) {
      if (userbook != null) {
        list_userbooks.add(UserBooks.fromJson(userbook));
      }
    }

    List<dynamic> combined_list = [];
    if (filterQuery == "Title") {
      List<Books> book_by_title = list_books.where((element) => element.fields.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      List<UserBooks> userbooks_by_title = list_userbooks.where((element) => element.fields.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      combined_list.addAll(book_by_title);
      combined_list.addAll(userbooks_by_title);
    }
    else if (filterQuery == "Author") {
      List<Books> book_by_author = list_books.where((element) => element.fields.authors.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      List<UserBooks> userbooks_by_author = list_userbooks.where((element) => element.fields.authors.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      combined_list.addAll(book_by_author);
      combined_list.addAll(userbooks_by_author);
    }
    else if (filterQuery == "Pub Year") {
      List<Books> book_by_pubyear = list_books.where((element) => element.fields.pubYear.toString().contains(searchQuery)).toList();
      List<UserBooks> userbooks_by_pubyear = list_userbooks.where((element) => element.fields.pubYear.toString().contains(searchQuery)).toList();
      combined_list.addAll(book_by_pubyear);
      combined_list.addAll(userbooks_by_pubyear);
    }
    else if (filterQuery == "All") {
      List<Books> book_by_title = list_books.where((element) => element.fields.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      List<UserBooks> userbooks_by_title = list_userbooks.where((element) => element.fields.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      combined_list.addAll(book_by_title);
      combined_list.addAll(userbooks_by_title);
      List<Books> book_by_author = list_books.where((element) => element.fields.authors.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      List<UserBooks> userbooks_by_author = list_userbooks.where((element) => element.fields.authors.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      combined_list.addAll(book_by_author);
      combined_list.addAll(userbooks_by_author);
      List<Books> book_by_pubyear = list_books.where((element) => element.fields.pubYear.toString().contains(searchQuery)).toList();
      List<UserBooks> userbooks_by_pubyear = list_userbooks.where((element) => element.fields.pubYear.toString().contains(searchQuery)).toList();
      combined_list.addAll(book_by_pubyear);
      combined_list.addAll(userbooks_by_pubyear);
    }
   

    return combined_list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text( 
              "Search a Book",
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold
              )
            ),
            SizedBox(
              height: 20.0
            ),
            Row(
              children: [
                DropdownButton<String>(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 3),
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
                SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() {
                      search = value;
                    }),
                    style: TextStyle(
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
                      prefixIcon: Icon(Icons.search),
                      prefixIconColor: Colors.teal
                    ),
                  )
                ),
              ]
            ),
            SizedBox(
              height: 20.0
            ),
            FutureBuilder(
              future: fetchBooks(searchQuery: search, filterQuery: filterSelected), 
              builder: (context, AsyncSnapshot snapshot) {
                // TODO: Create listview
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => BookTemplate(snapshot, index)
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
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {} //TODO: Create add book function
      ),
    );
  }
}