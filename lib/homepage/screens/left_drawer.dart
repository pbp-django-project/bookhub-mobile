import 'package:bookhub/books/screens/book_list.dart';
import 'package:bookhub/homepage/screens/login.dart';
import 'package:bookhub/homepage/screens/menu.dart';
import 'package:bookhub/homepage/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class LeftDrawer extends StatelessWidget {
  LeftDrawer({super.key});
  LeftDrawer.withUsernamePict({required this.username, required this.pict, super.key});
  String username = '';
  String pict = '';

  _launchURL() async {
    final Uri url = Uri.parse('http://127.0.0.1:8000/');
    if (!await launchUrl(url)) {
      throw Exception('Tidak bisa membuka url');
    }
  }

  _launchURLWebApp() async {
    final Uri url = Uri.parse('https://bookhub-f06-tk.pbp.cs.ui.ac.id');
    if (!await launchUrl(url)) {
      throw Exception('Tidak bisa membuka url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Column(
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 222, 184, 135),
                  ),
                ),
              ]
            ),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(pict),
            ),
            decoration: const BoxDecoration(
              color: Colors.teal,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage.withUsernameAndPict(username: username, pict: pict),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage.withUsernamePict(username: username, pict: pict),
                  ));
            },
            // showDialog<String>(
            //   context: context,
            //   builder: (BuildContext context) => AlertDialog(
            //     title: const Text('Sorry'),
            //     content: const Text('Maaf, fungsi update profil pengguna harus menggunakan aplikasi web kami. Silahkan tekan OK jika ingin meng-update profil Anda.'),
            //     actions: <Widget>[
            //       TextButton(
            //         onPressed: () => Navigator.pop(context, 'Cancel'),
            //         child: const Text('Cancel'),
            //       ),
            //       TextButton(
            //         onPressed: () {
            //           _launchURL();
            //           Navigator.pop(context, 'OK');
            //         },
            //         child: const Text('OK'),
            //       ),
            //     ],
            //   ),
            // ),
          ),
          ListTile(
            leading: const Icon(Icons.web),
            title: const Text('Our Web App'),
            onTap: () {
              _launchURLWebApp();
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Daftar Buku'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => BookList.withUsernamePict(username: username, pict: pict),
                )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              final response =
                  await request.logout("http://127.0.0.1:8000/auth/logout/");
              String message = response["message"];
              if (response['status']) {
                String uname = response["username"];
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$message Sampai jumpa, $uname."),
                ));
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false);
              } else {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(message),
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}
