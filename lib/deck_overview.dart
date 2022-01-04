import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';

import 'edit_deck.dart';
import 'card_deck.dart';
import 'main.dart';

class DeckOverview extends StatefulWidget {
  const DeckOverview({Key? key}) : super(key: key);

  @override
  _DeckOverviewState createState() => _DeckOverviewState();
}

class _DeckOverviewState extends State<DeckOverview> {

  late Box _decks;

  String _newDeckName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Decks")),
      bottomSheet: FutureBuilder(
        future: Hive.openBox("decks").then((value) => _decks = Hive.box("decks")),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
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
                                Utils.switchTo(context, page);
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
          return const Center(child: Text("Decks werden geladen", style: TextStyle(color: Colors.grey)));
        }
      ));

  }
}