import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'card_deck.dart';

class CardEditor extends StatefulWidget {
  const CardEditor({Key? key}) : super(key: key);

  @override
  _CardEditorState createState() => _CardEditorState();
}

class _CardEditorState extends State<CardEditor> {

  List<Deck> _decks = [];
  Deck? _selected;
  String? _newDeckName;
  late final Box _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box("cardeditor");
    _selected = _box.get("selected");
    print(_selected);
    _decks = _box.get("decks") ?? [];
  }

  void _showAddCardDialog() {
    String? q, a;
    if (_selected == null) return; //Sollte eigentlich nie passieren
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text("Neue Karte"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                  labelText: "Frage"
              ),
              onChanged: (value) {
                q = value;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: "Antwort"
              ),
              onChanged: (value) {
                a = value;
              }
            )
          ]
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Abbrechen")
          ),
          TextButton(
              onPressed: () {
                if (q != null && a != null) {
                  setState(() {
                    _selected!.getIndexCards().add(IndexCard(q!, a!));
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text("OK")
          )
        ],
      );
    });
  }

  void _showAddDeckDialog() {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text("Neues Deck"),
        content: TextField(
          decoration: const InputDecoration(
            labelText: "Deckname"
          ),
          onChanged: (value) {
            _newDeckName = value;
          },
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Abbrechen")
          ),
          TextButton(
              onPressed: () {
                if (_newDeckName != null) {
                  setState(() {
                    Deck deck = Deck(_newDeckName!);
                    _selected = deck;
                    _decks.add(deck);
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text("OK")
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const  EdgeInsets.all(12),
        child: Scaffold(
            floatingActionButton:
              _selected == null ? null : FloatingActionButton(onPressed: _showAddCardDialog, child: const Icon(Icons.add)),
            body: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: DropdownButton(
                          items:
                          _decks.map((e) => DropdownMenuItem<Deck>(
                              child: Text(e.name),
                              value: e
                          )).toList(growable: true),
                          hint: const Text("Keine Decks"),
                          onChanged: (value) {
                            setState(() {
                              _selected = value as Deck;
                              print(_selected);
                              _box.put("selected", _selected);
                              print(_box.get("selected"));
                            });

                          },
                          value: _selected,
                          isExpanded: true,
                        )
                    ),
                    const Padding(padding: EdgeInsets.all(12)),
                    ElevatedButton.icon(
                        onPressed: _showAddDeckDialog,
                        label: const Text("Deck hinzufügen"),
                        icon: const Icon(Icons.add))
                  ],
                ),
                const Padding(padding: EdgeInsets.all(20)),
                Scrollbar(
                    child: _selected == null
                        ? Container()
                        : _selected!.getIndexCards().isEmpty
                          ? const Text("Dieses Deck ist leer", style: TextStyle(color: Colors.grey))
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _selected!.getIndexCards().map((e) => Text(e.getQuestion())).toList(),
                            )
                )
              ],
            )
        )
    );
  }
}