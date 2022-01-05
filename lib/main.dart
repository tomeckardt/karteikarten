import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mcapp/deck_overview.dart';
import 'package:mcapp/edit_deck.dart';
import 'package:mcapp/settings.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:mcapp/card_deck.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(IndexCardAdapter());
  Hive.registerAdapter(DeckAdapter());
  //runApp(const MaterialApp(home: CardEditor()));
  runApp(const MainFrame());
}

class MainFrame extends StatefulWidget {
  const MainFrame({Key? key}) : super(key: key);

  @override
  _MainFrameState createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Navigator(
        onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => const DeckOverview()),
    ), const Settings(), const Center(child: Text("Kommt noch"))
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:
      Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).bottomAppBarColor,
            onTap: (index) => {
              setState(() {
                _currentIndex = index;
              })
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.library_add), label: "Karten"),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Einstellungen"),
              BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: "Statistiken")
            ]
        ),
      ),
    );
  }
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