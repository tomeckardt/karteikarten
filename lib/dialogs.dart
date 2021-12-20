part of 'card_editor.dart';

// ### Neues Deck #################################################

String _currentText = '';

AlertDialog _showAddDeckDialog(_CardEditorState state) {
    return AlertDialog(
      title: const Text("Neues Deck"),
      content: TextField(
        onChanged: (value) {
          _currentText = value;
        },
        decoration: const InputDecoration(
            labelText: "Name des Decks"
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(state.context).pop,
          child: const Text("Abbrechen")
        ),
        TextButton(onPressed: () {
          state.updateDecks(_currentText);
          Navigator.of(state.context).pop();
        }, child: const Text("OK"))
      ],
    );
}

//### Neue Karteikarte ########################################
String _q = '', _a = '';

AlertDialog _showAddCardDialog(_CardEditorState state) {
  return AlertDialog(
    title: const Text("Neue Karteikarte"),
    content: Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: "Frage"),
            onChanged: (value) => _q = value,
          ),
          TextField(
            decoration: const InputDecoration(labelText: "Antwort"),
            onChanged: (value) => _a = value,
          )
        ],
      ),
    ),
    actions: [
      TextButton(onPressed: Navigator.of(state.context).pop, child: const Text("Abbrechen")),
      TextButton(onPressed: () {
        state.updateDeck(IndexCard(_q, _a));
        Navigator.of(state.context).pop();
      }, child: const Text("OK"))
    ],
  );
}