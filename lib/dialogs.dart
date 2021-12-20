part of 'card_editor.dart';

// ### Neues Deck #################################################

String _currentText = '';

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
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
            ],
            decoration: const InputDecoration(labelText: "Frage"),
            onChanged: (value) => _q = value,
          ),
          TextField(
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
            ],
            decoration: const InputDecoration(labelText: "Antwort"),
            onChanged: (value) => _a = value,
          )
        ],
      ),
    ),
    actions: [
      TextButton(onPressed: Navigator.of(state.context).pop, child: const Text("Abbrechen")),
      TextButton(onPressed: () {
        //state.updateDeck(IndexCard(_q, _a));
        Navigator.of(state.context).pop();
      }, child: const Text("OK"))
    ],
  );
}