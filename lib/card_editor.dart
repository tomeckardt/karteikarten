import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'card_deck.dart';

part 'dialogs.dart';

class CardEditor extends StatefulWidget {
  const CardEditor({Key? key}) : super(key: key);

  @override
  _CardEditorState createState() => _CardEditorState();
}

class _CardEditorState extends State<CardEditor> {

  late final Box _decks, _meta;
  Box? _currentBox;

  @override
  void initState() {
    _decks = Hive.box("decks");
    _meta = Hive.box("metadata");
    super.initState();
  }

  Future loadCurrentDeck() async {
    var current = _meta.get("selectedDeck", defaultValue: []);
    if (current == null) return;
    return Hive.openBox(current);
  }

  //Wird aufgerufen, wenn man ein neues Deck erstellt
  void updateDecks(String newDeck) async {
    setState(() {
      _decks.add(newDeck);
      _meta.put("selectedDeck", newDeck);
    });
    Hive.openBox(newDeck).then((value) => _currentBox = Hive.box(newDeck));
  }

  void updateDeck(IndexCard newCard) {
    final current = _meta.get("selectedDeck");
    assert(current != null);
    final box = Hive.box(current);
    setState(() {
      box.add(newCard);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(12), child: Column(
      children: [
        Row(
          children: [
            Expanded(child: DropdownButton(
              items: _decks.values.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              hint: const Text("Keine Decks"),
              isExpanded: true,
              onChanged: (value) async {
                var current = _meta.get("selectedDeck");
                setState(() {
                  _meta.put("selectedDeck", value);
                });
              },
              value: _meta.get("selectedDeck"),
            )),
            const Padding(padding: EdgeInsets.all(12)),
            ElevatedButton.icon(onPressed: () {
              showDialog(context: context, builder: (context) => _showAddDeckDialog(this));
            }, icon: const Icon(Icons.add), label: const Text("Deck erstellen"))
          ],
        ),
        Expanded(child: Scaffold(
          floatingActionButton: _currentBox == null ? null : FloatingActionButton(
            onPressed: () {

            }, child: const Icon(Icons.add),
          ),
          body: _currentBox == null
              ? const Center(child: Text("Es gibt keine Decks", style: TextStyle(color: Colors.grey)))
              : Expanded(child: ListView.builder(
                    itemCount: _currentBox!.length,
                    itemBuilder: (context, index) {
                      return Text(_currentBox!.getAt(index).getQuestion());
                    }
                )
          )
        ))
      ]
    ));
  }
}