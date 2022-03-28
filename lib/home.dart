import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class Post {
  final String subredditName;
  final String title;
  final String thumbnail;

  Post({
    required this.subredditName,
    required this.title,
    required this.thumbnail,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      subredditName: json['subreddit_name_prefixed'],
      title: json['title'],
      thumbnail: json['thumbnail'],
    );
  }
}

class _HomeState extends State<Home> {
  final LocalStorage storage = LocalStorage('Reeedditech');
  late Future<List<Post>> futurePosts;
  final ScrollController _scrollController = ScrollController();
  String after = "none";

  List<Post> getPosts(Map<String, dynamic> json) {
    List<Post> posts = [];
    print("test");
    after = json['data']['after'];
    print(after);
    for (var i = 0; i < json['data']['children'].length; i++) {
      print(json['data']['children'][i]);
      posts.add(Post.fromJson(json['data']['children'][i]['data']));
    }
    print("FIN DE TEST");
    return (posts);
  }

  Future<List<Post>> fetchPosts(String sort) async {
    final response = await http.get(Uri.parse('https://oauth.reddit.com/' + sort),
        headers: {
          'authorization': 'bearer ' + storage.getItem('access_token'),
        });

    if (response.statusCode == 200) {
      print("PROFILE API CALL SUCCESSFUL: " + response.statusCode.toString());
      return (getPosts(jsonDecode(response.body)));
    } else {
      print("SOMETHING IS WRONG IN HOME: " + response.statusCode.toString());
      throw Exception('Failed to fetch Posts');
    }
  }

  @override
  void initState() {
    print("STARTING INIT STATE");
    futurePosts = fetchPosts("best");

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        setState(() {
          print("best/?after" + after);
          futurePosts = fetchPosts("best/?after=" + after);
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
  }

  Container findThumbnail(String thumbnailUrl) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.white, width: 7),
      ),
      child: ClipRRect(
        child: Image.network(
          thumbnailUrl,
          width: 140.0,
          height: 140.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          title: const Text(
            'Reeedditech',
            style: TextStyle(
              fontFamily: 'minecraft',
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              tooltip: 'profile',
            )
          ],
        ),
        body:FutureBuilder<List<Post>>(
                future: futurePosts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const CircularProgressIndicator();
                  } if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  List<Post> posts = snapshot.data ?? [];
                  return ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      Post post = posts[index];
                      return Container(
                          padding: EdgeInsets.fromLTRB(10.0, 7.5, 10.0, 0.0),
                        child: Card(
                          color: Colors.deepPurpleAccent,                        elevation: 5,
                          child: Padding(
                              padding: EdgeInsets.all(7),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[/*
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white, width: 7),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(3),
                                        child: Image.network(
                                          post.,
                                          width: 280.0,
                                          height: 280.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),*/
                                    Text(
                                      post.subredditName,
                                      style: TextStyle(
                                        fontFamily: 'minecraft',
                                       color: Colors.white,
                                      ),
                                   ),
                                  ]
                                ),
                                SizedBox(height: 7.5),
                                Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded (
                                        child: Text(
                                      post.title,
                                      style: TextStyle(
                                        fontFamily: 'minecraft',
                                        color: Colors.white,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                    ),
                                       post.thumbnail != 'self' && post.thumbnail != 'image' && post.thumbnail != 'nsfw' && post.thumbnail != 'default' ?
                                         findThumbnail(post.thumbnail) :
                                         SizedBox.shrink()
                                  ]
                                )
                              ]
                            )
                          )
                          )
                      );
                    },
                  );
                },
              ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}