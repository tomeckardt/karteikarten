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

  void updateDecks(String newDeck) async {
    setState(() {
      _decks.add(newDeck);
      _meta.put("selectedDeck", newDeck);
    });
    Hive.openBox(newDeck);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        Expanded(child: FutureBuilder(
          future: loadCurrentDeck(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            var current = _meta.get("selectedDeck");
            if (!snapshot.hasData) {
              return const Center(child: Text("Decks werden geladen...", style: TextStyle(color: Colors.grey)));
            }
            if (current == null) {
              return const Center(child: Text("Es gibt noch keine Decks.", style: TextStyle(color:Colors.grey)));
            }

            final Box box = Hive.box(current);
            var button = FloatingActionButton(onPressed: () {

            }, child: const Icon(Icons.add));

            if (box.isEmpty) {
              return Scaffold(
                  floatingActionButton: button,
                  body: const Center(child: Text("Das Deck ist leer.", style: TextStyle(color: Colors.grey)))
              );
            }
            return Expanded(child: ListView.builder(
                itemCount: box.values.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(box.getAt(index).getQuestion())
                  );
                }
            ));
          },
        ))
      ]
    );
  }
}