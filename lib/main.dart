// import 'package:bookhub/homepage/screens/menu.dart';
import 'package:flutter/material.dart';
// import 'package:bookhub/homepage/screens/login.dart';
import 'package:bookhub/books/screens/book_list.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'BookHub',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
          useMaterial3: true,
        ),
        home: const BookList(), // jangan lupa ganti ke LoginPage().
      )
    );
  }
}
