import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BookTemplate extends StatelessWidget {
  AsyncSnapshot snapshot;
  int index;
  
  BookTemplate(this.snapshot, this.index);
  

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(8.0),
      leading: Image.network(snapshot.data![index].fields.coverImg!),
      title: Text(
        "${snapshot.data![index].fields.title}",
        style: TextStyle(
          fontWeight: FontWeight.bold
        )
      ),
      subtitle: Text(
        "${snapshot.data![index].fields.authors}"
      ),
      trailing: Text(
        "${snapshot.data![index].fields.pubYear}",
        style: TextStyle(
          color: Colors.teal
        )
      ),
      onTap: () {} //TODO : Create a navigation to Nano review moduls
    );
  }
}