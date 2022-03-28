import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

import 'package:redditech/home.dart';

class _LoginState extends State<Login> {
  final LocalStorage storage = LocalStorage('Reeedditech');
  final flutterWebviewPlugin = FlutterWebviewPlugin();

  late StreamSubscription _onDestroy;
  late StreamSubscription<String> _onUrlChanged;
  late StreamSubscription<WebViewStateChanged> _onStateChanged;

  late String code;

  void getAccessToken(String code) async {
    Map data = {
      'grant_type' : 'authorization_code',
      'code' : code,
      'redirect_uri' : 'https://www.google.com/',
    };
    String auth =
        'Basic ' + base64Encode(utf8.encode('3BygA6gdKZBvdqVI1l70Xw:'));
    final response = await http.post(Uri.parse('https://www.reddit.com/api/v1/access_token'),
      headers: {
        HttpHeaders.authorizationHeader: auth,
        HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'},
      body: data,
    );
    final jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      storage.setItem('access_token', jsonResponse['access_token']);
    } else {
      print("SOMETHING IS WRONG IN LOGIN: " + response.statusCode.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.close();

    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      print("ALL YOUR BASE BELONG TO US (destroyed view)");
    });

    _onStateChanged = flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      print("STATE CHANGED: ${state.type} ${state.url}");
    });

    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          print("URL CHANGED: $url");
          if (url.contains("code=")) {
            RegExp regExp = RegExp("(?<=code=).*?(?=#)");
            code = regExp.firstMatch(url)!.group(0)!;
            storage.setItem('code', code);
            getAccessToken(code);
            print("code: " + code);
            print("access_token: " + storage.getItem('access_token'));
            Navigator
                .of(context)
                .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Home()));
            flutterWebviewPlugin.close();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String loginUrl = "https://www.reddit.com/api/v1/authorize.compact?client_id=3BygA6gdKZBvdqVI1l70Xw&response_type=code&scope=identity account edit mysubreddits privatemessages read report submit subscribe vote&duration=temporary&state=RANDOM_STRING&redirect_uri=https://www.google.com/";

    return WebviewScaffold(
      url: loginUrl,
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            fontFamily: 'minecraft',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}