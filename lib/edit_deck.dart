import 'package:flutter/material.dart';

import 'card_deck.dart';

class EditDeck extends StatefulWidget {
  final Deck deck;
  const EditDeck({Key? key, required this.deck}) : super(key: key);

  @override
  _EditDeckState createState() => _EditDeckState();
}

class _EditDeckState extends State<EditDeck> {

  late final Deck _deck;

  final _formKey = GlobalKey<FormState>();
  //Temporäre Attribute
  final TextEditingController _qController = TextEditingController(), _aController = TextEditingController();

  @override
  void initState() {
    _deck = widget.deck;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Navigator.of(context).pop
        ),
        title: Text(_deck.name),
      ),
      body: ListView.builder(
        itemCount: _deck.length(),
        itemBuilder: (context, index) {
          IndexCard card = _deck.getIndexCards().elementAt(index);
          return Card(
            child: ListTile(
              trailing: IconButton(onPressed: () => setState(() {
                _deck.removeIndexCard(index);
              }), icon: const Icon(Icons.delete)),
              title: Text(_shorten(card.getQuestion())),
              subtitle: Text(_shorten(card.getAnswer())),
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(context: context, builder: (context) =>
                Form(
                    key: _formKey,
                    child: AlertDialog(
                        title: const Text("Neue Karteikarte"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                                controller: _qController,
                                validator: (value) => (value == null || value.isEmpty)
                                  ? "Eingabe ist leer" : null
                            ),
                            TextFormField(
                                controller: _aController,
                                validator: (value) => (value == null || value.isEmpty)
                                  ? "Eingabe ist leer" : null
                            )
                          ],
                        ),
                        actions: [
                          TextButton(onPressed: Navigator.of(context).pop, child: const Text("Abbrechen")),
                          TextButton(onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _deck.addIndexCard(_qController.text, _aController.text);
                                _deck.save();
                              });
                              Navigator.of(context).pop();
                            }
                          }, child: const Text("OK"))
                        ],
                )));
          }, child: const Icon(Icons.add)
      )
    );
  }
}

String _shorten(String s) {
  return s.length <= 30 ? s : s.substring(0, 27) + '...';
}