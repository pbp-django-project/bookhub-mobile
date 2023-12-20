import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CollectionTemplate extends StatelessWidget {
  AsyncSnapshot snapshot; 
  int index;
  
  CollectionTemplate(this.snapshot, this.index, {super.key});
  

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(8.0),
      leading: Image.network(snapshot.data![index].fields.coverImg!),
      title: Text(
        "${snapshot.data![index].fields.title}",
        style: const  TextStyle(
          fontWeight: FontWeight.bold
        )
      ),
      subtitle: Text(
        "${snapshot.data![index].fields.authors}"
      ),
      trailing: Text(
        "${snapshot.data![index].fields.pubYear}",
        style:const TextStyle(
          color: Colors.teal
        )
      ),
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ReviewPage.withUsernameAndPict(username: username, pict: pict, pk: snapshot.data![index].pk)
        // ));
      } // Create Navigation to Nano review moduls
    );
  }
}