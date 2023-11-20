import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inventory',
           style: TextStyle(
            color: Colors.white,
          )
        ),
        elevation: 20,
        backgroundColor: Colors.grey,
        shadowColor: Colors.black,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  "Iqza's Inventory",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // GridView.count(
              //   primary: true,
              //   padding: const EdgeInsets.all(20),
              //   crossAxisSpacing: 10,
              //   mainAxisSpacing: 10,
              //   crossAxisCount: 3,
              //   shrinkWrap: true,
              //   children: items.map((InventoryItem item) {
              //     return InventoryCard(item);
              //   }).toList(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}