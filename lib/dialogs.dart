part of 'card_editor.dart';


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