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

class Utils {

  static void switchTo(BuildContext context, Widget widget) {
    Navigator.of(context).push(
        PageRouteBuilder(
            pageBuilder: (context, animation, an2) => widget,
            transitionDuration: const Duration(milliseconds: 100),
            reverseTransitionDuration: const Duration(milliseconds: 100),
            transitionsBuilder: (context, an1, an2, child) {
              return SlideTransition(
                position: Tween(
                    begin: const Offset(1.0, 0.0),
                    end: const Offset(0.0, 0.0))
                    .animate(an1),
                child: child,
              );
            }
        )
    );
  }
}