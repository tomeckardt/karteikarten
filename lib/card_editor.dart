import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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

  String _newDeckName = '';

  @override
  void initState() {
    _decks = Hive.box("decks");
    _meta = Hive.box("metadata");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Decks")),
      body: _decks.isEmpty
        ? const Center(child: Text("Es gibt keine Decks."))
        : ListView.builder(
          itemCount: _decks.length,
          itemBuilder: (context, index) {
            return Card(
                child: ListTile(
                  title: Text(_decks.getAt(index).name),
                  leading: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => setState(() {
                      _decks.deleteAt(index);
                    })
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                )
            );
          }
      ),
      bottomSheet: Padding(padding: const EdgeInsets.all(12), child: Row(
        children: [
          Expanded(child: TextField(
            decoration: InputDecoration(
              labelText: "Name des Decks",
              errorText: _decks.containsKey(_newDeckName)
                  ? "Name bereits vergeben"
                  : null
            ),
            onChanged: (value) => setState(() {
              _newDeckName = value;
            })
          )),
          const Padding(padding: EdgeInsets.all(12)),
          ElevatedButton.icon(onPressed: (_newDeckName == '' || _decks.containsKey(_newDeckName)) ? null :
              () {
                  setState(() {
                    _decks.put(_newDeckName, Deck(_newDeckName));
                  });
              },
              icon: const Icon(Icons.add), label: const Text("Deck hinzufügen")
          )
        ],
      ),
    ));
  }
}