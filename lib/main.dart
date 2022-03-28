import 'package:flutter/material.dart';

import 'package:redditech/login.dart';
import 'package:redditech/home.dart';
import 'package:redditech/profile.dart';
import 'package:redditech/settings.dart';

void main() => runApp(MaterialApp(
  // initialRoute: '/home',

  routes: {
    '/': (context) => Login(),
    '/home': (context) => Home(),
    '/profile': (context) => Profile(),
    '/settings': (context) => SettingsMenu(),
  },
));
