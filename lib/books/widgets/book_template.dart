import 'package:flutter/material.dart';
import 'package:bookhub/reviews/screens/review_list.dart';

// ignore: must_be_immutable
class BookTemplate extends StatelessWidget {
  AsyncSnapshot snapshot;
  int index;
  String username = "";
  String pict = "";
  BookTemplate.withUsernameAndPict({required this.username, required this.pict, required this.snapshot, required this.index, super.key});
  
  // BookTemplate(this.snapshot, this.index, {super.key});
  

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: Image.network(snapshot.data![index].fields.coverImg!,
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            return Image.network("https://static.thenounproject.com/png/3674271-200.png");
          }
        ),
        title: Text("${snapshot.data![index].fields.title}",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${snapshot.data![index].fields.authors}"),
        trailing: Text("${snapshot.data![index].fields.pubYear}",
            style: const TextStyle(color: Colors.teal)),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewPage.withUsernameAndPict(username: username, pict: pict, pk: snapshot.data![index].pk)
              ));
        });
  }
}
