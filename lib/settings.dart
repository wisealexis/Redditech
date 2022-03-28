import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class Preferences {
  final bool videoAutoplay;
  final bool nightMode;
  final bool noProfanity;
  final bool adultContent;
  final bool hideAds;
  final bool showTwitter;

  Preferences({
    required this.videoAutoplay,
    required this.nightMode,
    required this.noProfanity,
    required this.adultContent,
    required this.hideAds,
    required this.showTwitter,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      videoAutoplay: json['video_autoplay'],
      nightMode: json['nightmode'],
      noProfanity: json['no_profanity'],
      adultContent: json['over_18'],
      hideAds: json['hide_ads'],
      showTwitter: json['show_twitter'],
    );
  }
}

class _SettingsMenuState extends State<SettingsMenu> {
  final LocalStorage storage = LocalStorage('Reeedditech');
  late Future<Preferences> futurePreferences;

  Future<Preferences> fetchPreferences() async {
    final response = await http.get(Uri.parse('https://oauth.reddit.com/api/v1/me/prefs'),
        headers: {
          'authorization': 'bearer ' + storage.getItem('access_token'),
        });

    if (response.statusCode == 200) {
      print("PROFILE API CALL SUCCESSFUL: " + response.statusCode.toString());
      return (Preferences.fromJson(jsonDecode(response.body)));
    } else {
      print("SOMETHING IS WRONG IN HOME: " + response.statusCode.toString());
      throw Exception('Failed to fetch User');
    }
  }

  Future<Preferences> patchPreferences(String setting, bool newValue) async {
    final response = await http.patch(Uri.parse('https://oauth.reddit.com/api/v1/me/prefs'),
        headers: {
          'authorization': 'bearer ' + storage.getItem('access_token'),
          'Content-Type': 'text/plain'
        },
        body: '{"$setting": "$newValue"}'
    );

    if (response.statusCode == 200) {
      print("PROFILE API PATCH CALL SUCCESSFUL: " + setting + newValue.toString() + response.statusCode.toString());
      return (Preferences.fromJson(jsonDecode(response.body)));
    } else {
      print("SOMETHING IS WRONG IN PROFILE: " + response.statusCode.toString());
      throw Exception('Failed to fetch User');
    }
  }

  @override
  void initState() {
    futurePreferences = fetchPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'minecraft',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "video autoplay: ",
              style: TextStyle(
                fontFamily: 'minecraft',
                color: Colors.white,
              ),
            ),
            FutureBuilder<Preferences>(
              future: futurePreferences,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Switch(
                    value: snapshot.data!.videoAutoplay,
                    onChanged: (value) {
                      setState(() {
                        patchPreferences("video_autoplay", !snapshot.data!.videoAutoplay);
                        print("SEND PATCH TO REDDIT");
                        futurePreferences = fetchPreferences();
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
            SizedBox(height: 17.5),
            Text(
              "nightmode: ",
              style: TextStyle(
                fontFamily: 'minecraft',
                color: Colors.white,
              ),
            ),
            FutureBuilder<Preferences>(
              future: futurePreferences,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Switch(
                    value: snapshot.data!.nightMode,
                    onChanged: (value) {
                      setState(() {
                        patchPreferences("nightmode", !snapshot.data!.nightMode);
                        print("SEND PATCH TO REDDIT");
                        futurePreferences = fetchPreferences();
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
            SizedBox(height: 17.5),
            Text(
              "no profanity: ",
              style: TextStyle(
                fontFamily: 'minecraft',
                color: Colors.white,
              ),
            ),
            FutureBuilder<Preferences>(
              future: futurePreferences,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Switch(
                    value: snapshot.data!.noProfanity,
                    onChanged: (value) {
                      setState(() {
                        patchPreferences("no_profanity", !snapshot.data!.noProfanity);
                        print("SEND PATCH TO REDDIT");
                        futurePreferences = fetchPreferences();
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
            SizedBox(height: 17.5),
            Text(
              "disable sensible content : ",
              style: TextStyle(
                fontFamily: 'minecraft',
                color: Colors.white,
              ),
            ),
            FutureBuilder<Preferences>(
              future: futurePreferences,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Switch(
                    value: snapshot.data!.adultContent,
                    onChanged: (value) {
                      setState(() {
                        patchPreferences("over_18", !snapshot.data!.adultContent);
                        print("SEND PATCH TO REDDIT");
                        futurePreferences = fetchPreferences();
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
            SizedBox(height: 17.5),
            Text(
              "hide ads: ",
              style: TextStyle(
                fontFamily: 'minecraft',
                color: Colors.white,
              ),
            ),
            FutureBuilder<Preferences>(
              future: futurePreferences,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Switch(
                    value: snapshot.data!.hideAds,
                    onChanged: (value) {
                      setState(() {
                        patchPreferences("hide_ads", !snapshot.data!.hideAds);
                        print("SEND PATCH TO REDDIT");
                        futurePreferences = fetchPreferences();
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
            SizedBox(height: 17.5),
            Text(
              "show twitter: ",
              style: TextStyle(
                fontFamily: 'minecraft',
                color: Colors.white,
              ),
            ),
            FutureBuilder<Preferences>(
              future: futurePreferences,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Switch(
                    value: snapshot.data!.showTwitter,
                    onChanged: (value) {
                      setState(() {
                        patchPreferences("show_twitter", !snapshot.data!.showTwitter);
                        print("SEND PATCH TO REDDIT");
                        futurePreferences = fetchPreferences();
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
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

class SettingsMenu extends StatefulWidget {
  @override
  _SettingsMenuState createState() => _SettingsMenuState();
}