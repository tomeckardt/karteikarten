import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mcapp/card_editor.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:mcapp/card_deck.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(IndexCardAdapter());
  Hive.registerAdapter(DeckAdapter());
  runApp(const MaterialApp(home: CardEditor()));
}
