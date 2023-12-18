import 'package:bookhub/homepage/screens/left_drawer.dart';
import 'package:bookhub/homepage/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(ProfileApp());
}

// ignore: must_be_immutable
class ProfileApp extends StatelessWidget {
  ProfileApp({super.key});
  String username = '';
  String pict = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile App',
      home: ProfilePage.withUsernamePict(username: username, pict: pict),
    );
  }
}

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  ProfilePage.withUsernamePict(
      {required this.username, required this.pict, super.key});
  String username = '';
  String pict = '';
  TextEditingController pictController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  _launchURLWebApp() async {
    final Uri url = Uri.parse('https://bookhub-f06-tk.pbp.cs.ui.ac.id');
    if (!await launchUrl(url)) {
      throw Exception('Tidak bisa membuka url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('BookHub',
              style: TextStyle(
                color: Colors.white,
              )),
          elevation: 20,
          backgroundColor: Colors.teal,
          shadowColor: Colors.black,
        ),
        drawer: LeftDrawer.withUsernamePict(username: username, pict: pict),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 70.0,
                    backgroundImage: NetworkImage(
                      pict,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0), // Add padding here
                    child: TextFormField(
                      controller: pictController,
                      decoration: const InputDecoration(
                        labelText: 'Masukkan URL Foto Profil',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () async {
                      String pict = pictController.text;
                      final response = await request
                          .post("http://127.0.0.1:8000/auth/update/", {
                        'pict': pict,
                      });
                      if (response["status"] == true) {
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyHomePage.withUsernameAndPict(
                                      username: username, pict: pict)),
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Update failed'),
                          ),
                        );
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save),
                        SizedBox(width: 8.0),
                        Text('Save'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0), // Add padding here
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Sorry!'),
                            content: const Text('Ganti Password Harus Menggunakan Web App Kami.'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  _launchURLWebApp();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage.withUsernameAndPict(username: username, pict: pict),
                                    )
                                  );
                                },
                              ),
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text(
                        "Ganti Password",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ))
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
