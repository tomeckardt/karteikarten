import 'package:flutter/material.dart';

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
      //### AppBar #############################################################
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Navigator.of(context).pop
        ),
        title: Text(_deck.name),
        actions: [
          ElevatedButton.icon(onPressed: _showAddCardDialog, icon: const Icon(Icons.add), label: const Text("Karte"))
        ],
      ),
      body: ListView.builder(
        itemCount: _deck.length(),
        itemBuilder: (context, index) {
          IndexCard card = _deck.getIndexCards().elementAt(index);
          return Card(
            child: ListTile(
              trailing: IconButton(onPressed: () => setState(() {
                _deck.removeIndexCard(index);
                _deck.save();
              }), icon: const Icon(Icons.delete)),
              title: Text(_shorten(card.getQuestion())),
              subtitle: Text(_shorten(card.getAnswer())),
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { },
        child: const Icon(Icons.play_arrow),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Padding(
            child: Row(
              children: [
                const Text("Nicht verbunden", style: TextStyle(color: Colors.red)),
                IconButton(onPressed: () { }, icon: const Icon(Icons.refresh)),
                const Spacer(),
                ElevatedButton.icon(onPressed: () => Utils.switchTo(context, const Settings()), icon: const Icon(Icons.settings), label: const Text("Einstellungen"))
              ],
            ),
            padding: const EdgeInsets.all(10),
        ),
      ),
    );
  }

  void _showAddCardDialog() {
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
            )
        )
    );
  }

  static String _shorten(String s) {
    return s.length <= 30 ? s : s.substring(0, 27) + '...';
  }
}

