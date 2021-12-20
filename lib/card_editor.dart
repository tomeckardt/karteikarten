import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:mcapp/edit_deck.dart';

import 'card_deck.dart';

class CardEditor extends StatefulWidget {
  const CardEditor({Key? key}) : super(key: key);

  @override
  _CardEditorState createState() => _CardEditorState();
}

class _CardEditorState extends State<CardEditor> {

  late final Box _decks;

  String _newDeckName = '';

  @override
  void initState() {
    _decks = Hive.box("decks");
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
            var correspondingDeck = _decks.getAt(index);
            return Card(
                child: ListTile(
                  title: Text(correspondingDeck.name),
                  leading: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => setState(() {
                      _decks.deleteAt(index);
                    })
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      final page = EditDeck(deck: correspondingDeck);
                      Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, an2) => page,
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
                    },
                  ),
                )
            );
          }
      ),
      bottomNavigationBar: BottomAppBar(child: Padding(padding: const EdgeInsets.all(12), child: Row(
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
              icon: const Icon(Icons.add), label: const Text("Deck")
          )
        ],
      ),
    )));
  }
}