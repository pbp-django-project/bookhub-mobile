import 'dart:convert';
import 'package:bookhub/collection/screens/add_collection.dart';
import 'package:bookhub/homepage/screens/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:bookhub/collection/widgets/collection_template.dart';
import 'package:bookhub/books/models/book.dart';
import 'package:bookhub/collection/models/usercollection.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class CollectionList extends StatefulWidget {
  CollectionList({super.key});
  CollectionList.withUsernamePict({required this.username, required this.pict, super.key});
  String username = '';
  String pict = '';

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _CollectionListState createState() => _CollectionListState.withUsernamePict(username: username, pict: pict);
}

final List<String> filter = ['All', 'Title', 'Author', 'Pub Year'];
class _CollectionListState extends State<CollectionList> {
  // Search Query
  String search = '';
  //Filter Query
  String filterSelected = filter.first;
  String username = '';
  String pict = '';
  _CollectionListState.withUsernamePict({required this.username, required this.pict});

  Future<List<dynamic>> fetchCollections({String searchQuery='', String filterQuery='All'}) async {
    // var url = Uri.parse('https://bookhub-f06-tk.pbp.cs.ui.ac.id/collection/collection-json/');
    var url = Uri.parse('http://localhost:8000/collection/collection-json/');
    var response = await http.get(url, 
      headers: {"Content-Type": "application/json"}
    );

    var collectionData = jsonDecode(utf8.decode(response.bodyBytes)); //json here

    Set<Collection> uniqueCollections = {};

  for (var collection in collectionData) {
    if (collection != null) {
      Collection col = Collection.fromJson(collection);
      bool matchesSearchQuery = col.fields.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                                col.fields.authors.toLowerCase().contains(searchQuery.toLowerCase()) ||
                                col.fields.pubYear.toString().contains(searchQuery);

      if (filterQuery == 'All' && matchesSearchQuery) {
        uniqueCollections.add(col);
      } else if (filterQuery == 'Title' && col.fields.title.toLowerCase().contains(searchQuery.toLowerCase())) {
        uniqueCollections.add(col);
      } else if (filterQuery == 'Author' && col.fields.authors.toLowerCase().contains(searchQuery.toLowerCase())) {
        uniqueCollections.add(col);
      } else if (filterQuery == 'Pub Year' && col.fields.pubYear.toString().contains(searchQuery)) {
        uniqueCollections.add(col);
      }
    }
  }

  return uniqueCollections.toList();
}
//     List<Collection> list_collection = [];
//     // int counter = 0;
//     for (var collection in collection_data) {
//       if (collection != null) {
//         list_collection.add(Collection.fromJson(collection));
//         // counter++;

//         // if (counter == 0) {
//         //   break; // This will exit the current block of code
//         // }
//       }
//     }

// // url = Uri.parse('http://127.0.0.1:8000/collection/collection-json/');
// // response = await http.get(url,
// //   headers: {"Content-Type": "application/json"}
// // );

// // var userbook_data = jsonDecode(utf8.decode(response.bodyBytes));

//     // List<UserCollection> list_userbooks = [];
//     // for (var userbook in userbook_data) {
//     //   if (userbook != null) {
//     //     list_userbooks.add(UserBooks.fromJson(userbook));
//     //   }
//     // }

//     List<dynamic> combined_list = [];
//     if (filterQuery == "Title") {
//       // List<Collection> book_by_title = list_books.where((element) => element.fields.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
//       List<Collection> usercollection_by_title = list_collection.where((element) => element.fields.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
//       // combined_list.addAll(book_by_title);
//       combined_list.addAll(usercollection_by_title);
//     }
//     else if (filterQuery == "Author") {
//       // List<Collection> collection_by_author = list_collection.where((element) => element.fields.authors.toLowerCase().contains(searchQuery.toLowerCase())).toList();
//       List<Collection> usercollection = list_collection.where((element) => element.fields.authors.toLowerCase().contains(searchQuery.toLowerCase())).toList();
//       // combined_list.addAll(collection_by_author);
//       combined_list.addAll(usercollection);
//     }
//     else if (filterQuery == "Pub Year") {
//       // List<Collection> collection_by_pubyear = list_collection.where((element) => element.fields.pubYear.toString().contains(searchQuery)).toList();
//       List<Collection> usercollection_by_pubyear = list_collection.where((element) => element.fields.pubYear.toString().contains(searchQuery)).toList();
//       // combined_list.addAll(collection_by_pubyear);
//       combined_list.addAll(usercollection_by_pubyear);
//     }
//     else if (filterQuery == "All") {
//       // List<Collection> collection_by_title = list_collection.where((element) => element.fields.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
//       List<Collection> usercollection_by_title = list_collection.where((element) => element.fields.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
//       // combined_list.addAll(collection_by_title);
//       combined_list.addAll(usercollection_by_title);
//       // List<Collection> collection_by_author = list_collection.where((element) => element.fields.authors.toLowerCase().contains(searchQuery.toLowerCase())).toList();
//       List<Collection> usercollection = list_collection.where((element) => element.fields.authors.toLowerCase().contains(searchQuery.toLowerCase())).toList();
//       // combined_list.addAll(collection_by_author);
//       combined_list.addAll(usercollection);
//       // List<Collection> collection_by_pubyear = list_collection.where((element) => element.fields.pubYear.toString().contains(searchQuery)).toList();
//       List<Collection> usercollection_by_pubyear = list_collection.where((element) => element.fields.pubYear.toString().contains(searchQuery)).toList();
//       // combined_list.addAll(collection_by_pubyear);
//       combined_list.addAll(usercollection_by_pubyear);
//     }

//     return combined_list;
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              "Search your Collection",
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
                      hintText: "eg: To Kill a Mockingbird",
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
              future: fetchCollections(searchQuery: search, filterQuery: filterSelected), 
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => CollectionTemplate(snapshot, index)
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
              // COLLECTION LIST DI LINE 208 GANTI JADI ADDCOLLECTION
              // builder: (context) => CollectionList.withUsernamePict(username: username, pict: pict)
              builder: (context) => AddCollectionPage.withUsernamePict(username: username, pict: pict)
            )
          );
        }
      ),
    );
  }
}