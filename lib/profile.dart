import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class User {
  final String name;
  final String publicDescription;
  final int karma;
  final String iconImg;
  final String bannerImg;

  User({
    required this.name,
    required this.publicDescription,
    required this.karma,
    required this.iconImg,
    required this.bannerImg,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      publicDescription: json['subreddit']['public_description'],
      karma: json['total_karma'],
      iconImg: json['subreddit']['icon_img'].substring(0, json['subreddit']['icon_img'].indexOf('?')),
      bannerImg: json['subreddit']['banner_img'].substring(0, json['subreddit']['icon_img'].indexOf('?')),
    );
  }
}

class _ProfileState extends State<Profile> {
  final LocalStorage storage = LocalStorage('Reeedditech');
  late Future<User> futureUser;

  Future<User> fetchUser() async {
    final response = await http.get(Uri.parse('https://oauth.reddit.com/api/v1/me'),
        headers: {
          'authorization': 'bearer ' + storage.getItem('access_token'),
        });

    if (response.statusCode == 200) {
      print("PROFILE API CALL SUCCESSFUL: " + response.statusCode.toString());
      return (User.fromJson(jsonDecode(response.body)));
    } else {
      print("SOMETHING IS WRONG IN HOME: " + response.statusCode.toString());
      throw Exception('Failed to fetch User');
    }
  }

  @override
  void initState() {
    futureUser = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'minecraft',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            tooltip: 'profile',
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FutureBuilder<User>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 7),
                      ),
                      child: ClipRRect(
                        child: Image.network(
                          snapshot.data!.iconImg,
                          width: 280.0,
                          height: 280.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
            SizedBox(height: 40.0),
            Text(
              "username: ",
              style: TextStyle(
                fontFamily: 'minecraft',
                color: Colors.white,
              ),
            ),
            FutureBuilder<User>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    "    " + snapshot.data!.name,
                    style: TextStyle(
                      fontFamily: 'minecraft',
                      color: Colors.white,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
            SizedBox(height: 15.0),
            Text(
              "description: ",
              style: TextStyle(
                fontFamily: 'minecraft',
                color: Colors.white,
              ),
            ),
            FutureBuilder<User>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    "    \"" + snapshot.data!.publicDescription + "\"",
                    style: TextStyle(
                      fontFamily: 'minecraft',
                      color: Colors.white,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
            SizedBox(height: 15.0),
            Text(
              "karma: ",
              style: TextStyle(
                fontFamily: 'minecraft',
                color: Colors.white,
              ),
            ),
            FutureBuilder<User>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    "    " + snapshot.data!.karma.toString(),
                    style: TextStyle(
                      fontFamily: 'minecraft',
                      color: Colors.white,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}