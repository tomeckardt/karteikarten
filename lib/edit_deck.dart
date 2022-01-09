import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive/hive.dart';
import 'package:mcapp/deck_overview.dart';
import 'package:mcapp/head_movement.dart';

import 'settings.dart';
import 'card_deck.dart';
import 'main.dart';

class EditDeck extends StatefulWidget {
  final Deck deck;
  const EditDeck({Key? key, required this.deck}) : super(key: key);

  @override
  _EditDeckState createState() => _EditDeckState();
}

class _EditDeckState extends State<EditDeck> {

  late final Deck _deck;

  Box? _settings;
  bool _connected = false;
  late StreamSubscription _connectionSubscription;
  
  int _expandedCardIndex = -1;

  bool _paused = true;
  final HeadMovementDetector _detector = HeadMovementDetector(threshold: 4000);

  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    _deck = widget.deck;
    _connectionSubscription = ESenseManager().connectionEvents.listen((event) {
        setState(() {
          if (!(_connected = event.type == ConnectionType.connected)) {
            _paused = true;
          }
        });
    });
    _tts.setLanguage("de-DE");
    _connectToESense();
    _detector.onNodRight = _nextCard;
    _detector.onNodLeft = _tellAnswer;
    super.initState();
  }

  Future _toggleRunDeck() async {
    setState(() {
      _paused = !_paused;
    });
    if (_paused) {
      _detector.cancel();
      await _tts.stop();
    } else {
      _detector.initStreamSubscription();
    }
  }

  Future _nextCard() async {
    IndexCard? card = _deck.next();
    if (card == null) return;
    await _tts.speak(card.getQuestion());
  }

  Future _tellAnswer() async {
    IndexCard? card = _deck.current();
    if (card == null) return;
    await _tts.speak(card.getAnswer());
  }

  void _connectToESense() async {
    await ESenseManager().disconnect();
    await ESenseManager().connect(_settings!.get("eSenseName", defaultValue: ""));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //### AppBar #############################################################
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(_deck.name),
        actions: [
          IconButton(
              onPressed: _showAddCardDialog, icon: const Icon(Icons.add)
          )
        ],
      ),
      body: FutureBuilder(
        future: Hive.openBox("settings").then((value) => _settings = Hive.box("settings")),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: _deck.length(),
                itemBuilder: (context, index) {
                  IndexCard card = _deck.getIndexCards().elementAt(index);
                  bool expanded = _expandedCardIndex == index;
                  return Card(
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          _expandedCardIndex = expanded ? -1 : index;
                        });
                      },
                      trailing: IconButton(onPressed: () => _showAddCardDialog(card), icon: const Icon(Icons.edit)),
                      leading: IconButton(onPressed: () => setState(() {
                        _deck.removeIndexCard(index);
                        _deck.save();
                      }), icon: const Icon(Icons.delete)),
                      title: Text(_shorten(card.getQuestion())),
                      subtitle: Text(expanded ? card.getAnswer() : _shorten(card.getAnswer()), overflow: TextOverflow.fade),
                    ),
                  );
                }
            );
          }
          return const Center(child: Text("Einstellungen werden geladen"));
        },
      ),
      floatingActionButton: Wrap(
          children: [
            _connected ? const Spacer() : FloatingActionButton(
              heroTag: "btn1",
              onPressed: () => ESenseManager().connect(_settings!.get("eSenseName", defaultValue: "")),
              child: const Icon(Icons.refresh)
            ),
            const Padding(padding: EdgeInsets.all(10)),
            FloatingActionButton(
              heroTag: "btn2",
              onPressed: _connected ? _toggleRunDeck : null,
              child: Icon(_connected
                  ? _paused ? Icons.play_arrow : Icons.pause
                  : Icons.bluetooth_disabled),
              backgroundColor: _connected ? null : Colors.grey
            )
          ]
      ),
    );
  }

  void _showAddCardDialog([IndexCard? card]) {
    showDialog(context: context, builder: (context) {
      final _formKey = GlobalKey<FormState>();
      final TextEditingController _qController = TextEditingController(text: card?.getQuestion()),
          _aController = TextEditingController(text: card?.getAnswer());
      return Form(
          key: _formKey,
          child: AlertDialog(
            title: Text(card == null ? "Neue Karteikarte" : "Bearbeiten"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                    minLines: 1,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: "Frage"),
                    controller: _qController,
                    validator: (value) =>
                    (value == null || value.isEmpty)
                        ? "Eingabe ist leer" : null
                ),
                const Padding(padding: EdgeInsets.all(12)),
                TextFormField(
                    minLines: 1,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: "Antwort"),
                    controller: _aController,
                    validator: (value) =>
                    (value == null || value.isEmpty)
                        ? "Eingabe ist leer" : null
                )
              ],
            ),
            actions: [
              TextButton(onPressed: Navigator.of(context).pop, child: const Text("Abbrechen")),
              TextButton(onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    if (card == null) {
                      _deck.addIndexCard(_qController.text, _aController.text);
                    } else {
                      card.setQuestion(_qController.text);
                      card.setAnswer(_aController.text);
                    }
                    _deck.save();
                  });
                  Navigator.of(context).pop();
                }
              }, child: const Text("OK"))
            ],
          )
      );
    });
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    _detector.cancel();
    ESenseManager().disconnect();
    super.dispose();
  }

  static String _shorten(String s) {
    final lines = s.split('\n');
    lines[0] += lines.length > 1 ? '...' : '';
    s = lines[0];
    return s.length <= 30 ? s : s.substring(0, 27) + '...';
  }
}

