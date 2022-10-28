import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoggedIn = false;
  Map user = {};
  @override
  Widget build(BuildContext context) {
    log(user.toString());
    return Scaffold(
      body: Center(
        child: isLoggedIn == true
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.network(user["picture"]["data"]["url"])),
                  Text(user["name"]),
                  Text(user["email"]),
                  ElevatedButton(
                    onPressed: () {
                      FacebookAuth.instance.logOut().then((value) {
                        setState(() {
                          isLoggedIn = false;
                          user = {};
                        });
                      });
                    },
                    child: const Text('Sign out'),
                  ),
                ],
              )
            : Center(
                child: ElevatedButton(
                  child: const Text('Sign in with facebook'),
                  onPressed: () async {
                    FacebookAuth.instance.login(
                        permissions: ["public_profile", "email"]).then((value) {
                      FacebookAuth.instance
                          .getUserData()
                          .then((userData) async {
                        setState(() {
                          isLoggedIn = true;
                          user = userData;
                        });
                      });
                    });
                  },
                ),
              ),
      ),
    );
  }
}
